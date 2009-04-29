Return-Path: <linux-kernel-owner+w=401wt.eu-S1754431AbZD2GOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431AbZD2GOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 02:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbZD2GOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 02:14:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47638 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752055AbZD2GOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 02:14:19 -0400
Date: Tue, 28 Apr 2009 23:10:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org
Subject: Re: [KVM PATCH v3 0/2] irqfd
Message-Id: <20090428231002.919419dd.akpm@linux-foundation.org>
In-Reply-To: <20090427182540.6646.96740.stgit@dev.haskins.net>
References: <20090427182540.6646.96740.stgit@dev.haskins.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Apr 2009 14:33:24 -0400 Gregory Haskins <ghaskins@novell.com> wrote:

> (Applies to kvm.git 41b76d8d0487c26d6d4d3fe53c1ff59b3236f096)
> 
> This series implements a mechanism called "irqfd".  It lets you create
> an eventfd based file-desriptor to inject interrupts to a kvm guest.  We
> associate one gsi per fd for fine-grained routing.

It'd be nice if the KVM weenies amongst us were to be told why one
would want to inject interrupts into a KVM guest.  Monosyllabic words
would be preferred ;)

> We do not have a user of this interface in this series, though note
> future version of virtual-bus (v4 and above) will be based on this.

So I assume that this patchset will be merged if/when a user of it is
merged?

> The first patch will require mainline buy-in, particularly from Davide
> (cc'd).  The last patch is kvm specific.

Three EXPORT_SYMBOL_GPL()s.  Once the shouting has subsided I'd suggest
that this be merged via the KVM tree.


