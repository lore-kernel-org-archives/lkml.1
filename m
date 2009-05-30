Return-Path: <linux-kernel-owner+w=401wt.eu-S932529AbZE3PsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529AbZE3PsU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 11:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759012AbZE3PsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 11:48:12 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:47149 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758744AbZE3PsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 11:48:11 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Harald Welte <HaraldWelte@viatech.com>
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Date: Sat, 30 May 2009 10:48:07 -0500
User-Agent: KMail/1.9.9
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <200905221139.26941.lkml@morethan.org> <4A188A48.5000208@zytor.com> <20090524064905.GH20452@prithivi.gnumonks.org>
In-Reply-To: <20090524064905.GH20452@prithivi.gnumonks.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905301048.10639.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun May 24 2009, Harald Welte wrote:
> Dear hpa, and others,
> 
> On Sat, May 23, 2009 at 04:44:08PM -0700, H. Peter Anvin wrote:
> > It looks like there might be a problem with the C7-M ... Michael reports
> > that if he sets LOCK_PREFIX to "lock;" it works, but that shouldn't be
> > necessary for a uniprocessor.
> > 
> 
> I will try my best to help, though I have to admit I'm far from being
> a x86 expert, and particularly not with regard to low-level bits such as atomic
> operations.
> 
> So please give me some time to research some background about that,
> and read up all the details on the currently reported/described problem.
> 
> Once I understand it in full detail, I can talk to the right people inside
> CentaurLabs (VIA's CPU division).  
> 
> If somebody (optionally) can phrase a precise technical question that I can
> directly forward to somebody with low-level x86 knowledge but no Linux background,
> it would definitely help speeding up the process.
> 

Does the C7-M instruction set define the 'pause' instruction (0xf3,0x90)?
*Defined* since the P-4, but backward compatible with earlier ia32 processors
even though it falls into the "don't use rep before non-string instructions".

Mike

