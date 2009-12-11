Return-Path: <linux-kernel-owner+w=401wt.eu-S1762269AbZLKITD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762269AbZLKITD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 03:19:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762072AbZLKIS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 03:18:56 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:34756 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760873AbZLKIS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 03:18:56 -0500
Date: Fri, 11 Dec 2009 09:19:02 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: Bisected regression (Was Re: current -git fails to boot on
	nehalem-ex)
Message-ID: <20091211081902.GY8742@kernel.dk>
References: <20091210160640.GB27794@elte.hu> <67EA4830-231F-45C9-A1A6-CE1C6CD9493D@kernel.org> <20091210180727.GK8742@kernel.dk> <4B213F1F.2020305@kernel.org> <4B2140F8.3020201@kernel.org> <20091210184506.GP8742@kernel.dk> <20091210190742.GS8742@kernel.dk> <4B2149B4.9060900@kernel.org> <20091210192659.GV8742@kernel.dk> <4B21630A.6000308@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B21630A.6000308@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10 2009, Yinghai Lu wrote:
> Jens Axboe wrote:
>  
> > I can test other patches if you have good ideas, otherwise I suggest we
> > revert the commit.
> 
> we should go further.
> 
> please check, esp should fix that  from kernel acpi=off to kexec
> second kernel with  acpi=off for your system.
> 
> [PATCH] x86: use find_e820 instead of hard code trampoline addr

-git with this patch boots properly. kexec'ing into a kernel with
acpi=off passed works. Then kexec'ing into the same kernel again with
acpi-off works too.

So as far as I'm concerned, this patch fixes it for me. You can add my
Tested-by, too. Thanks!

-- 
Jens Axboe

