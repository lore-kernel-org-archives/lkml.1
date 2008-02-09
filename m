Return-Path: <linux-kernel-owner+w=401wt.eu-S1756871AbYBIKGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871AbYBIKGl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 05:06:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbYBIKGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 05:06:33 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:2343 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbYBIKGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 05:06:32 -0500
Subject: Re: CONFIG_HIGHPTE vs. sub-page page tables.
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080208231506.GA13350@elte.hu>
References: <200802081902.m18J2nOm005840@hera.kernel.org>
	 <20080208230433.GA8524@elte.hu>  <20080208231506.GA13350@elte.hu>
Content-Type: text/plain
Organization: IBM Corporation
Date: Sat, 09 Feb 2008 11:06:29 +0100
Message-Id: <1202551589.8936.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-02-09 at 00:15 +0100, Ingo Molnar wrote:
> > config attached. It seems all !PAE 32-bit kernel builds are broken due 
> > to this. The patch below fixes it.
> 
> ok, the patch was against x86.git which had some other changes in this 
> area - the one below applies to vanilla -git and fixes the bug.

Thanks Ingo for taking care of it. I already feared that we'll have some
more fallout from this patch although it has been in -mm for quite a
while. The real testing starts after a patch hit Linus tree. 

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


