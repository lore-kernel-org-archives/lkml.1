Return-Path: <linux-kernel-owner+w=401wt.eu-S1756183AbYFJOxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183AbYFJOxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 10:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbYFJOw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 10:52:59 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:28492 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbYFJOw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 10:52:59 -0400
X-IronPort-AV: E=Sophos;i="4.27,618,1204531200"; 
   d="scan'208";a="40027124"
From: Roland Dreier <rdreier@cisco.com>
To: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
Cc: Roland Dreier <rolandd@cisco.com>, Paul Mackerras <paulus@samba.org>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-EWG" <ewg@lists.openfabrics.org>, general@lists.openfabrics.org,
       fenkes@de.ibm.com, raisch@de.ibm.com, hnguyen@de.ibm.com,
       TKLEIN@de.ibm.com, THEMANN@de.ibm.com
Subject: Re: [PATCH REPOST] IB/ehca: In case of lost interrupts, trigger EOI to reenable interrupts
References: <200806101644.34693.ossrosch@linux.vnet.ibm.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 10 Jun 2008 07:52:57 -0700
In-Reply-To: <200806101644.34693.ossrosch@linux.vnet.ibm.com> (Stefan
	Roscher's message of "Tue, 10 Jun 2008 16:44:31 +0200")
Message-ID: <adatzg15ol2.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 Jun 2008 14:52:57.0719 (UTC) FILETIME=[ABC7A070:01C8CB09]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > During corner case testing, we noticed that some versions of ehca 
 > do not properly transition to interrupt done in special load situations.
 > This can be resolved by periodically triggering EOI through H_EOI, 
 > if eqes are pending.

So just to be clear: this is a workaround for a hardware/firmware bug?

 - R.
