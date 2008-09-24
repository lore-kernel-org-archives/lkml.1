Return-Path: <linux-kernel-owner+w=401wt.eu-S1753209AbYIXX5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbYIXX5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 19:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbYIXX5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 19:57:05 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:56650 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbYIXX5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 19:57:02 -0400
Date: Thu, 25 Sep 2008 00:55:36 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: PTE access rules & abstraction
In-Reply-To: <1222291248.8277.90.camel@pasglop>
Message-ID: <Pine.LNX.4.64.0809250049270.21674@blonde.site>
References: <1221846139.8077.25.camel@pasglop>  <48D739B2.1050202@goop.org>
  <1222117551.12085.39.camel@pasglop>  <Pine.LNX.4.64.0809241919520.575@blonde.site>
 <1222291248.8277.90.camel@pasglop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2008, Benjamin Herrenschmidt wrote:
> 
> Now, regarding the above bug, I'm afraid the only approaches I see that
> would work would be to have either a ptep_get_and_clear_flush(), which I
> suppose x86 virt. people will hate, or maybe to actually have a powerpc
> specific variant of the new start/commit hooks that does the flush.

Whyever not the latter?  Jeremy seems to have gifted that to you,
for precisely such a purpose.

Hugh

p.s. I surely agree with you over the name ptep_get_and_clear_full():
horrid, even more confusing than the tlb->fullmm from which it derives
its name.  I expect I'd agree with you over a lot more too, but please,
bugfixes first.
