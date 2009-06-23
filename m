Return-Path: <linux-kernel-owner+w=401wt.eu-S1752381AbZFWS6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381AbZFWS6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 14:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750821AbZFWS61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 14:58:27 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:34789 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750775AbZFWS60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 14:58:26 -0400
Date: Tue, 23 Jun 2009 14:56:46 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@vinegar-pot.mit.edu
To: Andrew Morton <akpm@linux-foundation.org>
cc: Peter Zijlstra <peterz@infradead.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Anders Kaseorg <andersk@ksplice.com>,
       Jeffrey B Arnold <jbarnold@ksplice.com>,
       "Waseem S. Daher" <wdaher@ksplice.com>, devel@ksplice.com
Subject: Re: [PATCH] Add new TAINT_KSPLICE flag for when a Ksplice update
 has been loaded.
In-Reply-To: <20090622075346.e9489feb.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0906221100140.26465@vinegar-pot.mit.edu>
References: <alpine.DEB.1.10.0906191422460.29844@vinegar-pot.mit.edu> <1245442307.16209.66.camel@laptop> <1245657114.3265.4074.camel@perihelion.bos.jonmasters.org> <1245660614.19816.203.camel@twins> <alpine.DEB.1.10.0906220928010.26465@vinegar-pot.mit.edu>
 <20090622075346.e9489feb.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jun 2009, Andrew Morton wrote:
> Have the ksplice people considered using /proc/sys/kernel/tainted and
> TAINT_USER?

We're thinking about using TAINT_USER to indicate when a user has 
installed a Ksplice update that they generated on their own.  We'd like to 
be able to distinguish between the cases (1) where a user has generated a 
potentially-bad Ksplice update by providing their own naughty patch and 
(2) where a user is running binary Ksplice updates provided by a vendor 
that is taking care to use Ksplice properly.  Our patch currently uses 
TAINT_KSPLICE to indicate whether _any_ Ksplice update has been applied.

	-Tim Abbott


