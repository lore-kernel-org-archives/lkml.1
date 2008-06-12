Return-Path: <linux-kernel-owner+w=401wt.eu-S1758247AbYFLJk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247AbYFLJk5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 05:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbYFLJkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 05:40:49 -0400
Received: from ozlabs.org ([203.10.76.45]:39332 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036AbYFLJks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 05:40:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18512.61122.976550.619180@cargo.ozlabs.ibm.com>
Date: Thu, 12 Jun 2008 19:39:14 +1000
From: Paul Mackerras <paulus@samba.org>
To: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
Cc: Roland Dreier <rolandd@cisco.com>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-EWG" <ewg@lists.openfabrics.org>, general@lists.openfabrics.org,
       fenkes@de.ibm.com, raisch@de.ibm.com, hnguyen@de.ibm.com,
       TKLEIN@de.ibm.com, THEMANN@de.ibm.com
Subject: Re: [PATCH REPOST] IB/ehca: In case of lost interrupts, trigger EOI to reenable interrupts
In-Reply-To: <200806101644.34693.ossrosch@linux.vnet.ibm.com>
References: <200806101644.34693.ossrosch@linux.vnet.ibm.com>
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Roscher writes:

> During corner case testing, we noticed that some versions of ehca 
> do not properly transition to interrupt done in special load situations.
> This can be resolved by periodically triggering EOI through H_EOI, 
> if eqes are pending.
> 
> Signed-off-by: Stefan Roscher <stefan.roscher@de.ibm.com>

If this is OKed by the hypervisor team, then you can add:
Acked-by: Paul Mackerras <paulus@samba.org>

Paul.
