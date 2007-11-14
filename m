Return-Path: <linux-kernel-owner+w=401wt.eu-S1761136AbXKNUzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761136AbXKNUzR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 15:55:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753843AbXKNUzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 15:55:00 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:10989 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbXKNUy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 15:54:58 -0500
To: Julia Lawall <julia@diku.dk>
Cc: rolandd@cisco.com, mshefty@ichips.intel.com, halr@voltaire.com,
       openib-general@openib.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/4] drivers/infiniband: Drop redundant includes of moduleparam.h
X-Message-Flag: Warning: May contain useful information
References: <Pine.LNX.4.64.0711132234110.18337@ask.diku.dk>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 14 Nov 2007 12:54:52 -0800
In-Reply-To: <Pine.LNX.4.64.0711132234110.18337@ask.diku.dk> (Julia Lawall's message of "Tue, 13 Nov 2007 22:35:14 +0100 (CET)")
Message-ID: <adalk90zgwz.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Nov 2007 20:54:52.0693 (UTC) FILETIME=[9A93F450:01C82700]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Drop #include <linux/moduleparam.h> in files that also include #include
 > <linux/module.h>.  module.h includes moduleparam.h already.

Do we want to make this sort of source code change?  I thought that
the consensus about the kernel was that we wanted to avoid relying of
implicit includes of <Y.h> by <X.h> -- in this case a better change
would actually seem to be to explicitly include moduleparam.h in files
using module parameters and then remove the include from module.h.

 - R.
