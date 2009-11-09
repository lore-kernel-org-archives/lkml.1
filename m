Return-Path: <linux-kernel-owner+w=401wt.eu-S1752867AbZKIR5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867AbZKIR5z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 12:57:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbZKIR5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 12:57:55 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:58368 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbZKIR5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 12:57:54 -0500
Message-ID: <4AF8582B.2000403@davidnewall.com>
Date: Tue, 10 Nov 2009 04:28:03 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Daniel Mack <daniel@caiaq.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Clemens Ladisch <clemens@ladisch.de>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vt: make the default cursor shape configurable
References: <4AF7D439.4030305@ladisch.de> <20091109091044.GX29442@buzzloop.caiaq.de> <4AF7DDC1.4090006@ladisch.de> <20091109095316.6283fbd6@lxorguk.ukuu.org.uk> <4AF7FC64.6030904@ladisch.de> <20091109114600.4d91b90e@lxorguk.ukuu.org.uk> <20091109145056.GB14091@buzzloop.caiaq.de>
In-Reply-To: <20091109145056.GB14091@buzzloop.caiaq.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Mack wrote:
> I had that previously and the response was that there is no reason to
> define that setting per-boot process, as it is rather unlikely that you
> want to change it from one boot to the next. Hence, it should be set at
> compile time.
>   

It should be set as a boot parameter, since this is fixed at system
installation and then left untouched.


> And even if the cursor behaviour is changable at runtime, I don't see
> why it shouldn't have a selectable compile time default. Which is what
> the patch adds.


It seems like adding cruft to the kernel that is just as effectively
available at run-time. Where does it end? Do we eventually add bash to
the kernel?
