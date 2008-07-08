Return-Path: <linux-kernel-owner+w=401wt.eu-S1756008AbYGHQVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbYGHQVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 12:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbYGHQVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 12:21:38 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:54529 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852AbYGHQVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 12:21:37 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 0/3] stop_machine enhancements and simplifications
Date: Tue, 8 Jul 2008 18:21:09 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Max Krasnyansky <maxk@qualcomm.com>
References: <200807081750.55536.rusty@rustcorp.com.au>
In-Reply-To: <200807081750.55536.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807081821.09722.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 8. Juli 2008 schrieb Rusty Russell:
> Hi all,
> 
>    Here are the three stop_machine patches I've queued for the next merge
> window.  The first two are pretty well tested via linux-next, the last is
> recent but fairly straightforward.

Hmm, these patches dont fit on kvm.git so I tested the version from 
linux-next.

When using linux-next in a kvm guest on a linux-next host this patch set 
really improves the situation. On a guest with 64 cpus on a 1 cpu host 
stop_machine_run seems to finish immediately. 

I still have some strange problems with 25 guests * 64 cpus on one host cpu, 
but this requires further analysis.

IMHO this patch set is really an improvement to the earlier version:

Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>

