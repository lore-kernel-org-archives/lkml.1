Return-Path: <linux-kernel-owner+w=401wt.eu-S1752575AbYJ0Iyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbYJ0Iyo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 04:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbYJ0Iyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 04:54:35 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:51389 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbYJ0Iyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 04:54:35 -0400
Date: Mon, 27 Oct 2008 09:54:14 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Message-ID: <20081027085414.GH11339@tekkaman>
References: <1224683240-15439-2-git-send-email-giometti@linux.it> <20081022174004.GB10587@kroah.com> <20081022111145.e5f3c632.akpm@linux-foundation.org> <20081022195245.GS4390@tekkaman> <20081022130150.00836eba.akpm@linux-foundation.org> <20081022204800.GT4390@tekkaman> <20081022135810.37c564f8.akpm@linux-foundation.org> <20081022210352.GA29754@kroah.com> <20081023073957.GU4390@tekkaman> <20081023153733.GA4011@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023153733.GA4011@kroah.com>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 1/2] Add c2 port support.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 08:37:33AM -0700, Greg KH wrote:

> And again, you can still use sysfs for that as well.  I was just
> referring to the binary sysfs file that you use for the firmware
> download, it would make more sense for you to use the standard kernel
> firmware download interface instead of rolling your own here.

If I well understand the firmware class it works starting the firmware
download from the kernel side, that is into the kernel we should call
request_firmware() and then the files will
/sys/class/firmware/xxx/{loading,data} appear.

This solution doesn't fit C2 port needs since the firmware download is
decided from userland erasing and then writing into the
microcontroller on-board flash.

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
