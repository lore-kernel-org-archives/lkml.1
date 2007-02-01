Return-Path: <linux-kernel-owner+w=401wt.eu-S1422768AbXBAXP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422768AbXBAXP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 18:15:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422833AbXBAXP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 18:15:56 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:35834 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422768AbXBAXPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 18:15:55 -0500
Subject: Re: [PATCH] CELL PPU Oprofile cleanup patch
From: Carl Love <cel@us.ibm.com>
To: Michael Neuling <mikey@neuling.org>
Cc: cbe-oss-dev@ozlabs.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <10720.1170370348@neuling.org>
References: <1170360615.5204.18.camel@dyn9047021078.beaverton.ibm.com>
	 <10720.1170370348@neuling.org>
Content-Type: text/plain
Date: Thu, 01 Feb 2007 15:15:52 -0800
Message-Id: <1170371752.5204.20.camel@dyn9047021078.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mikey:

Yes, that is an error.  Thanks for the catch.

          Carl Love

On Fri, 2007-02-02 at 09:52 +1100, Michael Neuling wrote:
> Carl,
> 
> > +#define NUM_TRACE_BUS_WORDS 4
> > +#define NUM_INPUT_BUS_WORDS 2
> 
> <snip>
> 
> > -     for (i = 0; i < 4; i++)
> > +     for (i = 0; i < NUM_INPUT_BUS_WORDS; i++)
> >               trace_bus[i] = 0xff;
> >  
> > -     for (i = 0; i < 2; i++)
> > +     for (i = 0; i < NUM_INPUT_BUS_WORDS; i++)
> >               input_bus[i] = 0xff;
> 
> The first loop looks like a bug...   Shouldn't it be
> NUM_TRACE_BUS_WORDS?
> 
> Mikey

