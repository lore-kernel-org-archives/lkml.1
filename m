Return-Path: <linux-kernel-owner+w=401wt.eu-S1760432AbXKIBZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760432AbXKIBZL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 20:25:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbXKIBY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 20:24:58 -0500
Received: from gw.goop.org ([64.81.55.164]:53626 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973AbXKIBY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 20:24:58 -0500
Message-ID: <4733A7A5.9000900@goop.org>
Date: Thu, 08 Nov 2007 16:19:49 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: Some interesting observations when trying to optimize vmstat
 handling
References: <Pine.LNX.4.64.0711081141180.9694@schroedinger.engr.sgi.com> <200711090007.43424.ak@suse.de>
In-Reply-To: <200711090007.43424.ak@suse.de>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> The only problem is that there might be some code who relies on 
> restore_flags() restoring other flags that IF, but at least for interrupts
> and local_irq_save/restore it should be fine to change.
>   

I don't think so.  We don't bother to save/restore the other flags in
Xen paravirt and it doesn't seem to cause a problem.  The semantics
really are specific to the state of the interrupt flag.

    J
