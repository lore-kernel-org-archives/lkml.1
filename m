Return-Path: <linux-kernel-owner+w=401wt.eu-S1755589AbYIYVsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589AbYIYVsX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 17:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbYIYVsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 17:48:14 -0400
Received: from gate.crashing.org ([63.228.1.57]:38784 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752593AbYIYVsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 17:48:14 -0400
Subject: Re: PTE access rules & abstraction
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Hugh Dickins <hugh@veritas.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
In-Reply-To: <48DBD532.80607@goop.org>
References: <1221846139.8077.25.camel@pasglop>  <48D739B2.1050202@goop.org>
	 <1222117551.12085.39.camel@pasglop>
	 <Pine.LNX.4.64.0809241919520.575@blonde.site>
	 <1222291248.8277.90.camel@pasglop>
	 <Pine.LNX.4.64.0809250049270.21674@blonde.site>
	 <1222304686.8277.136.camel@pasglop>  <48DBD532.80607@goop.org>
Content-Type: text/plain
Date: Fri, 26 Sep 2008 07:44:23 +1000
Message-Id: <1222379063.8277.202.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-25 at 11:15 -0700, Jeremy Fitzhardinge wrote:
> The ptep_modify_prot_start/commit pair specifies a single pte update in
> such a way to allow more implementation flexibility - ie, there's no
> naked requirement for an atomic fetch-and-clear operation.  I chose the
> transaction-like terminology to emphasize that the start/commit
> functions must be strictly paired; there's no way to fail or abort the
> "transaction".  A whole group of those start/commit pairs can be batched
> together without affecting their semantics.

I still can't see the point of having now 3 functions instead of just
one such as ptep_modify_protection(). I don't see what it buys you other
than adding gratuituous new interfaces.

Ben;.


