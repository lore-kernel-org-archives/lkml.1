Return-Path: <linux-kernel-owner+w=401wt.eu-S1756318AbYIYXFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbYIYXFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 19:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753029AbYIYXFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 19:05:35 -0400
Received: from gate.crashing.org ([63.228.1.57]:34570 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794AbYIYXFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 19:05:35 -0400
Subject: Re: PTE access rules & abstraction
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Hugh Dickins <hugh@veritas.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
In-Reply-To: <48DC106D.9010601@goop.org>
References: <1221846139.8077.25.camel@pasglop>  <48D739B2.1050202@goop.org>
	 <1222117551.12085.39.camel@pasglop>
	 <Pine.LNX.4.64.0809241919520.575@blonde.site>
	 <1222291248.8277.90.camel@pasglop>
	 <Pine.LNX.4.64.0809250049270.21674@blonde.site>
	 <1222304686.8277.136.camel@pasglop>  <48DBD532.80607@goop.org>
	 <1222379063.8277.202.camel@pasglop>  <48DC106D.9010601@goop.org>
Content-Type: text/plain
Date: Fri, 26 Sep 2008 09:02:17 +1000
Message-Id: <1222383737.8277.205.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-25 at 15:27 -0700, Jeremy Fitzhardinge wrote:
> Yeah, that would work too; that's pretty much how Xen implements it
> anyway.  The main advantage of the start/commit pair is that the
> resulting code was completely unchanged from the old code.  The mprotect
> sequence using ptep_modify_protection would end up reading the pte twice
> before writing it.

Not necessarily .. depends how you factor out the interface to it.

Anyway, not a big deal now. I'll do a patch to fix the hole on powerpc,
and if my brain clicks, over the next few weeks, I'll see if I can come
up with an overall nicer API covering all usages. In many case might
just be a matter of giving a saner name to existing calls and
documenting them properly tho :-)

Cheers,
Ben.


