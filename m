Return-Path: <linux-kernel-owner+w=401wt.eu-S1753922AbYKPRrD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbYKPRrD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 12:47:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbYKPRqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 12:46:51 -0500
Received: from mga02.intel.com ([134.134.136.20]:37980 "EHLO mga02.intel.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752066AbYKPRqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 12:46:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,614,1220252400"; 
   d="scan'208";a="463736497"
Subject: Re: iwlagn driver segfault in 2.6.28-rc3
From: reinette chatre <reinette.chatre@intel.com>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Cc: Lukas Hejtmanek <xhejtman@ics.muni.cz>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <20081116120621.GA3937@localhost.aei.mpg.de>
References: <20081111143410.GA4401@ics.muni.cz>
	 <1226560041.1115.945.camel@rc-desk>
	 <20081116120621.GA3937@localhost.aei.mpg.de>
Content-Type: text/plain
Date: Sun, 16 Nov 2008 09:47:31 -0800
Message-Id: <1226857651.1115.1260.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-11-16 at 04:06 -0800, Carlos R. Mafra wrote:

> 
> From now on I will apply Reinette's patch and wait for it to
> happen again (but it seldom happens).

Sorry but that patch does not address this problem which turned out to
be memory corruption, not uninitialized memory. Another patch is being
worked on.

Reinette

