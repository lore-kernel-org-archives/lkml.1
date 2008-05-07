Return-Path: <linux-kernel-owner+w=401wt.eu-S1765363AbYEGSCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765363AbYEGSCz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 14:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755757AbYEGSCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 14:02:43 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:36694 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbYEGSCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 14:02:41 -0400
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
Date: Wed, 07 May 2008 11:02:40 -0700
In-Reply-To: <200805071800.15595.ossrosch@linux.vnet.ibm.com> (Stefan
	Roscher's message of "Wed, 7 May 2008 18:00:14 +0200")
Message-ID: <adar6ceuh4v.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 07 May 2008 18:02:40.0423 (UTC) FILETIME=[8A5AEB70:01C8B06C]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > I agree, that's why I posted the driver fix first.

Glad we agree :)

I thought about it a little more and really convinced myself that there
is no good way for generic code to handle this race.

 > So, will you apply it next?

Yes, will apply it shortly.

 - R.
