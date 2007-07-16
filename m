Return-Path: <linux-kernel-owner+w=401wt.eu-S932447AbXGPROV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447AbXGPROV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 13:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750980AbXGPROJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 13:14:09 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:60879 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbXGPROF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 13:14:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAMNDm0arR7O6/2dsb2JhbAA
X-IronPort-AV: i="4.16,542,1175497200"; 
   d="scan'208"; a="182931743:sNHT23563035"
To: Joachim Fenkes <fenkes@de.ibm.com>
Cc: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH 04/10] IB/ehca: use common error code mapping instead of specific ones
X-Message-Flag: Warning: May contain useful information
References: <200707121745.27592.fenkes@de.ibm.com>
	<200707121749.03556.fenkes@de.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 16 Jul 2007 10:14:03 -0700
In-Reply-To: <200707121749.03556.fenkes@de.ibm.com> (Joachim Fenkes's message of "Thu, 12 Jul 2007 17:49:02 +0200")
Message-ID: <adaejj8w9t0.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 16 Jul 2007 17:14:04.0194 (UTC) FILETIME=[B5DFB020:01C7C7CC]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > @@ -161,8 +161,11 @@ static inline int ehca2ib_return_code(u64 ehca_rc)

applied, but as a further cleanup it seems that ehca2ib_return_code()
should be moved into a .c file and moved out of line -- I think it
would probably shrink the compiled code quite a bit, and as far as I
can see it is never used in the data path where the function call
overhead would matter at all.
