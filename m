Return-Path: <linux-kernel-owner+w=401wt.eu-S1752686AbYCLEQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbYCLEQQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 00:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbYCLEQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 00:16:03 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33506 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751390AbYCLEQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 00:16:02 -0400
Date: Tue, 11 Mar 2008 21:15:18 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] Implement slub fastpath with sequence number
In-Reply-To: <1205246043.8514.188.camel@twins>
Message-ID: <Pine.LNX.4.64.0803112114450.3874@schroedinger.engr.sgi.com>
References: <20080311093144.GB30220@Krystal> <1205246043.8514.188.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2008, Peter Zijlstra wrote:

> I would really prefer if we defer all this fast path fiddling until we
> have the cpu_ops in place, this all just makes the code utterly
> unreadable.

Ahhh.. Are you are volunteering to take the cpu_ops/cpu_alloc patchset?

