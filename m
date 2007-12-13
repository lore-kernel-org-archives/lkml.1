Return-Path: <linux-kernel-owner+w=401wt.eu-S932968AbXLMXOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968AbXLMXOo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 18:14:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755175AbXLMXOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 18:14:31 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51464 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755240AbXLMXO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 18:14:29 -0500
Date: Thu, 13 Dec 2007 15:14:29 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Tony Luck <tony.luck@intel.com>,
       Asit Mallick <asit.k.mallick@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: What was the problem with quicklists and x86-64?
In-Reply-To: <1197587431.15741.189.camel@pasglop>
Message-ID: <Pine.LNX.4.64.0712131514130.29017@schroedinger.engr.sgi.com>
References: <47603321.4030700@goop.org>  <Pine.LNX.4.64.0712131131540.13396@schroedinger.engr.sgi.com>
  <1197578876.15741.163.camel@pasglop>  <Pine.LNX.4.64.0712131251300.18314@schroedinger.engr.sgi.com>
  <1197579788.15741.172.camel@pasglop>  <Pine.LNX.4.64.0712131332100.24778@schroedinger.engr.sgi.com>
  <1197584859.15741.185.camel@pasglop>  <Pine.LNX.4.64.0712131435520.25120@schroedinger.engr.sgi.com>
 <1197587431.15741.189.camel@pasglop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2007, Benjamin Herrenschmidt wrote:

> We have a separate batch to store page table pages with an RCU head on
> it, we fire it off when it's full or when tlb gather is complete.

full? You need to wait otill the tlb gather is complete.

