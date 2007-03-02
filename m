Return-Path: <linux-kernel-owner+w=401wt.eu-S932767AbXCBIGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932767AbXCBIGM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 03:06:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932764AbXCBIGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 03:06:12 -0500
Received: from serv1.oss.ntt.co.jp ([222.151.198.98]:47052 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161323AbXCBIGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 03:06:11 -0500
Subject: Re: [Fastboot] [PATCH RFC 0/5] hard_smp_processor_id overhaul
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: vgoyal@in.ibm.com
Cc: Benjamin LaHaise <bcrl@kvack.org>, ebiederm@xmission.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       fastboot@lists.osdl.org, ak@suse.de, akpm@linux-foundation.org,
       judith@linux-foundation.org
In-Reply-To: <20070302041455.GA15386@in.ibm.com>
References: <1172733373.1498.264.camel@sebastian.intellilink.co.jp>
	 <20070301140648.GX26583@kvack.org>  <20070302041455.GA15386@in.ibm.com>
Content-Type: text/plain; charset=utf-8
Organization: NTT Open Source Software Center
Date: Fri, 02 Mar 2007 17:06:34 +0900
Message-Id: <1172822794.6025.11.camel@sebastian.intellilink.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-02 at 09:44 +0530, Vivek Goyal wrote:
> On Thu, Mar 01, 2007 at 09:06:48AM -0500, Benjamin LaHaise wrote:
> > On Thu, Mar 01, 2007 at 04:16:13PM +0900, Fernando Luis Vázquez Cao wrote:
> > > As a consequence, the hardcoding of hard_smp_processor_id() to 0 on UP
> > > systems (see "linux/smp.h") is not correct.
> > > 
> > > This patch-set does the following:
> > > 
> > > 1- Remove hardcoding of hard_smp_processor_id on UP systems.
> > 
> > NAK.  This has to be configurable, as many embedded systems don't even 
> > have APICs.  Please rework the patch set so that there is not any overhead 
> > for existing UP systems.
> 
> Fernando did the code audit and found no instance of hard_smp_processor_id
> being used for non APIC case. So are embedded systems you are referring,
> patching the kernel?
> 
> Anyway, I think providing hard_smp_processor_id() definition for UP systems
> without APIC does not harm.
Hi Vivek,

I am replying to this email with a patch that does exactly that.

Thanks,
Fernando

