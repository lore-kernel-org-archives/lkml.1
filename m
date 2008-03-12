Return-Path: <linux-kernel-owner+w=401wt.eu-S1755988AbYCLXeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbYCLXeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 19:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbYCLXeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 19:34:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49220 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751892AbYCLXeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 19:34:13 -0400
Date: Wed, 12 Mar 2008 16:33:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: mingo@elte.hu, clameter@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix boundary checking in free_bootmem_core
Message-Id: <20080312163359.7fe0fd80.akpm@linux-foundation.org>
In-Reply-To: <86802c440803121621j3b9ec7e8nf7ae62b894eb85df@mail.gmail.com>
References: <86802c440803111801m20349386l58a108cec13eb5ee@mail.gmail.com>
	<86802c440803121621j3b9ec7e8nf7ae62b894eb85df@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008 16:21:22 -0700
"Yinghai Lu" <yhlu.kernel@gmail.com> wrote:

> On Tue, Mar 11, 2008 at 6:01 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> > [PATCH] mm: fix boundary checking in free_bootmem_core
> >
> >  so call it when numa is enabled, we don't know which node have that range.
> >  and make it more robust.
> >
> >  try to trim it to get valid sidx, and eidx.
> >
> >  Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> >
> 
> Ingo,
> 
> this one need to be applied before
> [PATCH] x86_64: reserve dma32 early for gart
> 

So perhaps we should merge
mm-fix-boundary-checking-in-free_bootmem_core.patch into 2.6.25?

<looks at it>

Sorry, but I find the changelog very hard to amke sense of.  I presently
have:

  So call it when numa is enabled, we don't know which node have that
  range.  and make it more robust.

  Try to trim it to get valid sidx, and eidx.

Could you please expand on this?
