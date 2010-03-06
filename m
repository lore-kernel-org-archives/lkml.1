Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab0CFJYf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 04:24:35 -0500
Received: from fanny.its.uu.se ([130.238.4.241]:59488 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362Ab0CFJYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 04:24:32 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19346.8003.99263.626961@pilspetsen.it.uu.se>
Date: Sat, 6 Mar 2010 10:24:19 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Christian Ehrhardt <lk@c--e.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] rmap: Fix Bugzilla Bug #5493
In-Reply-To: <20100305093834.GG17078@lisa.in-ulm.de>
References: <20100305093834.GG17078@lisa.in-ulm.de>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Ehrhardt writes:
 > 
 > Hi,
 > 
 > this patch fixes bugzilla Bug
 > 
 >         http://bugzilla.kernel.org/show_bug.cgi?id=5493
 > 
 > This bug describes a search complexity failure in rmap if a single
 > anon_vma has a huge number of vmas associated with it.
 > 
 > The patch makes the vma prio tree code somewhat more reusable and then uses
 > that to replace the linked list of vmas in an anon_vma with a prio_tree.
 > 
 > Timings for the test program in the original kernel code and
 > responsiveness of the system during the test improve dramatically.
 > 
 > NOTE: This needs an Ack from someone who can compile on arm and parisc.

Compile and boot-tested on an ARM ixp4xx machine.

Tested-by: Mikael Pettersson <mikpe@it.uu.se> (ARM bits only)
