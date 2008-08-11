Return-Path: <linux-kernel-owner+w=401wt.eu-S1756659AbYHKSrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659AbYHKSrd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 14:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbYHKSq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 14:46:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:21766 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbYHKSqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 14:46:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hxSOyN+ZcMtf2AAQYg0d0bQggWqpZtPRCMyXlcg5H5e2c2Ch84JWslPNAdjzA4Hr8U
         MgOnRnRfn2yCwINcp7z6pvCnjDKMxBab70jXXqLYMRuqWGtklHavrZn0Ymx0vKitkZsD
         qLIWKycMVU+3imi0VemWaIwJDRYACynNXjOto=
Date: Mon, 11 Aug 2008 22:46:54 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Rene Herman <rene.herman@keyaccess.nl>,
       Andrew Morton <akpm@osdl.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: kill arch/x86/kernel/mpparse.c debugging printk.
Message-ID: <20080811184654.GC18969@lenovo>
References: <489C77C6.7040408@keyaccess.nl> <20080811122038.GA10082@elte.hu> <48A05E79.4030304@keyaccess.nl> <48A05EB1.3050508@keyaccess.nl> <20080811164508.GA18969@lenovo> <48A074D1.4070803@keyaccess.nl> <20080811174147.GO4524@elte.hu> <48A07FC1.5040806@keyaccess.nl> <20080811183300.GB9627@elte.hu> <20080811184257.GB18969@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080811184257.GB18969@lenovo>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Mon, Aug 11, 2008 at 10:42:57PM +0400]
...
| | 
| | - in this case your first change was the obvious one and your NULL fix 
| |   and your cleanup to the parameter expose a fundamental weakness of
| |   early_param conversions - and i think highlighting that as separate 
| |   commits might give someone ideas to improve the early_param() 
| |   facility, if they see the fix patterns.
| 
| Ingo - I think the problem with early_param is not NULL itself but
| rather - what is the right way to deal with boot params? I mean we
| could pass empty string (not NULL) in case of argument absence _but_ would it
| be the right way? If you remember when I sent first series for early_param
| checking (and actually there are number of same issue exists for example
| in s390 arch) - I was asking community what is the best way - since I'm not
| that strong in interface engineering - i prefer fix the bugs :)
| 
| | 
| | - Also, the NULL condition is obscure, so there's no bisection breakage
| |   risk and it's the easiest for me to do append-only patches. The effort
| |   and thought process you and Cyrill have put into it deserve a separate
| |   commit as well anyway - and others might learn from it when looking at
| |   logs.
| | 
| | 	Ingo
| | 
| 		- Cyrill -

here is the link to that message

	http://lkml.org/lkml/2008/7/9/222

		- Cyrill -
