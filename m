Return-Path: <linux-kernel-owner+w=401wt.eu-S1161139AbXCAXYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161139AbXCAXYM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 18:24:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161152AbXCAXYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 18:24:12 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:34565 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161139AbXCAXYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 18:24:11 -0500
X-IronPort-AV: i="4.14,238,1170662400"; 
   d="scan'208"; a="395614960:sNHT10448054032"
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix ACPI documentation in kernel-parameters.txt
X-Message-Flag: Warning: May contain useful information
References: <20070301231640.GD21440@strauss.suse.de>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 01 Mar 2007 15:23:56 -0800
In-Reply-To: <20070301231640.GD21440@strauss.suse.de> (Bernhard Walle's message of "Fri, 2 Mar 2007 00:16:40 +0100")
Message-ID: <ada4pp4mttf.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 01 Mar 2007 23:23:55.0950 (UTC) FILETIME=[AE992CE0:01C75C58]
Authentication-Results: sj-dkim-6; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim6002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Add hint that acpi=off doesn't work on IA64.

Would it make sense to add code to detect this and print a kernel
message like

    warning: ACPI is always enabled on IA64; ignoring "acpi=off"

No one reads documentation :)

 - R.
