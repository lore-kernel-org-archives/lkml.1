Return-Path: <linux-kernel-owner+w=401wt.eu-S1754985AbYDWTzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985AbYDWTzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 15:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbYDWTzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 15:55:05 -0400
Received: from relay1.sgi.com ([192.48.171.29]:49191 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751630AbYDWTzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 15:55:03 -0400
Date: Wed, 23 Apr 2008 14:55:00 -0500
From: Robin Holt <holt@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>, Jack Steiner <steiner@sgi.com>
Cc: Robin Holt <holt@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       Nick Piggin <npiggin@suse.de>, Jack Steiner <steiner@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>,
       akpm@linux-foundation.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 04 of 12] Moves all mmu notifier methods outside the PT
	lock (first and not last
Message-ID: <20080423195500.GW30298@sgi.com>
References: <ac9bb1fb3de2aa5d2721.1208872280@duo.random> <Pine.LNX.4.64.0804221323510.3640@schroedinger.engr.sgi.com> <20080422224048.GR24536@duo.random> <Pine.LNX.4.64.0804221613570.4868@schroedinger.engr.sgi.com> <20080423134427.GW24536@duo.random> <20080423154536.GV30298@sgi.com> <20080423161544.GZ24536@duo.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080423161544.GZ24536@duo.random>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 06:15:45PM +0200, Andrea Arcangeli wrote:
> Once I get confirmation that everyone is ok with #v13 I'll push a #v14
> before Saturday with that cosmetical error cleaned up and
> mmu_notifier_unregister moved at the end (XPMEM will have unregister
> don't worry). I expect the 1/13 of #v14 to go in -mm and then 2.6.26.

I think GRU needs _unregister as well.

Thanks,
Robin
