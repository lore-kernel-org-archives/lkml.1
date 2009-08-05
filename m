Return-Path: <linux-kernel-owner+w=401wt.eu-S934070AbZHEQMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934070AbZHEQMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 12:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669AbZHEQMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 12:12:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:50678 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755767AbZHEQMw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 12:12:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,329,1246863600"; 
   d="scan'208";a="714165301"
From: "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>
To: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>
CC: "Wu, Fengguang" <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Date: Wed, 5 Aug 2009 09:12:39 -0700
Subject: RE: [RFC] respect the referenced bit of KVM guest pages?
Thread-Topic: [RFC] respect the referenced bit of KVM guest pages?
Thread-Index: AcoV5oPAXC7tl5p4SyKpBRKjaVRkCQAAKmDw
Message-ID: <9EECC02A4CC333418C00A85D21E89326B651C0BD@azsmsx502.amr.corp.intel.com>
References: <20090805024058.GA8886@localhost> <4A793B92.9040204@redhat.com>
 <20090805160504.GD23385@random.random>
In-Reply-To: <20090805160504.GD23385@random.random>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It can't distinguish. Besides the pages being refaulted (as minor
> faults) implies they weren't collected yet. So the fact they are
> allowed to stay on active list or not can't matter or alter the
> refaulting issue.

Sounds like there's some terminology confusion.  A refault is a page being discarded due to memory pressure and subsequently being faulted back in.  I was counting the number of faults between the discard and faulting back in for each affected page.  For a large number of predominately stack pages, that number was very small.

					Jeff
