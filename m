Return-Path: <linux-kernel-owner+w=401wt.eu-S936209AbYEWHNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936209AbYEWHNo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 03:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764951AbYEWHNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 03:13:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53910 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763207AbYEWHNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 03:13:20 -0400
Date: Fri, 23 May 2008 00:11:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, ltp-coverage@lists.sourceforge.net,
       Sam Ravnborg <sam@ravnborg.org>,
       Peter Oberparleiter <oberparleiter@googlemail.com>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 5/7] gcov: add gcov profiling infrastructure
Message-Id: <20080523001136.59ec8b34.akpm@linux-foundation.org>
In-Reply-To: <48313DE6.30802@de.ibm.com>
References: <48313DE6.30802@de.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2008 10:44:22 +0200 Peter Oberparleiter <peter.oberparleiter@de.ibm.com> wrote:

> +	Note that a kernel compiled with profiling flags will be significantly
> +        larger and run slower. Also be sure to exclude files from profiling
> +        which are not linked to the kernel image to prevent linker errors.

heh, it was all too much for mips.

{standard input}: Assembler messages:
{standard input}:2716: Error: Branch out of range
{standard input}:2819: Error: Branch out of range
{standard input}:2884: Error: Branch out of range
{standard input}:3032: Error: Branch out of range
{standard input}:3097: Error: Branch out of range
{standard input}:3151: Error: Branch out of range
{standard input}:3216: Error: Branch out of range
make[1]: *** [drivers/telephony/ixj.o] Error 1
make: *** [drivers/telephony/ixj.o] Error 2
