Return-Path: <linux-kernel-owner+w=401wt.eu-S1753747AbYKJCC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbYKJCC2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 21:02:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbYKJCCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 21:02:18 -0500
Received: from mail.ocs.com.au ([202.134.241.204]:22019 "EHLO mail.ocs.com.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbYKJCCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 21:02:18 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 (debian 1:2.7.2-16) with nmh-1.2
From: Keith Owens <kaos@ocs.com.au>
To: John K <trv@freemail.gr>
cc: linux-kernel@vger.kernel.org
Subject: Re: /proc/ksyms and /proc/kallsyms relationship? 
In-reply-to: Your message of "Mon, 10 Nov 2008 03:00:16 +0200."
             <491787A0.5050901@freemail.gr> 
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Tue, 11 Nov 2008 00:02:11 +1100
Message-ID: <18101.1226322131@ocs10w>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2008 03:00:16 +0200, 
John K <trv@freemail.gr> wrote:
>In kernel 2.4, there was a /proc/ksyms file. This file, if I understand
>correctly, was a method to access the kernel's public symbol table. What
>was displayed had all the public kernel's symbols (variables,
>functions..) and its associated global addresses, along with some other
>usefull stuff, like a CRC value, and the module exporting every specific
>symbol.
>Fine until this point.
>
>In 2.6 kernels, /proc/ksyms disappeared. Many sources suggest that it
>was replaced by the /proc/kallsyms file.
>BUT this file seems to be something completely different, and I haven't
>figured out in what way it is different. It seems that it's not the
>kernels public symbols table.
>
>So, some questions to anyone that knows more on this:
>
>1. Is my description of the functionality of /proc/ksyms in 2.4 kernels
>correct?

Yes.

>2. What exactly the /proc/kallsyms file contains? Why does this file
>exist and how is it used?

kallsyms contains (as the name suggests) all the global symbols in the
kernel and the loaded modules.  It was originally added for kernel
debugging but it became so useful that it supplanted ksyms.

>4. If one wants to find out what are the exported symbols from some
>module, so to know which symbols can he use in a future module, how can
>he achieve this?

nm <path_to_module.ko> | grep __ksymtab

