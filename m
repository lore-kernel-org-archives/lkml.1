Return-Path: <linux-kernel-owner+w=401wt.eu-S1763133AbYBEXPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763133AbYBEXPc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 18:15:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759378AbYBEXPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 18:15:24 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36855 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755615AbYBEXPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 18:15:22 -0500
Date: Tue, 5 Feb 2008 15:14:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [X86 ACPI SMP] system slow after cold start if processor module
 loaded
Message-Id: <20080205151451.a47535c2.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0802021558340.5546@axis700.grange>
References: <Pine.LNX.4.64.0802021558340.5546@axis700.grange>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Feb 2008 16:05:41 +0100 (CET)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> Hi
> 
> Don't know if this should be considered a bug-report, or just another ACPI 
> bug on my system. In any case, if the CONFIG_ACPI_PROCESSOR is enabled, on 
> first boot after a power off the system is slow. Not like if only 1 of 2 
> CPUs actually was running, much slower yet. Respectively, if the module is 
> built into the kernel, it is slow more or less from the beginning - I 
> guess, from the moment, when the module is initialized, if built as a 
> module, it is slow after the module gets loaded. Also funny, it is only 
> slow on the first boot, after a reboot into the same kernel it runs 
> normally. The system is a dual P-II@400MHz, Compaq AP400. It is known to 
> have various ACPI bugs, so, this is just another one of them. No idea 
> whether or not this shall and can be fixed. At least wanted to document it 
> in case someone has a similar problem.
> 

(added linux-acpi)

If nothing happens with this (likely) then please raise a report against
acpi at bugzilla.kernel.org, thanks.

