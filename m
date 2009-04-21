Return-Path: <linux-kernel-owner+w=401wt.eu-S1756866AbZDUReu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866AbZDUReu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 13:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756489AbZDURee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 13:34:34 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:62242 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756758AbZDURed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 13:34:33 -0400
X-IronPort-AV: E=Sophos;i="4.40,225,1238976000"; 
   d="scan'208";a="174736232"
From: Roland Dreier <rdreier@cisco.com>
To: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
Cc: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-EWG" <ewg@lists.openfabrics.org>, Roland Dreier <rolandd@cisco.com>,
       fenkes@de.ibm.com, raisch@de.ibm.com, alexschm@de.ibm.com,
       stefan.roscher@de.ibm.com, hnguyen@de.ibm.com
Subject: Re: [PATCH 1/3] IB/ehca: Replace vmalloc with kmalloc
References: <200904211716.45245.ossrosch@linux.vnet.ibm.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 21 Apr 2009 10:34:30 -0700
In-Reply-To: <200904211716.45245.ossrosch@linux.vnet.ibm.com> (Stefan
	Roscher's message of "Tue, 21 Apr 2009 17:16:44 +0200")
Message-ID: <adaws9dvrkp.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 21 Apr 2009 17:34:30.0628 (UTC) FILETIME=[6D536A40:01C9C2A7]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > +	queue->queue_pages = kmalloc(nr_of_pages * sizeof(void *), GFP_KERNEL);

How big might this buffer be?  Any chance of allocation failure due to
memory fragmentation?

 - R.
