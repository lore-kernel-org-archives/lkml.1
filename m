Return-Path: <linux-kernel-owner+w=401wt.eu-S1759856AbXLLU3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759856AbXLLU3Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 15:29:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbXLLU3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 15:29:16 -0500
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:38251 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbXLLU3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 15:29:14 -0500
To: Joachim Fenkes <fenkes@de.ibm.com>
Cc: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>,
       Arnd Bergmann <arnd@arndb.de>, "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Marcus Eder <meder@de.ibm.com>
Subject: Re: [PATCH] IB/ehca: Serialize HCA-related hCalls if necessary
X-Message-Flag: Warning: May contain useful information
References: <200712101859.11218.fenkes@de.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 12 Dec 2007 12:29:09 -0800
In-Reply-To: <200712101859.11218.fenkes@de.ibm.com> (Joachim Fenkes's message of "Mon, 10 Dec 2007 18:59:10 +0100")
Message-ID: <ada3au78xnu.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 12 Dec 2007 20:29:10.0220 (UTC) FILETIME=[A6C240C0:01C83CFD]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied.

With your next batch of patches for 2.6.25, could you clean up:

 > --- a/drivers/infiniband/hw/ehca/hcp_if.c
 > +++ b/drivers/infiniband/hw/ehca/hcp_if.c
 > @@ -89,6 +89,7 @@
 >  #define HCALL9_REGS_FORMAT HCALL7_REGS_FORMAT " r11=%lx r12=%lx"
 >  
 >  static DEFINE_SPINLOCK(hcall_lock);
 > +extern int ehca_lock_hcalls;

and move that extern declaration into an appropriate header file?

Thanks...
