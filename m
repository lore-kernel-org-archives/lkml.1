Return-Path: <linux-kernel-owner+w=401wt.eu-S932860AbXGKUL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932860AbXGKUL6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 16:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759791AbXGKULv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 16:11:51 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:32879 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758105AbXGKULu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 16:11:50 -0400
Date: Wed, 11 Jul 2007 13:11:48 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ethan Solomita <solo@google.com>
cc: Andrew Morton <akpm@google.com>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>, a.p.zijlstra@chello.nl
Subject: Re: [RFC 1/7] cpuset write dirty map
In-Reply-To: <46952D0A.1090304@google.com>
Message-ID: <Pine.LNX.4.64.0707111311040.18429@schroedinger.engr.sgi.com>
References: <465FB6CF.4090801@google.com> <Pine.LNX.4.64.0706041138410.24412@schroedinger.engr.sgi.com>
 <46646A33.6090107@google.com> <Pine.LNX.4.64.0706041250440.25535@schroedinger.engr.sgi.com>
 <468023CA.2090401@google.com> <Pine.LNX.4.64.0706261216110.20282@schroedinger.engr.sgi.com>
 <46952D0A.1090304@google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007, Ethan Solomita wrote:

> 	Christoph -- I have a question about one part of the patches. In
> throttle_vm_writeout() you added a clause that checks for __GFP_FS |
> __GFP_IO and if they're not both set it calls blk_congestion_wait()
> immediately and then returns, no change for looping. Two questions:
> 
> 1. This seems like an unrelated bug fix. Should you submit it as a
> standalone patch?

This may be a leftover from earlier times when the logic was different in 
throttle vm writeout? 
