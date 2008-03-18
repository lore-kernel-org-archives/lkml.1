Return-Path: <linux-kernel-owner+w=401wt.eu-S966196AbYCSVXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966196AbYCSVXM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:23:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762089AbYCSUAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:00:30 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:10517 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762075AbYCSUA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:00:26 -0400
To: Hoang-Nam Nguyen <HNGUYEN@de.ibm.com>
Cc: Christoph Raisch <raisch@de.ibm.com>, general@lists.openfabrics.org,
       Hal Rosenstock <hal.rosenstock@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH 1/3] Infiniband: make ehca_pd use struct pid pointer rather than pid_t
X-Message-Flag: Warning: May contain useful information
References: <OFCEB1A067.C70D2E66-ONC1257410.0055A0B0-C1257410.005729C4@de.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 18 Mar 2008 09:10:55 -0700
In-Reply-To: <OFCEB1A067.C70D2E66-ONC1257410.0055A0B0-C1257410.005729C4@de.ibm.com> (Hoang-Nam Nguyen's message of "Tue, 18 Mar 2008 16:52:27 +0100")
Message-ID: <adaprtsf1ww.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 18 Mar 2008 16:10:56.0461 (UTC) FILETIME=[A5D3FFD0:01C88912]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Reason for above checking is to prevent a child process releasing
 > a resource that the parent process has created and still wants to use.
 > Do you think that's something we can generalize into ib_core?

Clearly if we want that check then it should be in the core uverbs
module.  But I'm not sure why we would want that check -- I don't see
any realistic scenario where that would cause problems, and it seems
at least as likely that the check would break an app that
intentionally does something clever.

 - R.

