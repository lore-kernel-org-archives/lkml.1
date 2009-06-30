Return-Path: <linux-kernel-owner+w=401wt.eu-S1756264AbZF3O02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264AbZF3O02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 10:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbZF3O0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 10:26:20 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:42934 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751938AbZF3O0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 10:26:19 -0400
Date: Tue, 30 Jun 2009 10:24:46 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: tj@kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
       linux-arch@vger.kernel.org, mingo@elte.hu, andi@firstfloor.org,
       hpa@zytor.com, tglx@linutronix.de
Subject: Re: [PATCHSET] percpu: generalize first chunk allocators and improve
 lpage NUMA support
In-Reply-To: <20090629163937.94c8cedd.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0906301023590.6124@gentwo.org>
References: <1245850216-31653-1-git-send-email-tj@kernel.org> <20090624165508.30b88343.akpm@linux-foundation.org> <alpine.DEB.1.10.0906291920100.32637@gentwo.org> <20090629163937.94c8cedd.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jun 2009, Andrew Morton wrote:

> On Mon, 29 Jun 2009 19:20:53 -0400 (EDT)
> Christoph Lameter <cl@linux-foundation.org> wrote:
>
> > On Wed, 24 Jun 2009, Andrew Morton wrote:
> >
> > > I assume from the tremendous number of for_each_possible_cpu()s that
> > > CPU hotplug awareness won't be happening.
> >
> > Per cpu areas are allocated for all possible processors. No need to handle
> > offlining and onlining them.
>
> Well yes.  My point is that this is a bug-not-a-feature ;)

Its a feature that I would like to exploit in the future to get rid of
some of the hotplug callbacks in the allocator.

Some state also needs to be kept for offlined processors. This is done in
per cpu data.

