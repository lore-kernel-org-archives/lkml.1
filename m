Return-Path: <linux-kernel-owner+w=401wt.eu-S1757469AbYFJRWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469AbYFJRWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 13:22:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589AbYFJRV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 13:21:58 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50481 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751014AbYFJRV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 13:21:58 -0400
Date: Tue, 10 Jun 2008 10:21:54 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: collapse the various size-dependent percpu accessors
 together
In-Reply-To: <484685EE.40303@goop.org>
Message-ID: <Pine.LNX.4.64.0806101021350.17093@schroedinger.engr.sgi.com>
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>
 <48466BFB.40004@goop.org> <4846725D.4090607@goop.org> <20080604112939.GA27845@elte.hu>
 <484685EE.40303@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I tried a version to do 64-bit accesses with an explicit "movq" to solve the
> "movll" problem, but it generates "movs" on occasion and that was the point I
> gave up.

Shucks. Would have been a great approach.

