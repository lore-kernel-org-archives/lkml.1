Return-Path: <linux-kernel-owner+w=401wt.eu-S964839AbXBLJsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964839AbXBLJsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 04:48:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964838AbXBLJsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 04:48:09 -0500
Received: from wx-out-0506.google.com ([66.249.82.239]:60335 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964839AbXBLJsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 04:48:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=caBfUpWPal8PpCfSx6xkHbKObWuxMh7eS3dv+TJ0QKxmbBHDTQJu/7HL69/yG7UOaLnqvUy/u6EM+q9mmss9n3HIhrc5SkjMxe5jZdlr2VGqZjjybpUOpYfUPiNwm1ODxfd69VoQ3pb7DBkm//w6pJpcnjOtAKN5zrATBgQWmtU=
Message-ID: <45D037C3.3070306@gmail.com>
Date: Mon, 12 Feb 2007 01:47:47 -0800
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Jean Delvare <jdelvare@suse.de>
CC: Leopold Palomo Avellaneda <lepalom@wol.es>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Sata_via problems in a Vintage2-AE1
References: <200702090010.06897.lepalom@wol.es> <200702092109.25029.lepalom@wol.es> <45CDDA86.2000607@gmail.com> <200702121011.49818.jdelvare@suse.de>
In-Reply-To: <200702121011.49818.jdelvare@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> I've read the whole thread, the source code (quickly) and the patches to 
> ahci.c and sata_via.c, and here are some comments:
> 
> It looks like support for the VT8251 was added to the ahci driver in kernel 
> 2.6.18, and was then updated in 2.6.20. The code is different from the 
> patch Leopold is using with 2.6.16. As I am not an expert in this area, I 
> can't tell whether both versions are equivalent or not, but I'd guess so.

The differences between 2.6.16 and 2.6.20 in ahci are mostly things like 
detection fixes and hotplug handling fixes which shouldn't affect normal 
operations too much and irqpoll definitely won't fix the problem.

> On the other hand, I do not see VT8251 support in the sata_via driver in the 
> kernel, so I'm not surprised that it doesn't work properly for Leopold. But 
> again I am no expert in the area, so maybe the sata_via driver in the kernel 
> is supposed to work for VT8251-based systems. Jeff (cc'd) should know better.

vt8251 is an ahci controller so sata_via is irrelevant.

> I also see that there were many changes to these drivers post-2.6.20, so maybe 
> Leopold could give a try to Linus' latest kernel (2.6.20-git6 as I speak) and 
> see if there are any improvements.
> 
> As for the VIA IRQ quirks, the version we have in 2.6.20 does not handle the 
> VIA chips more recent than the VT8237A. If the VT8251 needs it, then we have 
> to add it. Alan?
> 
> *If* the VT8251 needs the VIA IRQ quirk, then the attached patch may help. 
> Leopold, can you give it a try?

This is where I have no clue.  :-)  Leopold, please test Jean's patch.

Thanks a lot.

-- 
tejun
