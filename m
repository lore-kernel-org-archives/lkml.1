Return-Path: <linux-kernel-owner+w=401wt.eu-S1760550AbZBDVcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760550AbZBDVcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 16:32:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753794AbZBDVcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 16:32:13 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:25326 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459AbZBDVcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 16:32:12 -0500
X-IronPort-AV: E=Sophos;i="4.37,381,1231113600"; 
   d="scan'208";a="62327634"
From: Roland Dreier <rdreier@cisco.com>
To: wli@movementarian.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Eli Cohen <eli@mellanox.co.il>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: FW: [PATCH] powerpc/mm: Export HPAGE_SHIFT
References: <20090203164930.GA10101@mtls03> <ada8wonnh3t.fsf@cisco.com>
	<1233712248.16867.131.camel@pasglop>
	<20090203211329.d6190a08.akpm@linux-foundation.org>
	<aday6wmn2vr.fsf@cisco.com>
	<20090203222601.747ca8b7.akpm@linux-foundation.org>
	<adad4dym2zp.fsf@cisco.com> <20090204210037.GC10229@movementarian.org>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 04 Feb 2009 13:31:43 -0800
In-Reply-To: <20090204210037.GC10229@movementarian.org>
	(wli@movementarian.org's message of "Wed, 4 Feb 2009 16:00:37 -0500")
Message-ID: <adazlh1lwhs.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 04 Feb 2009 21:31:43.0639 (UTC) FILETIME=[F9778A70:01C9870F]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > You should be able to find the head of a compound page using the
 > compound_head() inline, so try

 > 	PAGE_SIZE << compound_order(compound_head(page))

Thanks!  Looks like that should be exactly what we need.

 - R.
