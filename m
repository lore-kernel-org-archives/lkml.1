Return-Path: <linux-kernel-owner+w=401wt.eu-S1422841AbXCBEPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422841AbXCBEPK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 23:15:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422844AbXCBEPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 23:15:10 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:39612 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422841AbXCBEPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 23:15:07 -0500
Date: Fri, 2 Mar 2007 09:44:56 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>,
       ebiederm@xmission.com, judith@linux-foundation.org,
       akpm@linux-foundation.org, fastboot@lists.osdl.org, ak@suse.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Fastboot] [PATCH RFC 0/5] hard_smp_processor_id overhaul
Message-ID: <20070302041455.GA15386@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <1172733373.1498.264.camel@sebastian.intellilink.co.jp> <20070301140648.GX26583@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070301140648.GX26583@kvack.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 09:06:48AM -0500, Benjamin LaHaise wrote:
> On Thu, Mar 01, 2007 at 04:16:13PM +0900, Fernando Luis Vázquez Cao wrote:
> > As a consequence, the hardcoding of hard_smp_processor_id() to 0 on UP
> > systems (see "linux/smp.h") is not correct.
> > 
> > This patch-set does the following:
> > 
> > 1- Remove hardcoding of hard_smp_processor_id on UP systems.
> 
> NAK.  This has to be configurable, as many embedded systems don't even 
> have APICs.  Please rework the patch set so that there is not any overhead 
> for existing UP systems.

Fernando did the code audit and found no instance of hard_smp_processor_id
being used for non APIC case. So are embedded systems you are referring,
patching the kernel?

Anyway, I think providing hard_smp_processor_id() definition for UP systems
without APIC does not harm.

Thanks
Vivek
