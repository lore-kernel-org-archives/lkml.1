Return-Path: <linux-kernel-owner+w=401wt.eu-S1754580AbZIOO60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbZIOO60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 10:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754548AbZIOO6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 10:58:22 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:58521 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495AbZIOO6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 10:58:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEABtIr0qrR7PE/2dsb2JhbADHCohMAY93BYQX
X-IronPort-AV: E=Sophos;i="4.44,390,1249257600"; 
   d="scan'208";a="204813764"
From: Roland Dreier <rdreier@cisco.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [ofa-general] Re: [GIT PULL] please pull ummunotify
References: <aday6omhz9d.fsf@cisco.com> <20090915113434.GF1328@ucw.cz>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 15 Sep 2009 07:57:56 -0700
In-Reply-To: <20090915113434.GF1328@ucw.cz> (Pavel Machek's message of "Tue,
	15 Sep 2009 13:34:34 +0200")
Message-ID: <ada7hw0gsqz.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 15 Sep 2009 14:57:57.0275 (UTC) FILETIME=[E92CBEB0:01CA3614]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > I don't remember seeing discussion of this on lkml. Yes it  is in
 > -next...

eg http://lkml.org/lkml/2009/7/31/197 and followups, or search for v2
and earlier patches.

 > Basically it allows app to 'trace itself'? ...with interesting mmap()
 > interface, exporting int to userspace, hoping it behaves atomically...? 

Yes, it allows app to trace what the kernel does to memory mappings.  I
don't believe there's any real issue to atomicity of mmap'ed memory,
since userspace really just tests whether read value is == to old read
value or not.

 - R.
