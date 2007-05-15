Return-Path: <linux-kernel-owner+w=401wt.eu-S1761449AbXEOCmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761449AbXEOCmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 22:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757069AbXEOCmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 22:42:12 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:26603 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139AbXEOCmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 22:42:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=T3xQkUji/fNlsNvSojEXGhby6zxCixE8poCXZ2/uJnFDzrqaqMs9vp1NNVP2MgB0L0Rn33bmvuOeIgVwDsm/ibp2/xSZ2pAiLbqcbZAqOu0ThaHv9onCbTvrnZ2xewHU6xEhEdmUBz3L7YlMNWG8+Clofw8pimKpRBx60Ipw1m4=
Message-ID: <a781481a0705141942x3033c72alf8bf7e9582bb59d7@mail.gmail.com>
Date: Tue, 15 May 2007 08:12:10 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Jan Engelhardt" <jengelh@linux01.gwdg.de>
Subject: Re: Linux 2.6.22-rc1
Cc: "Tilman Schmidt" <tilman@imap.cc>, LKML <linux-kernel@vger.kernel.org>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>
In-Reply-To: <a781481a0705141934u6b369dd5ob1715f14890af914@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
	 <4647569D.7010709@imap.cc>
	 <Pine.LNX.4.61.0705141918180.9570@yvahk01.tjqt.qr>
	 <4648A3DF.7040004@imap.cc>
	 <Pine.LNX.4.61.0705142227350.9570@yvahk01.tjqt.qr>
	 <a781481a0705141934u6b369dd5ob1715f14890af914@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On 5/15/07, Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
> > [...]
> > They are just a menu
>
> Ok, so they don't really affect Makefiles / sources (and thus builds).
> In that case I'd suggest that let's please change the names of such
> menuconfig options from CONFIG_ to CONFIG_MENU_, otherwise

Or perhaps we could change the text associated with these
"menu-only" dummy constructs instead ...

> we really screw the text-based "make oldconfig" folks who think
> that they're taking a build-related (and not presentation-related)
> decision when confronted with a:

So:

> Ethernet (1000 Mbit) (NETDEV_1000) [Y/n] (NEW)

becomes:

[MENU] Ethernet (1000 Mbit) (NETDEV_1000) [Y/n] (NEW)

?

Thanks,
Satyam
