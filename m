Return-Path: <linux-kernel-owner+w=401wt.eu-S1753131AbYHQS6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbYHQS6n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 14:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750955AbYHQS6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 14:58:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943AbYHQS6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 14:58:34 -0400
Date: Sun, 17 Aug 2008 14:59:06 -0400
From: Rik van Riel <riel@redhat.com>
To: "Marc Villemade" <mastachand@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Follow-up] Physical memory disappeared from /proc/meminfo
Message-ID: <20080817145906.06ccd795@riellaptop.surriel.com>
In-Reply-To: <f2b895370808171059x4bd0296frf50b07ae7af21375@mail.gmail.com>
References: <f2b895370808171059x4bd0296frf50b07ae7af21375@mail.gmail.com>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Aug 2008 19:59:10 +0200
"Marc Villemade" <mastachand@gmail.com> wrote:

> I'm having exactly the same issue but on a 2.6.20.4 vanilla kernel
> (x86). /proc/meminfo shows that
> MemFree+Buffers+cached+AnonPages+Slab+Mapped != MemTotal, which AFAIK
> should be the case.

There are also page tables, vmalloc memory and various
unaccounted kernel allocations.

-- 
All rights reversed.
