Return-Path: <linux-kernel-owner+w=401wt.eu-S1758798AbYGKT5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798AbYGKT5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 15:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754849AbYGKT5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 15:57:08 -0400
Received: from [194.117.236.238] ([194.117.236.238]:46993 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754125AbYGKT5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 15:57:07 -0400
Date: Fri, 11 Jul 2008 22:56:00 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/5] Add new GFP flag __GFP_NOTRACE.
Message-ID: <20080711225600.6532b9cf@linux360.ro>
In-Reply-To: <48777110.3000104@linux-foundation.org>
References: <1215712946-23572-1-git-send-email-eduard.munteanu@linux360.ro>
	<1215712946-23572-2-git-send-email-eduard.munteanu@linux360.ro>
	<20080710210606.65e240f4@linux360.ro>
	<48777110.3000104@linux-foundation.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2008 09:41:20 -0500
Christoph Lameter <cl@linux-foundation.org> wrote:

> Eduard - Gabriel Munteanu wrote:
> 
> > This is used by kmemtrace to correctly classify different kinds of
> > allocations, without recording one event multiple times. Example:
> > SLAB's kmalloc() calls kmem_cache_alloc(), but we want to record
> > this only as a kmalloc.
> 
> Well then I guess we need to put the recording logic into
> kmem_cache_alloc?

Okay, will do it another way. I thought there may be other legitimate
uses of something like __GFP_NOTRACE.


	Eduard
