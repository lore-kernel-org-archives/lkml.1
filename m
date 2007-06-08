Return-Path: <linux-kernel-owner+w=401wt.eu-S967412AbXFHCmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967412AbXFHCmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 22:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966607AbXFHCmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 22:42:09 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45790 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966155AbXFHCmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 22:42:08 -0400
Date: Thu, 7 Jun 2007 19:41:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: linux-kernel@vger.kernel.org, Mark Lord <lkml@rtr.ca>,
       Andi Kleen <ak@suse.de>
Subject: Re: divorce CONFIG_X86_PAE from CONFIG_HIGHMEM64G
Message-Id: <20070607194156.d4aacf4c.akpm@linux-foundation.org>
In-Reply-To: <20070608023551.GJ15426@holomorphy.com>
References: <20070608023551.GJ15426@holomorphy.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007 19:35:51 -0700 William Lee Irwin III <wli@holomorphy.com> wrote:

> PAE is useful for more than supporting more than 4GB RAM. It supports
> expanded swapspace and NX executable protections. Some users may want
> NX or expanded swapspace support without the overhead or instability
> of highmem. For these reasons, the following patch divorces
> CONFIG_X86_PAE from CONFIG_HIGHMEM64G.

Do (CONFIG_X86_PAE && !CONFIG_HIGHMEM64G) and (!CONFIG_X86_PAE && CONFIG_HIGHMEM64G)
kernels actually work?  I wouldn't be surprised if there are places where we used
the incorrect one.
