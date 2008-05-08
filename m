Return-Path: <linux-kernel-owner+w=401wt.eu-S1757332AbYEHERt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332AbYEHERt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 00:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbYEHERj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 00:17:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48502 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751653AbYEHERh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 00:17:37 -0400
Date: Wed, 7 May 2008 21:17:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: AIM7 40% regression with 2.6.26-rc1
In-Reply-To: <1210219729.3453.97.camel@ymzhang>
Message-ID: <alpine.LFD.1.10.0805072115190.3024@woody.linux-foundation.org>
References: <1210052904.3453.30.camel@ymzhang>  <20080506114449.GC32591@elte.hu> <1210126286.3453.37.camel@ymzhang>  <1210131712.3453.43.camel@ymzhang> <87lk2mbcqp.fsf@basil.nowhere.org>  <20080507114643.GR19219@parisc-linux.org>  <87hcdab8zp.fsf@basil.nowhere.org>
  <alpine.LFD.1.10.0805070728280.32269@woody.linux-foundation.org>  <alpine.LFD.1.10.0805070817060.3024@woody.linux-foundation.org>  <1210214696.3453.87.camel@ymzhang>  <alpine.LFD.1.10.0805072014330.3024@woody.linux-foundation.org>
 <1210219729.3453.97.camel@ymzhang>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 May 2008, Zhang, Yanmin wrote:
> 
> On Wed, 2008-05-07 at 20:29 -0700, Linus Torvalds wrote:
> > 
> > That said, "idle 0%" is easy when you spin. Do you also have actual 
> > performance numbers?
>
> Yes. My conclusion is based on the actual number. cpu idle 0% is just
> a behavior it should be.

Thanks, that's all I wanted to verify.

I'll leave this overnight, and see if somebody has come up with some smart 
and wonderful patch. And if not, I think I'll apply mine as "known to fix 
a regression", and we can perhaps then improve on things further from 
there.

		Linus
