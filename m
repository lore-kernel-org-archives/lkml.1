Return-Path: <linux-kernel-owner+w=401wt.eu-S1755967AbXKIRt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbXKIRt6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 12:49:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751032AbXKIRtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 12:49:51 -0500
Received: from relay1.corp.sgi.com ([192.48.171.29]:47969 "EHLO relay.sgi.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750968AbXKIRtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 12:49:51 -0500
Date: Fri, 9 Nov 2007 09:49:49 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc2 slab vs slob tbench numbers
In-Reply-To: <Pine.LNX.4.64.0711090712440.13823@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0711090928270.14601@schroedinger.engr.sgi.com>
References: <200711092336.56172.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0711090712440.13823@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On an 8p 2.6.24-rc2 I see even a 50% regression on tbench SLAB vs. SLUB 
when specifying 8 threads. 

Interestingly nothing changes the performance numbers regardless of 
debugging on or off etc etc. Usually debugging should reduce performance 
but nada. May have something to do with the localhost interface? Something 
is effectively throttling SLUB here.

2.6.23 SLUB	           2159.62 MB/sec
2.6.24-rc2-slab head SLUB  1260.80 MB/sec

2.6.24 SLUB should be faster than 2.6.23 SLUB. Still trying to figure out 
what is going on....

