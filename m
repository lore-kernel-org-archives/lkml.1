Return-Path: <linux-kernel-owner+w=401wt.eu-S1763090AbXKIQAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763090AbXKIQAW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 11:00:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758716AbXKIQAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 11:00:09 -0500
Received: from ns1.suse.de ([195.135.220.2]:33332 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196AbXKIQAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 11:00:08 -0500
From: Andi Kleen <ak@suse.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: Some interesting observations when trying to optimize vmstat handling
Date: Fri, 9 Nov 2007 16:56:26 +0100
User-Agent: KMail/1.9.1
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
References: <Pine.LNX.4.64.0711081141180.9694@schroedinger.engr.sgi.com> <200711090007.43424.ak@suse.de> <4733A7A5.9000900@goop.org>
In-Reply-To: <4733A7A5.9000900@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711091656.26908.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 November 2007 01:19, Jeremy Fitzhardinge wrote:
> Andi Kleen wrote:
> > The only problem is that there might be some code who relies on
> > restore_flags() restoring other flags that IF, but at least for
> > interrupts and local_irq_save/restore it should be fine to change.
>
> I don't think so.  We don't bother to save/restore the other flags in
> Xen paravirt and it doesn't seem to cause a problem.  The semantics
> really are specific to the state of the interrupt flag.

Yes i checked the code and only case I found is actually save_flags, not 
restore_flags

(and that particular case is even unnecessary) 

-Andi

