Return-Path: <linux-kernel-owner+w=401wt.eu-S1758020AbZKTAnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020AbZKTAnF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 19:43:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752931AbZKTAnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 19:43:04 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:55132 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbZKTAnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 19:43:02 -0500
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAKZ0BUurR7Hu/2dsb2JhbAC+BpdphDsE
X-IronPort-AV: E=Sophos;i="4.44,774,1249257600"; 
   d="scan'208";a="436389746"
From: Roland Dreier <rdreier@cisco.com>
To: "Sean Hefty" <sean.hefty@intel.com>
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>, <general@lists.openfabrics.org>,
       <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: infiniband tree build failure
References: <20091120110342.5128b8f8.sfr@canb.auug.org.au>
	<ada1vju6oa6.fsf@roland-alpha.cisco.com>
	<6307584467EB4D168602C43E0B185157@amr.corp.intel.com>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 19 Nov 2009 16:43:07 -0800
In-Reply-To: <6307584467EB4D168602C43E0B185157@amr.corp.intel.com> (Sean
	Hefty's message of "Thu, 19 Nov 2009 16:30:55 -0800")
Message-ID: <adaskca58mc.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 20 Nov 2009 00:43:08.0010 (UTC) FILETIME=[6DA77CA0:01CA697A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > Off the top of my head, I'll guess that maybe we need to add something like

 > #if defined(CONFIG_IPv6) || defined(CONFIG_IPV6_MODULE)

Yes, makes sense, I'll throw that in.

 - R.
