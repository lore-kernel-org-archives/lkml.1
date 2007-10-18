Return-Path: <linux-kernel-owner+w=401wt.eu-S1761943AbXJRH1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761943AbXJRH1I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 03:27:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759114AbXJRH0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 03:26:48 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54412 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758315AbXJRH0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 03:26:47 -0400
Date: Thu, 18 Oct 2007 00:00:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [Patch](memory hotplug) Make kmem_cache_node for SLUB on memory
 online to avoid panic(take 3)
Message-Id: <20071018000004.cf4727e7.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0710172321550.11401@schroedinger.engr.sgi.com>
References: <20071018122345.514F.Y-GOTO@jp.fujitsu.com>
	<20071017204651.aefcece7.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0710172321550.11401@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007 23:25:58 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> > So that's slub.  Does slab already have this functionality or are you
> > not bothering to maintain slab in this area?
> 
> Slab brings up a per node structure when the corresponding cpu is brought 
> up. That was sufficient as long as we did not have any memoryless nodes. 
> Now we may have to fix some things over there as well.

Is there amy point?  Our time would be better spent in making
slab.c go away.  How close are we to being able to do that anwyay?
