Return-Path: <linux-kernel-owner+w=401wt.eu-S1752048AbXCSH1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbXCSH1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 03:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965717AbXCSH1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 03:27:47 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:34735 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752048AbXCSH1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 03:27:47 -0400
Date: Mon, 19 Mar 2007 08:27:49 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: 2.6.21-rc4: pl2303 disconnect oops
Message-ID: <20070319072749.GD752@stusta.de>
References: <Pine.SOC.4.64.0703190835280.28512@math>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.SOC.4.64.0703190835280.28512@math>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2007 at 08:41:33AM +0200, Meelis Roos wrote:
> I was using my laptop as the serial console of another computer with 
> pl2303 usb-to-serial cable. minicom was running but I do not remember 
> whether the other end was connected or was already disconnected. Anyway, 
> I unplugged the usb cable and got a couple of oopses from pl2303. Kernel 
> 2.6.21-rc4 on a thinkpad X20.
>...

This looks like one of the known regressions.

Does the patch in [1] help?

> Meelis Roos

cu
Adrian

[1] http://lkml.org/lkml/2007/3/13/217

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

