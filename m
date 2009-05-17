Return-Path: <linux-kernel-owner+w=401wt.eu-S1752701AbZEQMSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbZEQMSl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 08:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbZEQMSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 08:18:31 -0400
Received: from www.tglx.de ([62.245.132.106]:49411 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911AbZEQMSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 08:18:30 -0400
Date: Sun, 17 May 2009 14:17:00 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@kernel.org>,
       Robert Richter <robert.richter@amd.com>, Dave Jones <davej@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 3/10 -tip] x86: Add cpufeatures for Advanced Power
 Management
In-Reply-To: <1242395277.3082.24.camel@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0905171415150.3516@localhost.localdomain>
References: <1242142530.2547.11.camel@ht.satnam>  <1242142623.2547.13.camel@ht.satnam>  <1242142692.2547.15.camel@ht.satnam>  <1242142753.2547.16.camel@ht.satnam> <1242155190.2492.73.camel@ht.satnam>  <alpine.LFD.2.00.0905122219420.3561@localhost.localdomain>
 <1242395277.3082.24.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 May 2009, Jaswinder Singh Rajput wrote:
> > Do you really believe that open-coding x86_capability[9] in .../common.c
> > is better than the open-coding in ../powernow-k8.c ?
> > 
> 
> BTW, then how you can set x86_capability[9] in one shot ? do you want me
> to set each bit with set_cpu_cap() ?

Using "9" as an array index is the point. This needs to be a constant
near the other constants which describe the bits and a big fat comment.

Thanks,

	tglx
