Return-Path: <linux-kernel-owner+w=401wt.eu-S1755577AbYFIQjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbYFIQjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 12:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbYFIQjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 12:39:08 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:25537 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbYFIQjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 12:39:06 -0400
X-IronPort-AV: E=Sophos;i="4.27,613,1204531200"; 
   d="scan'208";a="39710444"
From: Roland Dreier <rdreier@cisco.com>
To: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
Cc: Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>,
       general@lists.openfabrics.org, LKML <linux-kernel@vger.kernel.org>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>, hnguyen@de.ibm.com,
       fenkes@de.ibm.com, raisch@de.ibm.com, TKLEIN@de.ibm.com,
       THEMANN@de.ibm.com
Subject: Re: [PATCH 2/2] IB/ehca: In case of lost interrupts, trigger EOI to reenable interrupts
References: <200806091745.19147.ossrosch@linux.vnet.ibm.com>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 09 Jun 2008 09:38:59 -0700
In-Reply-To: <200806091745.19147.ossrosch@linux.vnet.ibm.com> (Stefan
	Roscher's message of "Mon, 9 Jun 2008 17:45:17 +0200")
Message-ID: <adatzg28sws.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Jun 2008 16:39:00.0160 (UTC) FILETIME=[51AD5400:01C8CA4F]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > +				if (desc->chip && desc->chip->eoi)
 > +					desc->chip->eoi(irq);

This doesn't seem like the type of thing a device driver should be
doing.  Both patches are rather short on changelog text -- what is the
issue here and how does this fix it?

 - R.
