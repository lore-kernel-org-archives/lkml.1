Return-Path: <linux-kernel-owner+w=401wt.eu-S1757132AbYGKOmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132AbYGKOmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 10:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751582AbYGKOmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 10:42:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38789 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750932AbYGKOmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 10:42:12 -0400
Message-ID: <48777110.3000104@linux-foundation.org>
Date: Fri, 11 Jul 2008 09:41:20 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
CC: penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/5] Add new GFP flag __GFP_NOTRACE.
References: <1215712946-23572-1-git-send-email-eduard.munteanu@linux360.ro> <1215712946-23572-2-git-send-email-eduard.munteanu@linux360.ro> <20080710210606.65e240f4@linux360.ro>
In-Reply-To: <20080710210606.65e240f4@linux360.ro>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eduard - Gabriel Munteanu wrote:

> This is used by kmemtrace to correctly classify different kinds of
> allocations, without recording one event multiple times. Example: SLAB's
> kmalloc() calls kmem_cache_alloc(), but we want to record this only as a
> kmalloc.

Well then I guess we need to put the recording logic into kmem_cache_alloc?
