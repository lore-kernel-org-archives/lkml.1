Return-Path: <linux-kernel-owner+w=401wt.eu-S1759845AbZAMJWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759845AbZAMJWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 04:22:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbZAMJWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 04:22:01 -0500
Received: from casper.infradead.org ([85.118.1.10]:46511 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbZAMJV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 04:21:59 -0500
Date: Tue, 13 Jan 2009 09:24:09 +0000
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: change the default cache size to 64 bytes
Message-ID: <20090113092409.7e5fbdda@infradead.org>
In-Reply-To: <20090112224428.GA18090@elte.hu>
References: <20090112224428.GA18090@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jan 2009 23:44:28 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> >From 632c5045d6827a3d044b6eb216d0e5597b25d468 Mon Sep 17 00:00:00
> >2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Mon, 12 Jan 2009 23:37:16 +0100
> Subject: [PATCH] x86: change the default cache size to 64 bytes
> 
> Right now the generic cacheline size is 128 bytes - that is wasteful
> when structures are aligned, as all modern x86 CPUs have an
> (effective) cacheline sizes of 64 bytes.
> 
> It was set to 128 bytes due to some cacheline aliasing problems on
> older P4 systems, but those are many years old and we dont optimize
> for them anymore. (They'll still get the 128 bytes cacheline size if
> the kernel is specifically built for Pentium 4)
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Acked-by: Arjan van de Ven <arjan@linux.intel.com>


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
