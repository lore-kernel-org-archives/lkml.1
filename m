Return-Path: <linux-kernel-owner+w=401wt.eu-S932586AbXBNVC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586AbXBNVC6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 16:02:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932589AbXBNVC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 16:02:58 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37238 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932586AbXBNVC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 16:02:57 -0500
Date: Wed, 14 Feb 2007 21:16:46 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Marcelo Tosatti <marcelo@kvack.org>
Cc: Jordan Crouse <jordan.crouse@amd.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use movntq version of fast_clear_page/fast_copy_page on
 Geode
Message-ID: <20070214211646.74b0ad87@localhost.localdomain>
In-Reply-To: <20070214190839.GA4864@dmt.lan>
References: <20070214190839.GA4864@dmt.lan>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Feb 2007 17:08:39 -0200
Marcelo Tosatti <marcelo@kvack.org> wrote:

> 
> movntq instruction is supported by Geode CPU's, so use
> fast_clear_page/fast_copy_page versions that have it.

Is it actually faster for macro performance not just microbenchmarking ?

Alan
