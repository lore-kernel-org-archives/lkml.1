Return-Path: <linux-kernel-owner+w=401wt.eu-S1755306AbYJTU0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbYJTU0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 16:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753466AbYJTUZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 16:25:53 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:37389 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbYJTUZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 16:25:52 -0400
X-IronPort-AV: E=Sophos;i="4.33,453,1220241600"; 
   d="scan'208";a="76891868"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Samuel Ortiz" <samuel@sortiz.org>
Subject: Re: [PATCH 1/1] [net/irda]: new Blackfin on-chip SIR IrDA driver
Date: Mon, 20 Oct 2008 16:25:57 -0400
User-Agent: KMail/1.9.5
Cc: "Bryan Wu" <cooloney@kernel.org>, jgarzik@pobox.com,
       irda-users@lists.sourceforge.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Graf Yang" <graf.yang@analog.com>
References: <1223892294-18683-1-git-send-email-cooloney@kernel.org> <20081019204858.GA3143@sortiz.org>
In-Reply-To: <20081019204858.GA3143@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810201625.58004.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 20 Oct 2008 20:25:46.0098 (UTC) FILETIME=[08637520:01C932F2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 19 Oct 2008 16:48, Samuel Ortiz pondered:
> Also, I'm surprised you dont have runtime machine id detection. I know
> that's none of my business, but are you guys working towards having 
> one single kernel supporting all blackfin CPUs ?

Nope.

Today we don't support run time processor detection in any of the drivers. 
(Since none of our end users or developers want it -- they ask us for 
smaller/faster, and compile time overhead for multiple products isn't a 
problem)...

I'm not disagreeing that the ifdef uglyness should be worked on - but that is 
separate than run time detection.

-Robin
