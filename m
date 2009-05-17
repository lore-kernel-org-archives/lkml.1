Return-Path: <linux-kernel-owner+w=401wt.eu-S1753672AbZEQNec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672AbZEQNec (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 09:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbZEQNeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 09:34:23 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:37128 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbZEQNeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 09:34:22 -0400
X-Auth-Info: bdcVAxu2+woFJyFaUQwV0vPEIzFO8bzkFLbU/WMTvqY=
To: Konstantin Baydarov <kbaidarov@ru.mvista.com>
cc: Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
From: Wolfgang Denk <wd@denx.de>
Subject: Re: [PATCH] [PowerPC] Support For Initrd Loaded Into Highmem
Mime-version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
In-reply-to: <4A103EDF.7050108@ru.mvista.com>
References: <4A103EDF.7050108@ru.mvista.com>
Comments: In-reply-to Konstantin Baydarov <kbaidarov@ru.mvista.com>
   message dated "Sun, 17 May 2009 20:44:15 +0400."
Date: Sun, 17 May 2009 15:34:17 +0200
Message-Id: <20090517133417.9E0FC832E416@gemini.denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Konstantin Baydarov,

In message <4A103EDF.7050108@ru.mvista.com> you wrote:
> 
>   It turned out that:
> PPC uBoot always loads initrd image at the highest RAM address. So if board has

Please read the documentation, for example the U-Boot  README  -  pay
speicial  attention  to  the section that discusses the "initrd_high"
envrionment variable.

>   How Solved:
> Code was added that checks if initrd is in the highmem and relocates initrd
> into lowmem if required.

I don't think this is needed. Just don't load the ramdisk to highmem
in the first place.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
How come everyone's going so slow if it's called rush hour?
