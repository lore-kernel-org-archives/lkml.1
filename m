Return-Path: <linux-kernel-owner+w=401wt.eu-S1760042AbXK0XPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760042AbXK0XPQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 18:15:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753168AbXK0XPD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 18:15:03 -0500
Received: from relay1.sgi.com ([192.48.171.29]:42313 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752440AbXK0XPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 18:15:01 -0500
Date: Tue, 27 Nov 2007 15:15:00 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andi Kleen <andi@firstfloor.org>, travis@sgi.com, ak@suse.de,
       pageexec@freemail.hu, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mm: Prevent dereferencing non-allocated per_cpu
 variables
In-Reply-To: <20071127151241.038c146d.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0711271513460.6349@schroedinger.engr.sgi.com>
References: <20071127215052.090968000@sgi.com> <20071127215054.660250000@sgi.com>
 <20071127221628.GG24223@one.firstfloor.org> <20071127151241.038c146d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Nov 2007, Andrew Morton wrote:

> hm.  Has anyone any evidence that we're actually touching
> not-possible-cpu's memory here?

I saw it in acpi when the __cpu_offset() pointers become zero. I have 
never seen it in vmstat.c. We do not need the vmstat.c fix.
