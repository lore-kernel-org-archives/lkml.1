Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbZFVOyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbZFVOyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 10:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbZFVOya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 10:54:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51756 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752427AbZFVOya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 10:54:30 -0400
Date: Mon, 22 Jun 2009 07:53:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tim Abbott <tabbott@ksplice.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Anders Kaseorg <andersk@ksplice.com>,
       Jeffrey B Arnold <jbarnold@ksplice.com>,
       "Waseem S. Daher" <wdaher@ksplice.com>
Subject: Re: [PATCH] Add new TAINT_KSPLICE flag for when a Ksplice update
 has been loaded.
Message-Id: <20090622075346.e9489feb.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0906220928010.26465@vinegar-pot.mit.edu>
References: <alpine.DEB.1.10.0906191422460.29844@vinegar-pot.mit.edu>
	<1245442307.16209.66.camel@laptop>
	<1245657114.3265.4074.camel@perihelion.bos.jonmasters.org>
	<1245660614.19816.203.camel@twins>
	<alpine.DEB.1.10.0906220928010.26465@vinegar-pot.mit.edu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jun 2009 09:32:13 -0400 (EDT) Tim Abbott <tabbott@ksplice.com> wrote:

> On Mon, 22 Jun 2009, Peter Zijlstra wrote:
> 
> > But without ksplice patches you cannot ksplice, right? That is, there is
> > a non trivial patch to the kernel to make this happen afaik. If distros
> > ship that, then they can add this taint flag as well. No need to burden
> > mainline with any of that until it ksplice proper makes it in.
> 
> No, Ksplice can patch completely unmodified upstream and distribution 
> kernels.
> 

Have the ksplice people considered using /proc/sys/kernel/tainted and
TAINT_USER?


