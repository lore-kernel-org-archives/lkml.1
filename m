Return-Path: <linux-kernel-owner+w=401wt.eu-S1753949AbZBDGQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbZBDGQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 01:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbZBDGQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 01:16:11 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:50168 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbZBDGQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 01:16:10 -0500
X-IronPort-AV: E=Sophos;i="4.37,376,1231113600"; 
   d="scan'208";a="137456282"
From: Roland Dreier <rdreier@cisco.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Eli Cohen <eli@mellanox.co.il>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: FW: [PATCH] powerpc/mm: Export HPAGE_SHIFT
References: <20090203164930.GA10101@mtls03> <ada8wonnh3t.fsf@cisco.com>
	<1233712248.16867.131.camel@pasglop>
	<20090203211329.d6190a08.akpm@linux-foundation.org>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 03 Feb 2009 22:16:08 -0800
In-Reply-To: <20090203211329.d6190a08.akpm@linux-foundation.org> (Andrew
	Morton's message of "Tue, 3 Feb 2009 21:13:29 -0800")
Message-ID: <aday6wmn2vr.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 04 Feb 2009 06:16:09.0223 (UTC) FILETIME=[1200E170:01C98690]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > I think it's something like
 > 
 > 	huge_page_size(page_hstate(page))

That would suit.  I assume the intention is for that to be usable by
driver modules on any architecture?

 - R.
