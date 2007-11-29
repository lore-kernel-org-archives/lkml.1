Return-Path: <linux-kernel-owner+w=401wt.eu-S932122AbXK2MF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122AbXK2MF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 07:05:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756290AbXK2MFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 07:05:18 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:41146 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756360AbXK2MFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 07:05:17 -0500
Date: Thu, 29 Nov 2007 14:05:14 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] kmemcheck: trap uses of uninitialized memory (v2)
In-Reply-To: <19f34abd0711290204m6d23957o9b31b1d527c07694@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0711291358330.6399@sbz-30.cs.Helsinki.FI>
References: <474C34CC.6060509@gmail.com>  <84144f020711290002p290e91a4ubc40f1efbc877f75@mail.gmail.com>
  <19f34abd0711290110n501ddb43wf3ab69b526acef95@mail.gmail.com> 
 <Pine.LNX.4.64.0711291127470.26543@sbz-30.cs.Helsinki.FI>
 <19f34abd0711290204m6d23957o9b31b1d527c07694@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vegard,

On Thu, 29 Nov 2007, Vegard Nossum wrote:
> If I understand you correctly, you only want to be notified if any
> memory within an allocation is used before any memory within the
> allocation has been initialized. I think that this would be quite
> useless compared to tracking all the bytes of an allocation.

Ok, why is it useless? I am trying to understand what kind of errors you 
hope to catch here.

On Thu, 29 Nov 2007, Vegard Nossum wrote:
> I am not truly concerned about the memory usage; this kind of error 
> detection is by definition slow and memory intense.

There's "slow" and then there's "too slow for mainline" :-). But even if 
you want to track every byte, you could use a bitmap in the slab layer to 
cut down memory usage and get rid of "shadow pages", no?

			Pekka
