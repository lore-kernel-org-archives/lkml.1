Return-Path: <linux-kernel-owner+w=401wt.eu-S1755704AbXLMWhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704AbXLMWhU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 17:37:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754559AbXLMWhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 17:37:04 -0500
Received: from relay1.sgi.com ([192.48.171.29]:38891 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752616AbXLMWhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 17:37:01 -0500
Date: Thu, 13 Dec 2007 14:36:59 -0800 (PST)
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
In-Reply-To: <1197584859.15741.185.camel@pasglop>
Message-ID: <Pine.LNX.4.64.0712131435520.25120@schroedinger.engr.sgi.com>
References: <47603321.4030700@goop.org>  <Pine.LNX.4.64.0712131131540.13396@schroedinger.engr.sgi.com>
  <1197578876.15741.163.camel@pasglop>  <Pine.LNX.4.64.0712131251300.18314@schroedinger.engr.sgi.com>
  <1197579788.15741.172.camel@pasglop>  <Pine.LNX.4.64.0712131332100.24778@schroedinger.engr.sgi.com>
 <1197584859.15741.185.camel@pasglop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2007, Benjamin Herrenschmidt wrote:

> > No this may mean that the problem does not exist on powerpc since it 
> > seems to be okay to free pages before all processors have flushed the 
> > TLBs? Or are you deferrring the freeing of the pages via RCU?
> 
> I'm deferring the freeing with RCU.

The deferral works on a page level or for the whole list of pages that 
have been gathered?

