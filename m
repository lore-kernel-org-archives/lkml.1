Return-Path: <linux-kernel-owner+w=401wt.eu-S1759673AbYDCTRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759673AbYDCTRR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755124AbYDCTRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:17:06 -0400
Received: from relay2.sgi.com ([192.48.171.30]:59922 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754732AbYDCTRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:17:05 -0400
Date: Thu, 3 Apr 2008 12:14:24 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Andrea Arcangeli <andrea@qumranet.com>, Hugh Dickins <hugh@veritas.com>,
       Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       general@lists.openfabrics.org, Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Nick Piggin <npiggin@suse.de>
Subject: Re: EMM: Fixup return value handling of emm_notify()
In-Reply-To: <1207219246.8514.817.camel@twins>
Message-ID: <Pine.LNX.4.64.0804031213480.7480@schroedinger.engr.sgi.com>
References: <20080401205531.986291575@sgi.com>  <20080401205635.793766935@sgi.com>
 <20080402064952.GF19189@duo.random>  <Pine.LNX.4.64.0804021048460.27214@schroedinger.engr.sgi.com>
  <Pine.LNX.4.64.0804021202450.28436@schroedinger.engr.sgi.com> 
 <20080402212515.GS19189@duo.random>  <Pine.LNX.4.64.0804021427210.30516@schroedinger.engr.sgi.com>
 <1207219246.8514.817.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Apr 2008, Peter Zijlstra wrote:

> It seems to me that common code can be shared using functions? No need
> to stuff everything into a single function. We have method vectors all
> over the kernel, we could do a_ops as a single callback too, but we
> dont.
> 
> FWIW I prefer separate methods.

Ok. It seems that I already added some new methods which do not use all 
parameters. So lets switch back to the old scheme for the next release.
