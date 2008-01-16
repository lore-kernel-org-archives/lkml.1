Return-Path: <linux-kernel-owner+w=401wt.eu-S1752490AbYAPRo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbYAPRo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 12:44:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbYAPRoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 12:44:19 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbYAPRoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 12:44:19 -0500
Date: Wed, 16 Jan 2008 12:42:55 -0500
From: Rik van Riel <riel@redhat.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       kvm-devel@lists.sourceforge.net, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, clameter@sgi.com,
       daniel.blueman@quadrics.com, holt@sgi.com, steiner@sgi.com,
       Andrew Morton <akpm@osdl.org>, Hugh Dickins <hugh@veritas.com>,
       Nick Piggin <npiggin@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] mmu notifiers #v2
Message-ID: <20080116124256.44033d48@bree.surriel.com>
In-Reply-To: <20080113162418.GE8736@v2.random>
References: <20080113162418.GE8736@v2.random>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jan 2008 17:24:18 +0100
Andrea Arcangeli <andrea@qumranet.com> wrote:

> In my basic initial patch I only track the tlb flushes which should be
> the minimum required to have a nice linux-VM controlled swapping
> behavior of the KVM gphysical memory. 

I have a vaguely related question on KVM swapping.

Do page accesses inside KVM guests get propagated to the host
OS, so Linux can choose a reasonable page for eviction, or is
the pageout of KVM guest pages essentially random?

-- 
All rights reversed.
