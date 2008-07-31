Return-Path: <linux-kernel-owner+w=401wt.eu-S1754099AbYGaIw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbYGaIw5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 04:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbYGaIwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 04:52:47 -0400
Received: from gate.crashing.org ([63.228.1.57]:35588 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971AbYGaIwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 04:52:46 -0400
Subject: Re: [PATCH 1/2] Export get_user_pages_fast
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@qumranet.com>,
       Adrian Bunk <bunk@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       lguest <lguest@ozlabs.org>, linux-kernel@vger.kernel.org
In-Reply-To: <200807311848.13142.nickpiggin@yahoo.com.au>
References: <200807301438.55941.rusty@rustcorp.com.au>
	 <200807311810.57821.nickpiggin@yahoo.com.au>
	 <20080731012151.41733ef6.akpm@linux-foundation.org>
	 <200807311848.13142.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Thu, 31 Jul 2008 18:52:23 +1000
Message-Id: <1217494343.11188.437.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-31 at 18:48 +1000, Nick Piggin wrote:
> > If we do this then corresponding changes should be made to the powerpc
> > patch upon which Ben presently sits.
> 
> Powerpc will still use the CONFIG symbol for the moment because 32-bit TLB
> flushing has not been verified to work, so we don't want to pull in the
> 64-bit gup. There is some discussion going on, but they probably need at
> least to implement pte_special, and then also do RCU freeing of page tables.

It's just a matter of building gup.c or not .. as long as it's
in the makefile as obj-$(CONFIG_PPC64) (as I put it in the merged
version of the patch), the weak symbol should work.

Ben.


