Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518AbZEUJLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbZEUJLY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 05:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751051AbZEUJLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 05:11:17 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:35569 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbZEUJLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 05:11:16 -0400
Subject: Re: sky2 problem with WARNING: at net/sched/sch_generic.c:219
From: Kasper Sandberg <lkml@metanurb.dk>
To: Carsten Aulbert <carsten.aulbert@aei.mpg.de>
Cc: linux-kernel@vger.kernel.org, linux-net@vger.kernel.org
In-Reply-To: <4A0980C6.2080204@aei.mpg.de>
References: <4A0924FF.7040502@aei.mpg.de>  <4A0980C6.2080204@aei.mpg.de>
Content-Type: text/plain
Date: Thu, 21 May 2009 11:11:16 +0200
Message-Id: <1242897076.5740.13.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Happens on realtek NICs too with the r8169 driver.

On Tue, 2009-05-12 at 15:59 +0200, Carsten Aulbert wrote:
> Hi again,
> 
> Carsten Aulbert schrieb:
> 
> > Anyone an idea what this is about?
> 
> Further testing and debugging revealed that it's probably related to
> wrong autosensing. It should be rx/tx:off but rx is set to on. So far no
> idea why this happens (and why the device goes "offline" for some time).
> Anyone with an idea?
> 
> Cheers
> 
> Carsten
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

