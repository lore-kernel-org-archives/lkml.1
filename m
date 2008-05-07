Return-Path: <linux-kernel-owner+w=401wt.eu-S933339AbYEGTSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933339AbYEGTSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 15:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756442AbYEGTSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 15:18:23 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:45961 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762442AbYEGTSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 15:18:20 -0400
From: Roland Dreier <rdreier@cisco.com>
To: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       "OF-EWG" <ewg@lists.openfabrics.org>, fenkes@de.ibm.com,
       raisch@de.ibm.com
Subject: Re: [ewg] [PATCH] IB/ehca: Protect QP against destroying until all async events for it are handled.
References: <200805071319.37164.ossrosch@linux.vnet.ibm.com>
	<adahcdaw2oc.fsf@cisco.com>
	<200805071800.15595.ossrosch@linux.vnet.ibm.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 07 May 2008 12:18:18 -0700
In-Reply-To: <200805071800.15595.ossrosch@linux.vnet.ibm.com> (Stefan
	Roscher's message of "Wed, 7 May 2008 18:00:14 +0200")
Message-ID: <adaej8dvs79.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 07 May 2008 19:18:19.0152 (UTC) FILETIME=[1BA60100:01C8B077]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I applied this, but thinking about it further, do you (theoretically
at least) have the same problem with CQ and SRQ async events?

 - R.
