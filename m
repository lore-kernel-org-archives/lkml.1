Return-Path: <linux-kernel-owner+w=401wt.eu-S1757906AbYAPE6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906AbYAPE6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 23:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbYAPE6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 23:58:12 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:3997 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbYAPE6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 23:58:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UeWyy+vDRQKv2wGG0JzLLcYkFKBrFS2AoIsxa9x2kM8onutkghgOTfSWUglW8O8A28bybFcmVyjE8P9mR/9espO7rhz9aJbZlxE9lPHf+jcqg1K7F94l/DCPCmT1UXcvXogtSYhR3f5PX8Jl/FiqCDyE4iw1D6exiw6rIR8NVpI=
Subject: Re: [PATCH] kprobe: missing cast
From: Harvey Harrison <harvey.harrison@gmail.com>
To: ananth@in.ibm.com
Cc: Stephen Hemminger <stephen.hemminger@vyatta.com>, prasanna@in.ibm.com,
       anil.s.keshavamurthy@intel.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080116045216.GA6804@in.ibm.com>
References: <20080114192155.2d6982ea@speedy>
	 <20080116045216.GA6804@in.ibm.com>
Content-Type: text/plain
Date: Tue, 15 Jan 2008 20:58:16 -0800
Message-Id: <1200459496.16794.79.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-01-16 at 10:22 +0530, Ananth N Mavinakayanahalli wrote:
> On Mon, Jan 14, 2008 at 07:21:55PM -0800, Stephen Hemminger wrote:
> > Fix warning from missing cast, maybe a result of the x86 merge?
> > 
> > Signed-off-by: Stephen Hemminger <stephen.hemminger@vyatta.com>
> 
> Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> 
> Thanks Stephen!
> 

kprobes_32|64.c have already been merged to kprobes.c in the x86.git
tree.  A stack_addr() helper was added to deal with the differences
here between 32 and 64 bit.

I'm pretty sure the x86 kprobes unification is headed for 2.6.25, so
it will get fixed.

Harvey

