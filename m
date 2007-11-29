Return-Path: <linux-kernel-owner+w=401wt.eu-S1762708AbXK2BzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762708AbXK2BzM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 20:55:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761167AbXK2By6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 20:54:58 -0500
Received: from gw.goop.org ([64.81.55.164]:36786 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761092AbXK2By5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 20:54:57 -0500
Message-ID: <474E1BEF.7010303@goop.org>
Date: Wed, 28 Nov 2007 17:54:55 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
Subject: Re: [patch 05/14] percpu: Use a Kconfig variable to configure arch
 specific percpu setup
References: <20071127001407.859743255@sgi.com> <200711281236.02014.rusty@rustcorp.com.au> <Pine.LNX.4.64.0711281050470.11968@schroedinger.engr.sgi.com> <200711291017.52727.rusty@rustcorp.com.au> <474DFD7E.907@goop.org> <Pine.LNX.4.64.0711281604560.17738@schroedinger.engr.sgi.com> <474E163E.2070702@goop.org> <Pine.LNX.4.64.0711281731410.19914@schroedinger.engr.sgi.com> <474E1900.1010209@goop.org> <Pine.LNX.4.64.0711281745470.20042@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0711281745470.20042@schroedinger.engr.sgi.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> The percpu areas need to be allocated in a NUMA aware fashion. Otherwise 
> you use distant memory for the most performance sensitive areas. The NUMA 
> subsystem must be so far up that these allocations can be performed in the 
> right way. And this means at least you need to know on which node each 
> processor is located. That is what the PDA is currently used for and i386 
> has no other way of doing that. I think we could use an array [NR_CPUS] 
> for this one but we want to avoid these arrays because NR_CPUS may get 
> very big.
>   

Oh, you mean there needs to be some percpu data mechanism operating in
order to do numa-aware allocations, which would be necessary to allocate
the percpu memory itself?

I can see how that would be awkward.

    J

