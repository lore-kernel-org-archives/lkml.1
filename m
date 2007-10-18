Return-Path: <linux-kernel-owner+w=401wt.eu-S1762181AbXJRIeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762181AbXJRIeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 04:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755953AbXJRIeC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 04:34:02 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58952 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582AbXJRIeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 04:34:00 -0400
Date: Thu, 18 Oct 2007 17:33:31 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch](memory hotplug) Make kmem_cache_node for SLUB on memory online to avoid panic(take 3)
Cc: Christoph Lameter <clameter@sgi.com>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
In-Reply-To: <20071018000004.cf4727e7.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0710172321550.11401@schroedinger.engr.sgi.com> <20071018000004.cf4727e7.akpm@linux-foundation.org>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20071018171917.5159.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 17 Oct 2007 23:25:58 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:
> 
> > > So that's slub.  Does slab already have this functionality or are you
> > > not bothering to maintain slab in this area?
> > 
> > Slab brings up a per node structure when the corresponding cpu is brought 
> > up. That was sufficient as long as we did not have any memoryless nodes. 

Right. At least, I don't have any experience of panic with SLAB so far.
(If panic occurred, I already made a patch.).

> > Now we may have to fix some things over there as well.

Though the fix may be better for it, my priority is very low for it
now.



-- 
Yasunori Goto 


