Return-Path: <linux-kernel-owner+w=401wt.eu-S1757212AbYCVFqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212AbYCVFqG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 01:46:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbYCVFp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 01:45:59 -0400
Received: from 1wt.eu ([62.212.114.60]:1027 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253AbYCVFp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 01:45:58 -0400
Date: Sat, 22 Mar 2008 06:45:37 +0100
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, yhlu.kernel@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: early memtest to find bad ram
Message-ID: <20080322054537.GA23796@1wt.eu>
References: <200803202358.33722.yhlu.kernel@gmail.com> <20080321120313.GD25225@elte.hu> <47E3B335.3020501@zytor.com> <20080321142919.GD31719@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080321142919.GD31719@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 03:29:19PM +0100, Ingo Molnar wrote:
> 
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
> >> very nice patch! I always thought that this was the proper way to do 
> >> memtest - and we could in fact also do something like this after SMP 
> >> bringup, and hit the memory bus via multiple CPUs. [that will need a 
> >> different enumeration though than e820 maps]
> >>
> >> one structural observation: please make this unified functionality, 
> >> so that 32-bit kernels can make use of it too.
> >>
> >
> > Indeed.  Of course, it would also be nice if distros shipped 
> > bootloader-invoked prekernel test software, like memtest86+, by 
> > default.
> 
> some do (Fedora for example), but it's still a bit quirky for users to 
> invoke and it would be nice to see those results in the kernel log as 
> well and flag possibly flaky systems that way. (add a taint bit, etc., 
> etc.)

It may even make sense to merge in the full memtest86. The code is small
(both source and binary) and IIRC it shares a lot of init code with x86.
The remaining problem would then be how to maintain its tests up do date.

Willy

