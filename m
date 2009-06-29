Return-Path: <linux-kernel-owner+w=401wt.eu-S1755909AbZF2XlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbZF2XlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 19:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbZF2XlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 19:41:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45790 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751486AbZF2XlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 19:41:04 -0400
Date: Mon, 29 Jun 2009 16:39:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: tj@kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
       linux-arch@vger.kernel.org, mingo@elte.hu, andi@firstfloor.org,
       hpa@zytor.com, tglx@linutronix.de
Subject: Re: [PATCHSET] percpu: generalize first chunk allocators and
 improve lpage NUMA support
Message-Id: <20090629163937.94c8cedd.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0906291920100.32637@gentwo.org>
References: <1245850216-31653-1-git-send-email-tj@kernel.org>
	<20090624165508.30b88343.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0906291920100.32637@gentwo.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jun 2009 19:20:53 -0400 (EDT)
Christoph Lameter <cl@linux-foundation.org> wrote:

> On Wed, 24 Jun 2009, Andrew Morton wrote:
> 
> > I assume from the tremendous number of for_each_possible_cpu()s that
> > CPU hotplug awareness won't be happening.
> 
> Per cpu areas are allocated for all possible processors. No need to handle
> offlining and onlining them.

Well yes.  My point is that this is a bug-not-a-feature ;)
