Return-Path: <linux-kernel-owner+w=401wt.eu-S1756925AbZFMWQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925AbZFMWQf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 18:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750909AbZFMWQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 18:16:28 -0400
Received: from syd-iport-1.cisco.com ([64.104.193.196]:23092 "EHLO
	syd-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbZFMWQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 18:16:27 -0400
X-Greylist: delayed 703 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Jun 2009 18:16:27 EDT
X-IronPort-AV: E=Sophos;i="4.42,215,1243814400"; 
   d="scan'208";a="55640596"
From: Roland Dreier <rdreier@cisco.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "Barnes\, Jesse" <jesse.barnes@intel.com>, Matthew Wilcox <matthew@wil.cx>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: Re: mthca double free irqs
References: <86802c440906111945n2a42dc94mf08bd2b1a252842f@mail.gmail.com>
	<ada1vpozrf9.fsf@cisco.com>
	<86802c440906131228y6365f23fi59cd04f381fe92fc@mail.gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Sat, 13 Jun 2009 15:04:28 -0700
In-Reply-To: <86802c440906131228y6365f23fi59cd04f381fe92fc@mail.gmail.com>
	(Yinghai Lu's message of "Sat, 13 Jun 2009 12:28:29 -0700")
Message-ID: <adahbyjyemr.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 Jun 2009 22:04:29.0510 (UTC) FILETIME=[EC816660:01C9EC72]
Authentication-Results: syd-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/syddkim1002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > thanks, that fixes the problem.

Thanks, will merge with your reported-by/tested-by included.

 - R.
