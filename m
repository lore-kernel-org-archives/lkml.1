Return-Path: <linux-kernel-owner+w=401wt.eu-S933623AbXGaTDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933623AbXGaTDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 15:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757868AbXGaTDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 15:03:03 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55059 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757757AbXGaTDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 15:03:01 -0400
Date: Tue, 31 Jul 2007 12:02:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Satyam Sharma <satyam@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm] Introduce strtol_check_range()
Message-Id: <20070731120220.62a28442.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707312203150.28746@enigma.security.iitk.ac.in>
References: <alpine.LFD.0.999.0707312203150.28746@enigma.security.iitk.ac.in>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2007 22:04:10 +0530 (IST)
Satyam Sharma <satyam@infradead.org> wrote:

> [ checkpatch.pl doesn't particularly like this patch, but I wanted to be
>   consistent with the rest of lib/vsprintf.c and include/linux/kernel.h. ]

I tend to think that it isn't worth being consistent with wrong stuff - it's
just more things for people to fix up one day.  Yes, you introduce a mixture
of right and wrong, but that makes the wrong stand out more ;)
