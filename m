Return-Path: <linux-kernel-owner+w=401wt.eu-S932460AbYDPQdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460AbYDPQdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 12:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759871AbYDPQdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 12:33:41 -0400
Received: from relay1.sgi.com ([192.48.171.29]:42486 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759665AbYDPQdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 12:33:40 -0400
Date: Wed, 16 Apr 2008 11:33:37 -0500
From: Robin Holt <holt@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Christoph Lameter <clameter@sgi.com>, akpm@linux-foundation.org,
       Nick Piggin <npiggin@suse.de>, Steve Wise <swise@opengridcomputing.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Kanoj Sarcar <kanojsarcar@yahoo.com>, Roland Dreier <rdreier@cisco.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Robin Holt <holt@sgi.com>, general@lists.openfabrics.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH 1 of 9] Lock the entire mm to prevent any mmu related
	operation to happen
Message-ID: <20080416163337.GJ22493@sgi.com>
References: <patchbomb.1207669443@duo.random> <ec6d8f91b299cf26cce5.1207669444@duo.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec6d8f91b299cf26cce5.1207669444@duo.random>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I don't think this lock mechanism is completely working.  I have
gotten a few failures trying to dereference 0x100100 which appears to
be LIST_POISON1.

Thanks,
Robin
