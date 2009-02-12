Return-Path: <linux-kernel-owner+w=401wt.eu-S1761483AbZBLWY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761483AbZBLWY3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 17:24:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbZBLWYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 17:24:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56739 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752896AbZBLWYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 17:24:20 -0500
Date: Thu, 12 Feb 2009 14:23:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: fweisbec@gmail.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       oleg@redhat.com, travis@sgi.com, a.p.zijlstra@chello.nl,
       rusty@rustcorp.com.au
Subject: Re: +
 work_on_cpu-rewrite-it-to-create-a-kernel-thread-on-demand.patch  added to
 -mm tree
Message-Id: <20090212142314.9ab6ad6f.akpm@linux-foundation.org>
In-Reply-To: <m17i3vz4lp.fsf@fess.ebiederm.org>
References: <200902031058.n13AwOoK016719@imap1.linux-foundation.org>
	<20090203121147.GB19979@elte.hu>
	<c62985530902030858y28906b2dh511c5868afabfd17@mail.gmail.com>
	<20090203112529.26e6bf76.akpm@linux-foundation.org>
	<m18wobcrw3.fsf@fess.ebiederm.org>
	<20090212124835.2fc41620.akpm@linux-foundation.org>
	<m1eiy3z4ty.fsf@fess.ebiederm.org>
	<m17i3vz4lp.fsf@fess.ebiederm.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Feb 2009 14:13:06 -0800
ebiederm@xmission.com (Eric W. Biederman) wrote:

> 
> I should follow up and say that the reason I care right now, is I am
> digging into pci hotplug.  One of the issues I'm fighting is that
> currently I appear to need a dedicated kernel thread for each pci
> hotplug slot.  It gets easy to deadlock the kernel hotplugging
> a hotplug controller otherwise.
> 

um, ok, if you say so...

I'd have thought that a short-lived kernel thread would be appropriate,
if poss.  Physical hotplug of a PCI device isn't a high-frequency
operation.

The new-fangled work_on_cpu() could do that, or maybe the new-fangled
kernel/async.c code.

