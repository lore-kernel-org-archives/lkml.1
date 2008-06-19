Return-Path: <linux-kernel-owner+w=401wt.eu-S1755983AbYFSJHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbYFSJHv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 05:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754965AbYFSJHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 05:07:40 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1841 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbYFSJHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 05:07:39 -0400
Date: Thu, 19 Jun 2008 10:07:22 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>, Ingo Molnar <mingo@elte.hu>,
       tglx <tglx@linutronix.de>, hpa <hpa@zytor.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: coding style fixes to arch/x86/math-emu/reg_constant
Message-ID: <20080619090715.GK30959@shadowen.org>
References: <20080614204452.25378bd0@paolo-desktop> <48590926.5060009@movial.fi> <4d8e3fd30806180719j718a3b1ds461495c4d3de8236@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d8e3fd30806180719j718a3b1ds461495c4d3de8236@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2008 at 04:19:38PM +0200, Paolo Ciarrocchi wrote:
> On Wed, Jun 18, 2008 at 3:09 PM, Dmitri Vorobiev
> <dmitri.vorobiev@movial.fi> wrote:
> > Paolo Ciarrocchi wrote:
> >>
> >> -static void fld_const(FPU_REG const *c, int adj, u_char tag)
> >> +static void fld_const(FPU_REG const * c, int adj, u_char tag)
> > ________________________________________^
> >
> > The above does not seem to me like a big improvement in code quality. A
> > false positive from checkpatch.pl?
> 
> Yes, I think you are right.
> Andy CC'ed so that he can have a look at that.

That would be a false positive if we are recommending that.  I have
pushed this fragment in isolation through all versions back to 0.15 and
none of them recommend it.

Ahh, but if I push the whole patch through 0.19 spits it out.  Ok this
is a subtle bug in modifier procesing and is fixed in the head of my
tree.  Will be fixed in the next batch which goes up to -mm.

-apw
