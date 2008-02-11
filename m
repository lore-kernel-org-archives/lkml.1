Return-Path: <linux-kernel-owner+w=401wt.eu-S1757425AbYBKIGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425AbYBKIGH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 03:06:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757084AbYBKIFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 03:05:52 -0500
Received: from iona.labri.fr ([147.210.8.143]:37472 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757050AbYBKIFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 03:05:51 -0500
X-Greylist: delayed 1594 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Feb 2008 03:05:50 EST
Message-ID: <47AFFB9F.4030902@ens-lyon.org>
Date: Mon, 11 Feb 2008 08:39:11 +0100
From: Brice Goglin <Brice.Goglin@ens-lyon.org>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc1
References: <alpine.LFD.1.00.0802101603240.2920@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802101603240.2920@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
>  - Lots of cleanups from the x86 merge (making more and more use of common 
>    files), but also the big page attribute stuff is in and caused a fair 
>    amount of churn, and while most of the issues should have been very 
>    obvious and all got fixed, this is definitely one of those things that 
>    we want a lot of very wide testing of to make sure nothing regressed.
>   

Now that __ioremap isn't available anymore, is there anything in the new
pageattr stuff to replace a manual __ioremap with __PAGE_PCD or
__PAGE_PSE? or do we have to wait for 2.6.26 to bring PAT support? I
don't see any new function accepting random page attributes as __ioremap
did.

thanks,
Brice

