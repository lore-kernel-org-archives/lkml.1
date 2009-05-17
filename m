Return-Path: <linux-kernel-owner+w=401wt.eu-S1754607AbZEQOTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607AbZEQOTV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 10:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbZEQOTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 10:19:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:46839 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324AbZEQOTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 10:19:10 -0400
Subject: Re: [PATCH 3/10 -tip] x86: Add cpufeatures for Advanced Power
 Management
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@kernel.org>,
       Robert Richter <robert.richter@amd.com>, Dave Jones <davej@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>
In-Reply-To: <alpine.LFD.2.00.0905171415150.3516@localhost.localdomain>
References: <1242142530.2547.11.camel@ht.satnam>
	 <1242142623.2547.13.camel@ht.satnam>  <1242142692.2547.15.camel@ht.satnam>
	 <1242142753.2547.16.camel@ht.satnam> <1242155190.2492.73.camel@ht.satnam>
	 <alpine.LFD.2.00.0905122219420.3561@localhost.localdomain>
	 <1242395277.3082.24.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0905171415150.3516@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 17 May 2009 19:48:18 +0530
Message-Id: <1242569898.3280.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-05-17 at 14:17 +0200, Thomas Gleixner wrote:
> On Fri, 15 May 2009, Jaswinder Singh Rajput wrote:
> > > Do you really believe that open-coding x86_capability[9] in .../common.c
> > > is better than the open-coding in ../powernow-k8.c ?
> > > 
> > 
> > BTW, then how you can set x86_capability[9] in one shot ? do you want me
> > to set each bit with set_cpu_cap() ?
> 
> Using "9" as an array index is the point. This needs to be a constant
> near the other constants which describe the bits and a big fat comment.
> 

Sure, I will do it. And hoping that I will get ACK from you ;-)

Thanks,
--
JSR

