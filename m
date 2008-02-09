Return-Path: <linux-kernel-owner+w=401wt.eu-S1756983AbYBILYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983AbYBILYR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 06:24:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbYBILYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 06:24:09 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35750 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbYBILYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 06:24:08 -0500
Date: Sat, 9 Feb 2008 12:59:20 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Prakash Punnoor <prakash@punnoor.de>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, tglx@linutronix.de,
       lenb@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Replace nvidia timer override quirk with pci id list
Message-ID: <20080209115920.GB21172@one.firstfloor.org>
References: <20080207195519.GA21772@basil.nowhere.org> <200802082000.39919.prakash@punnoor.de> <20080208210258.GA13058@one.firstfloor.org> <200802090008.05430.prakash@punnoor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802090008.05430.prakash@punnoor.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Grr, I don't know why I am discussing with stubborn and/or arrogant devs like 
> you seem to be. But I actually did what you wanted and as *expected* - as I 

Thanks.

> said I understand that trivial piece of code you posted - your patch fails 
> here for my nforce2:

That is 2.6.24 + my patch?  And system didn't boot? 

> 
> cat /proc/interrupts
>            CPU0
>   0:        832    XT-PIC-XT        timer <---------------- seeing this?

Well it looks like it is ticking. What are the symptoms? 

Do you have a full boot log of the failure?

> 
> And no, I won't test it on my MCP51 as I *know* what happens: As soon as I 
> disable hpet, the quirk gets triggered and will lock up my system.

I readded the HPET check in v2 especially for you so if HPET is enabled
no quirk is triggered.

-Andi
