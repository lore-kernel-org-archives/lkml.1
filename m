Return-Path: <linux-kernel-owner+w=401wt.eu-S1755721AbYB2FLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721AbYB2FLT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 00:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750953AbYB2FLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 00:11:08 -0500
Received: from relay2.sgi.com ([192.48.171.30]:47728 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751091AbYB2FLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 00:11:07 -0500
Date: Thu, 28 Feb 2008 21:11:04 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Eric Dumazet <dada1@cosmosbay.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Implement slub fastpath in terms of freebase and freeoffset
In-Reply-To: <20080229033255.GA2200@Krystal>
Message-ID: <Pine.LNX.4.64.0802282107090.5947@schroedinger.engr.sgi.com>
References: <20080219140230.GA32236@Krystal> <20080219172739.55c341b5.dada1@cosmosbay.com>
 <20080219200358.GB11197@Krystal> <Pine.LNX.4.64.0802271532580.14380@schroedinger.engr.sgi.com>
 <20080228055510.GA9026@Krystal> <Pine.LNX.4.64.0802281054230.29191@schroedinger.engr.sgi.com>
 <20080228232507.GB20319@Krystal> <Pine.LNX.4.64.0802281648510.1954@schroedinger.engr.sgi.com>
 <20080229015621.GB32200@Krystal> <Pine.LNX.4.64.0802281812290.3159@schroedinger.engr.sgi.com>
 <20080229033255.GA2200@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008, Mathieu Desnoyers wrote:

> * Christoph Lameter (clameter@sgi.com) wrote:
> > On Thu, 28 Feb 2008, Mathieu Desnoyers wrote:
> > 
> > > In short, the we also use the versioning to check for change of slab.

Then we do not need the page->end field anymore right? I will try 
to rediff your patch against current slab-mm and see how we can proceed 
from there.
