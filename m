Return-Path: <linux-kernel-owner+w=401wt.eu-S1752281AbZHETAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281AbZHETAR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 15:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbZHETAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 15:00:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:42293 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbZHETAP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 15:00:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,330,1246863600"; 
   d="scan'208";a="714222486"
From: "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>
To: Rik van Riel <riel@redhat.com>, "Wu, Fengguang" <fengguang.wu@intel.com>
CC: "Yu, Wilfred" <wilfred.yu@intel.com>, "Kleen, Andi" <andi.kleen@intel.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Date: Wed, 5 Aug 2009 12:00:13 -0700
Subject: RE: [RFC] respect the referenced bit of KVM guest pages?
Thread-Topic: [RFC] respect the referenced bit of KVM guest pages?
Thread-Index: AcoV9bNtNuKSm+uPTva8lwYFvJcZcAACO/8g
Message-ID: <9EECC02A4CC333418C00A85D21E89326B651C1FE@azsmsx502.amr.corp.intel.com>
References: <20090805024058.GA8886@localhost> <4A79C70C.6010200@redhat.com>
In-Reply-To: <4A79C70C.6010200@redhat.com>
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

> Also, the inactive list (where references to anonymous pages
> _do_ count) is pretty big.  Is it not big enough in Jeff's
> test case?

> Jeff, what kind of workloads are you running in the guests?

I'm looking at KVM on small systems.  My "small system" is a 128M memory compartment on a 4G server.

The workload is boot up the instance, start Firefox and another app (whatever editor comes by default with Moblin), close them, and shut down the instance.

					Jeff

