Return-Path: <linux-kernel-owner+w=401wt.eu-S1758578AbYB2AZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578AbYB2AZR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 19:25:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbYB2AZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 19:25:04 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:35541
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303AbYB2AZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 19:25:03 -0500
Date: Fri, 29 Feb 2008 01:24:59 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Jack Steiner <steiner@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>, Nick Piggin <npiggin@suse.de>,
       akpm@linux-foundation.org, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [PATCH] mmu notifiers #v7
Message-ID: <20080229001126.GL8091@v2.random>
References: <20080219231157.GC18912@wotan.suse.de> <20080220010941.GR7128@v2.random> <20080220103942.GU7128@v2.random> <20080221045430.GC15215@wotan.suse.de> <20080221144023.GC9427@v2.random> <20080221161028.GA14220@sgi.com> <20080227192610.GF28483@v2.random> <Pine.LNX.4.64.0802281139250.30865@schroedinger.engr.sgi.com> <20080228215257.GJ8091@v2.random> <20080228231732.GA21604@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080228231732.GA21604@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 05:17:33PM -0600, Jack Steiner wrote:
> I disagree. The location of the callout IS a performance issue. In simple
> comparisons of the 2 patches (Christoph's vs. Andrea's), Andrea's has a 7X
> increase in the number of TLB purges being issued to the GRU. TLB flushing

Are you sure that you're referring to #v7?
