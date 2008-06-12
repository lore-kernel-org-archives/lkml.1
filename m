Return-Path: <linux-kernel-owner+w=401wt.eu-S1759232AbYFLIip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759232AbYFLIip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 04:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758676AbYFLIhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 04:37:53 -0400
Received: from ozlabs.org ([203.10.76.45]:44598 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758651AbYFLIhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 04:37:52 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18512.57420.267003.723681@cargo.ozlabs.ibm.com>
Date: Thu, 12 Jun 2008 18:37:32 +1000
From: Paul Mackerras <paulus@samba.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: Stefan Roscher <ossrosch@linux.vnet.ibm.com>,
       Roland Dreier <rolandd@cisco.com>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-EWG" <ewg@lists.openfabrics.org>, general@lists.openfabrics.org,
       fenkes@de.ibm.com, raisch@de.ibm.com, hnguyen@de.ibm.com,
       TKLEIN@de.ibm.com, THEMANN@de.ibm.com
Subject: Re: [PATCH REPOST] IB/ehca: In case of lost interrupts, trigger EOI to reenable interrupts
In-Reply-To: <adaabht5klx.fsf@cisco.com>
References: <200806101644.34693.ossrosch@linux.vnet.ibm.com>
	<adatzg15ol2.fsf@cisco.com>
	<200806101701.47090.ossrosch@linux.vnet.ibm.com>
	<adaabht5klx.fsf@cisco.com>
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier writes:

>  > > So just to be clear: this is a workaround for a hardware/firmware bug?
> 
>  > Yes it is.
> 
> OK, so paulus et al... does it seem like a good approach to call H_EOI
> from driver code (given that this driver makes tons of other hcalls)?

If this workaround is approved by the relevant hardware & firmware
folks, and demonstrably fixes the bug, then I am happy with it.

Paul.
