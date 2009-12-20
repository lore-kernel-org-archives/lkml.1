Return-Path: <linux-kernel-owner+w=401wt.eu-S1754412AbZLTS5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412AbZLTS5L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 13:57:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754134AbZLTS5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 13:57:10 -0500
Received: from mga07.intel.com ([143.182.124.22]:5957 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753265AbZLTS5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 13:57:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="224988120"
Message-ID: <4B2E737D.2060902@linux.intel.com>
Date: Sun, 20 Dec 2009 19:57:01 +0100
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Huang Ying <ying.huang@intel.com>, lenb@kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5 -v2] acpi, apei, APEI supporting infrastructure
References: <1260429417.15264.394.camel@yhuang-dev.sh.intel.com> <20091218181123.GA1470@ucw.cz>
In-Reply-To: <20091218181123.GA1470@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Does this mean we'll now try to run acpi interrpretter from NMI
> context?

No. They have a very minimal interpreter for an own very simple byte code.
That code is NMI safe.

-Andi
