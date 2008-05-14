Return-Path: <linux-kernel-owner+w=401wt.eu-S1757566AbYENHem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566AbYENHem (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 03:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbYENHee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 03:34:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:9719 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924AbYENHed convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 03:34:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,485,1204531200"; 
   d="scan'208";a="564428367"
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: + wireless-fix-iwlwifi-unify-init-driver-flow.patch added to -mm tree
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Wed, 14 May 2008 10:34:04 +0300
Message-ID: <C07C4589BE74A34981C3C3525EE1F80103DB4948@hasmsx412.ger.corp.intel.com>
In-Reply-To: <20080513.213927.191790810.davem@davemloft.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: + wireless-fix-iwlwifi-unify-init-driver-flow.patch added to -mm tree
Thread-Index: Aci1fIU0xObmDHwjRrK7IbRhPEIiZwAF/73g
References: <200805140405.m4E45oBc015343@imap1.linux-foundation.org> <20080513.213927.191790810.davem@davemloft.net>
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: "David Miller" <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>
Cc: <mm-commits@vger.kernel.org>, <linville@tuxdriver.com>,
       "Rindjunsky, Ron" <ron.rindjunsky@intel.com>, <sfr@canb.auug.org.au>
X-OriginalArrivalTime: 14 May 2008 07:34:32.0554 (UTC) FILETIME=[F386BCA0:01C8B594]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: David Miller [mailto:davem@davemloft.net]
>Sent: Wednesday, May 14, 2008 7:39 AM
>To: linux-kernel@vger.kernel.org; akpm@linux-foundation.org
>Cc: mm-commits@vger.kernel.org; linville@tuxdriver.com; Rindjunsky,
Ron;
>sfr@canb.auug.org.au; Winkler, Tomas
>Subject: Re: + wireless-fix-iwlwifi-unify-init-driver-flow.patch added
to -
>mm tree
>
>From: akpm@linux-foundation.org
>Date: Tue, 13 May 2008 21:05:50 -0700
>
>> Subject: wireless: fix "iwlwifi: unify init driver flow"
>> From: Andrew Morton <akpm@linux-foundation.org>
>>
>> drivers/net/wireless/iwlwifi/iwl-core.c: In function
'iwlcore_init_geos':
>> drivers/net/wireless/iwlwifi/iwl-core.c:323: error: implicit
declaration
>of function 'iwlcore_init_ht_hw_capab'
>>
>> This (or something like it) should be folded into the base patch to
avoid
>> breaking bisection, please.
>>
>> Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>
>> Cc: Tomas Winkler <tomas.winkler@intel.com>
>> Cc: John W. Linville <linville@tuxdriver.com>
>> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>
>Andrew, you have to figure out what we're supposed to do here.
>
>If I "fold in the patch" to avoid breaking bisection, I have to
>completely rebase my tree screwing up everyone of my downstream
>developers.
>
>Or is this some patch I'm supposed to remember to fold in several
>months from now, to some random changeset out of thousands, when the
>merge window opens?
>
>Neither option is tenable, and the headaches of neither are
>worth it purely for the sake of bisection.
>
>My solution to the bisection problem is to wait a day before pushing
>out usually, it's a best effort thing.  I do as many sanity builds as
>I can, and we also hope that someone during that day might solve the
>problem independantly and post a fix.  That way I can fix it in my
>tree locally before the tree goes public.
>
>And I think this is the most reasonable approach.
>
>Once I push something to my public tree, quite frankly, it's the real
>deal, it's staying there, and it's a part of the permanent record.
>And therefore, we'll put fixes on top.

A patch that was sent to wireless-dev among others fixes this problem
I guess it's still stack in the Linville's queue.
http://article.gmane.org/gmane.linux.kernel.wireless.general/14339

Sorry for not catching it earlier.

Thanks
Tomas 
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

