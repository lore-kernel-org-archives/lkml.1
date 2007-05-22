Return-Path: <linux-kernel-owner+w=401wt.eu-S966755AbXEVSzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966755AbXEVSzd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 14:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760628AbXEVSzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 14:55:25 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:51289 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758895AbXEVSzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 14:55:24 -0400
Date: Tue, 22 May 2007 11:55:23 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Fenghua Yu <fenghua.yu@intel.com>
cc: akpm@linux-foundation.org, suresh.b.siddha@intel.com, kiran@scalex86.org,
       rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Use the new percpu interface for shared data --
 version 3
In-Reply-To: <20070522182022.GA27317@linux-os.sc.intel.com>
Message-ID: <Pine.LNX.4.64.0705221154510.29456@schroedinger.engr.sgi.com>
References: <1162040333.1178030136225.JavaMail.was6@nci57003d.marriott.com>
 <20070522182022.GA27317@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2007, Fenghua Yu wrote:

> -DEFINE_PER_CPU(struct tss_struct, init_tss) ____cacheline_internodealigned_in_smp = INIT_TSS;
> +DEFINE_PER_CPU_SHARED_ALIGNED(struct tss_struct, init_tss) = INIT_TSS;

Good work but could we call this something shorter?

Like

DEFINE_CPU_SHARED(...)

