Return-Path: <linux-kernel-owner+w=401wt.eu-S1755336AbZIDFCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbZIDFCX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 01:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751905AbZIDFCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 01:02:22 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:24427 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbZIDFCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 01:02:22 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAK87oEqrR7PD/2dsb2JhbADBFIhBAZAoBYQb
X-IronPort-AV: E=Sophos;i="4.44,330,1249257600"; 
   d="scan'208";a="201804812"
From: Roland Dreier <rdreier@cisco.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       srajiv@linux.vnet.ibm.com, Debora Velarde <debora@linux.vnet.ibm.com>,
       Marcel Selhorst <m.selhorst@sirrix.com>,
       James Morris <jmorris@namei.org>, Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH] TPM: Fixup pubek sysfs file
References: <20090904045231.GW4973@obsidianresearch.com>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 03 Sep 2009 22:02:24 -0700
In-Reply-To: <20090904045231.GW4973@obsidianresearch.com> (Jason Gunthorpe's
	message of "Thu, 3 Sep 2009 22:52:31 -0600")
Message-ID: <adaab1bnvz3.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 04 Sep 2009 05:02:24.0423 (UTC) FILETIME=[E430FB70:01CA2D1C]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > Algorithm: 00 00 00 01
 > Encscheme: 00 03
 > Sigscheme: 00 01
 > Parameters: 00 00 08 00 00 00 00 02 00 00 00 00
 > Modulus length: 256

No argument that this fix is an improvement, but what happened to the
"one value per file" rule for sysfs??

 - R.
