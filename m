Return-Path: <linux-kernel-owner+w=401wt.eu-S932831AbXINQHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932831AbXINQHR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 12:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbXINQHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 12:07:00 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:5382 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246AbXINQG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 12:06:58 -0400
X-IronPort-AV: E=Sophos;i="4.20,256,1186383600"; 
   d="scan'208";a="218238095"
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Steve Wise <swise@opengridcomputing.com>, sean.hefty@intel.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [PATCH v2] iw_cxgb3: Support "iwarp-only" interfaces to avoid 4-tuple conflicts.
X-Message-Flag: Warning: May contain useful information
References: <20070913191617.30937.95960.stgit@dell3.ogc.int>
	<20070914130941.GG18517@2ka.mipt.ru>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 14 Sep 2007 09:06:56 -0700
In-Reply-To: <20070914130941.GG18517@2ka.mipt.ru> (Evgeniy Polyakov's message of "Fri, 14 Sep 2007 17:09:41 +0400")
Message-ID: <ada4phxkz8f.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Sep 2007 16:06:57.0156 (UTC) FILETIME=[465B7440:01C7F6E9]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Maybe you should automatically create an alias each time new interface
 > is added so that admin would not care about proper aliases?

I agree that makes much more sense from a user interface point of
view.  Unfortunately an alias without an address doesn't make sense,
so there doesn't seem to be a way to implement that.

 - R.
