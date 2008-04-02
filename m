Return-Path: <linux-kernel-owner+w=401wt.eu-S1765639AbYDBV7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765639AbYDBV7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 17:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765573AbYDBV7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 17:59:00 -0400
Received: from relay2.sgi.com ([192.48.171.30]:53304 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765569AbYDBV67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 17:58:59 -0400
Date: Wed, 2 Apr 2008 14:56:25 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Hugh Dickins <hugh@veritas.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 5/9] Convert anon_vma lock to rw_sem and refcount
In-Reply-To: <20080402215604.GU19189@duo.random>
Message-ID: <Pine.LNX.4.64.0804021455180.31247@schroedinger.engr.sgi.com>
References: <20080401205531.986291575@sgi.com> <20080401205636.777127252@sgi.com>
 <20080402175058.GR19189@duo.random> <Pine.LNX.4.64.0804021107520.27337@schroedinger.engr.sgi.com>
 <20080402215604.GU19189@duo.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2008, Andrea Arcangeli wrote:

> paging), hence the slowdown. What you benchmarked is the write side,
> which is also the fast path when the system is heavily CPU bound. I've
> to say aim is a great benchmark to test this regression.

I am a bit surprised that brk performance is that important. There may be 
other measurement that have to be made to assess how this would impact a 
real load.



