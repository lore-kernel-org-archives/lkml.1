Return-Path: <linux-kernel-owner+w=401wt.eu-S1755634AbYFLGf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634AbYFLGf3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 02:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbYFLGfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 02:35:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54092 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752541AbYFLGfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 02:35:21 -0400
Date: Wed, 11 Jun 2008 23:34:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nadia Derbey <Nadia.Derbey@bull.net>,
       Manfred Spraul <manfred@colorfullife.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: repeatable slab corruption with LTP msgctl08
Message-Id: <20080611233449.08e6eaa0.akpm@linux-foundation.org>
In-Reply-To: <20080611221324.42270ef2.akpm@linux-foundation.org>
References: <20080611221324.42270ef2.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2008 22:13:24 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> Running current mainline on my old 2-way PIII.  Distro is RH FC1.  LTP
> version is ltp-full-20070228 (lots of retro-computing there).
> 
> Config is at http://userweb.kernel.org/~akpm/config-vmm.txt
> 
> 
> ./testcases/bin/msgctl08 crashes after ten minutes or so:

ah, it runs to completion in about ten seconds on 2.6.25, so it'll be
easy for someone to bisect it.

What's that?  Sigh.  OK.  I wasn't doing anything much anyway.
