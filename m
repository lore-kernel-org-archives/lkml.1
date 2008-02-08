Return-Path: <linux-kernel-owner+w=401wt.eu-S1762063AbYBHLUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762063AbYBHLUq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 06:20:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758389AbYBHLUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 06:20:36 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36436 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758160AbYBHLUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 06:20:35 -0500
Date: Fri, 8 Feb 2008 12:55:42 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Andi Kleen <andi@firstfloor.org>,
       Richard Knutsson <ricknu-0@student.ltu.se>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 1/2] kmemcheck v3
Message-ID: <20080208115542.GD4745@one.firstfloor.org>
References: <47AB79D4.2070605@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47AB79D4.2070605@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2008 at 10:36:20PM +0100, Vegard Nossum wrote:
> With a lot of help from Ingo Molnar and Pekka Enberg over the last couple of
> weeks, we've been able to produce a new version of kmemcheck!

Impressive patch! On the other hand a lot of the interesting
data isn't it kmalloc anymore, but in slab. Does it really track
all that much? 

Also i'm not sure how you handle initializedness of DMAed data
(like network buffers). Wouldn't you need hooks into pci_dma_*
for this?

Your assumption that only the string instructions can take
multiple page faults seems a little dangerous too.

-Andi
