Return-Path: <linux-kernel-owner+w=401wt.eu-S1757450AbYB2CMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450AbYB2CMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 21:12:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbYB2CMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 21:12:47 -0500
Received: from relay2.sgi.com ([192.48.171.30]:39128 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752731AbYB2CMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 21:12:46 -0500
Date: Thu, 28 Feb 2008 18:12:43 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Eric Dumazet <dada1@cosmosbay.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Implement slub fastpath in terms of freebase and freeoffset
In-Reply-To: <20080229015621.GB32200@Krystal>
Message-ID: <Pine.LNX.4.64.0802281812290.3159@schroedinger.engr.sgi.com>
References: <64bb37e0802182254l49b10cbblc23f8a83d189ff8e@mail.gmail.com>
 <84144f020802182321x452888bai639c71ea2a5067da@mail.gmail.com>
 <20080219140230.GA32236@Krystal> <20080219172739.55c341b5.dada1@cosmosbay.com>
 <20080219200358.GB11197@Krystal> <Pine.LNX.4.64.0802271532580.14380@schroedinger.engr.sgi.com>
 <20080228055510.GA9026@Krystal> <Pine.LNX.4.64.0802281054230.29191@schroedinger.engr.sgi.com>
 <20080228232507.GB20319@Krystal> <Pine.LNX.4.64.0802281648510.1954@schroedinger.engr.sgi.com>
 <20080229015621.GB32200@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008, Mathieu Desnoyers wrote:

> In short, the we also use the versioning to check for change of slab.

Sounds good.

