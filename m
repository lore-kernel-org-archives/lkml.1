Return-Path: <linux-kernel-owner+w=401wt.eu-S1761613AbYB0Wvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761613AbYB0Wvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 17:51:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758417AbYB0Wux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 17:50:53 -0500
Received: from relay2.sgi.com ([192.48.171.30]:48605 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761466AbYB0Wuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 17:50:52 -0500
Date: Wed, 27 Feb 2008 14:50:50 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jack Steiner <steiner@sgi.com>
cc: Andrea Arcangeli <andrea@qumranet.com>, Nick Piggin <npiggin@suse.de>,
       akpm@linux-foundation.org, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch] my mmu notifiers
In-Reply-To: <20080219142725.GA23200@sgi.com>
Message-ID: <Pine.LNX.4.64.0802271450030.13186@schroedinger.engr.sgi.com>
References: <20080219084357.GA22249@wotan.suse.de> <20080219135851.GI7128@v2.random>
 <20080219142725.GA23200@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008, Jack Steiner wrote:

> In general, though, I agree. Most users of mmu_notifiers would likely
> required a mutex or something equivalent.

The skeletons shows how to do most of it using a spinlock and a 
counter.

