Return-Path: <linux-kernel-owner+w=401wt.eu-S1758775AbXIXSxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775AbXIXSxV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 14:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755399AbXIXSxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 14:53:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58688 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382AbXIXSxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 14:53:11 -0400
Date: Mon, 24 Sep 2007 12:52:30 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, adobriyan@sw.ru,
       peterz@infradead.org, Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [PATCH] make lockdep happy with r/o bind mounts
Message-ID: <20070924125230.0f144a84@laptopd505.fenrus.org>
In-Reply-To: <20070924174658.2B3D54B8@kernel>
References: <20070924174658.2B3D54B8@kernel>
Organization: Intel
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2007 10:46:58 -0700
Dave Hansen <haveblue@us.ibm.com> wrote:

> 
> With the r/o bind mount patches, we can have as many
> spinlocks nested as there are CPUs on the system.
> Lockdep freaks out after 8.

The patch implements the right solution for this "invent your own lock"
situation... 

Acked-by: Arjan van de Ven <arjan@linux.intel.com>
