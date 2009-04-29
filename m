Return-Path: <linux-kernel-owner+w=401wt.eu-S1759613AbZD2LW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759613AbZD2LW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 07:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758487AbZD2LWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 07:22:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:35859 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250AbZD2LWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 07:22:47 -0400
Subject: Re: [PATCH 0/29] x86/perfcounters: x86 and AMD cpu updates
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Robert Richter <robert.richter@amd.com>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090429110936.GI2373@elte.hu>
References: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
	 <20090429110936.GI2373@elte.hu>
Content-Type: text/plain
Date: Wed, 29 Apr 2009 13:22:43 +0200
Message-Id: <1241004163.8021.256.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-29 at 13:09 +0200, Ingo Molnar wrote:
> * Robert Richter <robert.richter@amd.com> wrote:
> 
> > This patch series updates the perfcounters implementation mainly 
> > for the x86 architecture.
> 
> Wow, very nice series! Still havent looked through all of them, but 
> wanted to give some quick feedback that the splitup and direction 
> looks all good.

Agreed, patches look nice, thanks!

> > I developed this patches based on 03ced43 and later rebased to 
> > 1b88991. The latest tip/percounters/core branch seems to be 
> > broken, no nmis are delivered, only perfcounter interrupts with no 
> > results on kerneltop. I am still debugging this. However, I could 
> > test successfully the patch series based on 03ced43 and want to 
> > release the patches anyway.
> 
> hm, it works all fine for me. This is "perf top" output from an 
> AMD/Barcelona box:

Works on my opteron as well:

vendor_id       : AuthenticAMD                         
cpu family      : 15                                   
model           : 67                                   
model name      : Dual-Core AMD Opteron(tm) Processor 1216
stepping        : 2 



