Return-Path: <linux-kernel-owner+w=401wt.eu-S1765251AbYEWGCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765251AbYEWGCQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 02:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbYEWGB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 02:01:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43898 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752017AbYEWGB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 02:01:57 -0400
Date: Thu, 22 May 2008 23:01:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       ajackson@redhat.com, airlied@redhat.com, benh@kernel.crashing.org
Subject: Re: [patch 0/5] access_process_vm device memory access
Message-Id: <20080522230127.8af80abe.akpm@linux-foundation.org>
In-Reply-To: <20080522225857.014e7be0.akpm@linux-foundation.org>
References: <20080515175357.636334082@redhat.com>
	<20080522225857.014e7be0.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008 22:58:57 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 15 May 2008 13:53:57 -0400 Rik van Riel <riel@redhat.com> wrote:
> 
> > In order to be able to debug things like the X server and programs
> > using the PPC Cell SPUs, the debugger needs to be able to access
> > device memory through ptrace and /proc/pid/mem.
> 
> My alpha allmodconfig build is unwell
> 
> drivers/built-in.o:(.data+0x4600): undefined reference to `generic_access_phys'
> 
> and I think you might be involved.

Ditto arch/arm/configs/iop32x_defconfig
