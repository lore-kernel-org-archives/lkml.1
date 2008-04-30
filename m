Return-Path: <linux-kernel-owner+w=401wt.eu-S1759567AbYD3Lme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759567AbYD3Lme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 07:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756045AbYD3LmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 07:42:21 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:48774 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762655AbYD3LmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 07:42:20 -0400
Date: Wed, 30 Apr 2008 13:41:07 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Message-ID: <20080430114107.GE3002@enneenne.com>
References: <1207851751-25703-2-git-send-email-giometti@linux.it> <1207851751-25703-3-git-send-email-giometti@linux.it> <1207851751-25703-4-git-send-email-giometti@linux.it> <1207851751-25703-5-git-send-email-giometti@linux.it> <1207851751-25703-6-git-send-email-giometti@linux.it> <20080410210918.3be98868@core> <20080411075515.GH26777@enneenne.com> <20080411092840.3cc4de67@core> <20080411134724.GF2160@csclub.uwaterloo.ca> <20080411154652.4852b6d4@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080411154652.4852b6d4@core>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 5/7] PPS: serial clients support.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 03:46:52PM +0100, Alan Cox wrote:
> 
> uart_ is only used by some drivers. We have a whole army of drivers using
> the tty layer directly and another army of drivers using the USB layer.
> 
> You also need a sensible way to talk to the devices, identify support and
> avoid clashing uses of carrier pins.

Hello Alan,

if I add a dedicated line discipline to register/unregister the PPS
source and I leave the pps_event management into
uart_handle_dcd_change() function, it can be acceptable?

The uart_handle_dcd_change() is generic and I need the DCD status to
correctly manage the pps_event. The USB layer is not useful for PPS
stuff.

Thanks for your suggestions,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@linux.it
Embedded Systems                     phone:	+39 349 2432127
UNIX programming                     skype:     rodolfo.giometti
