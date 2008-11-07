Return-Path: <linux-kernel-owner+w=401wt.eu-S1752681AbYKGQ6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbYKGQ6p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 11:58:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753609AbYKGQ6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 11:58:34 -0500
Received: from mga09.intel.com ([134.134.136.24]:28834 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591AbYKGQ6d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 11:58:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,565,1220252400"; 
   d="scan'208";a="460469204"
From: "Luck, Tony" <tony.luck@intel.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       "shehjart@cse.unsw.edu.au" <shehjart@cse.unsw.edu.au>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>
Date: Fri, 7 Nov 2008 08:58:28 -0800
Subject: RE: Panic in multiple kernels: IA64 SBA IOMMU: Culprit commit on
 Mar 28, 2008
Thread-Topic: Panic in multiple kernels: IA64 SBA IOMMU: Culprit commit on
 Mar 28, 2008
Thread-Index: AclAi+qxSkx82mnaSC2mcoddT3tcngAbe6ug
Message-ID: <57C9024A16AD2D4C97DC78E552063EA35C227994@orsmsx505.amr.corp.intel.com>
References: <490F880E.4000801@cse.unsw.edu.au>
	<20081106032605J.fujita.tomonori@lab.ntt.co.jp>
	<49125F21.8010806@cse.unsw.edu.au>
 <20081107125011M.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081107125011M.fujita.tomonori@lab.ntt.co.jp>
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

> Can you check if data corruption doesn't happen during the tests?

Very important!!!

> Tony, changing the sba IOMMU driver to return an error instead of
> panic in the case of allocation failure is fine with you?

This is fine ... but we do need to audit the callers to make
sure that they check for and handle this new error.

-Tony
