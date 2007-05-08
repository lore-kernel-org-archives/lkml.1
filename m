Return-Path: <linux-kernel-owner+w=401wt.eu-S967533AbXEHNEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967533AbXEHNEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 09:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967498AbXEHNEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 09:04:20 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4914 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967500AbXEHNEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 09:04:16 -0400
Message-ID: <46407554.10801@shadowen.org>
Date: Tue, 08 May 2007 14:04:20 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-mm1
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>
In-Reply-To: <20070505014955.8f3990b5.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The SLUB code introduces the config segment below to stop SLUB being
used on powerpc:

    config ARCH_USES_SLAB_PAGE_STRUCT
       bool
       default y
       depends on SPLIT_PTLOCK_CPUS <= NR_CPUS

However as far as I can kconfig has no support for operators other than
==, !=, &&, and ||.  Who can say why we do not get an error.

Cirtainly in my testing this simply never triggers and bad kernels result.

Thoughts?

-apw
