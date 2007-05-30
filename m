Return-Path: <linux-kernel-owner+w=401wt.eu-S1754199AbXE3QP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbXE3QP3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 12:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753688AbXE3QPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 12:15:18 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:56742 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752767AbXE3QPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 12:15:16 -0400
Date: Wed, 30 May 2007 19:15:15 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Satyam Sharma <satyam.sharma@gmail.com>
cc: Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: ppc modprost warnings in 2.6.22-rc1
In-Reply-To: <a781481a0705300758t5f16235al1f420f09472af780@mail.gmail.com>
Message-ID: <Pine.SOC.4.64.0705301914530.23769@math>
References: <Pine.SOC.4.64.0705141717110.23895@math> 
 <20070515204540.GC22966@uranus.ravnborg.org>  <Pine.SOC.4.64.0705301652250.23769@math>
 <a781481a0705300758t5f16235al1f420f09472af780@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Data that is not accessed after initcalls are done (and hence can be
> safely freed after kernel boot) must be marked __initdata.

Thanks, yes, I have known it quite a long time, seems like todays heat
(around +30) is confusing me :(

Patch sent separately to LKML.

-- 
Meelis Roos (mroos@linux.ee)
