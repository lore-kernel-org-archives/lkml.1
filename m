Return-Path: <linux-kernel-owner+w=401wt.eu-S1753876AbYACNHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbYACNHj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 08:07:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbYACNGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 08:06:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:55682 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211AbYACNG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 08:06:28 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] [12/20] x86: Use a per cpu timer for correctable machine check checking
Date: Thu, 3 Jan 2008 13:56:09 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <20080103149.088038000@suse.de> <20080103005007.CE13A14D40@wotan.suse.de> <20080103104956.GE29194@elte.hu>
In-Reply-To: <20080103104956.GE29194@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801031356.09714.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 January 2008 11:49:56 Ingo Molnar wrote:
> 
> * Andi Kleen <ak@suse.de> wrote:
> 
> > Previously the code used a single timer that then used 
> > smp_call_function to interrupt all CPUs while the original CPU was 
> > waiting for them.
> > 
> > But it is better / more real time and more power friendly to simply 
> > run individual timers on each CPU so they all do this independently.
> > 
> > This way no single CPU has to wait for all others.
> 
> i think we should unify this code first and provide it on 32-bit as 
> well.

That's done in another patch that hasn't been posted yet.

-Andi
