Return-Path: <linux-kernel-owner+w=401wt.eu-S1752856AbXCYWWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbXCYWWu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 18:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbXCYWWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 18:22:50 -0400
Received: from smtp.osdl.org ([65.172.181.24]:60821 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856AbXCYWWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 18:22:49 -0400
Date: Sun, 25 Mar 2007 14:22:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Rudolf Marek <r.marek@assembler.cz>,
       Alexey Dobriyan <adobriyan@openvz.org>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 1/2] MSR: Add support for safe variants
Message-Id: <20070325142215.eff3af8f.akpm@linux-foundation.org>
In-Reply-To: <20070325141823.c0e9c4c7.khali@linux-fr.org>
References: <20070325141823.c0e9c4c7.khali@linux-fr.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Mar 2007 14:18:23 +0200 Jean Delvare <khali@linux-fr.org> wrote:

> Add support for _safe (exception handled) variants of rdmsr_on_cpu 
> and wrmsr_on_cpu.  This is needed for the upcoming coretemp hardware
> monitoring driver, which might step into non-existing (poorly
> documented) MSR.

Crappy changelog.  What do these functions do?  What is "safe" about them? 
This is described in neither the changelog nor the code comments, but it
should be described in both.

Also, Andi presently has several MSR patches queued (most prominently
ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt-current/patches/rwmsr-on-cpu)
but I'm not including them in -mm due to rejects.  If I get a properly
changlogged and commented version of this patch I can merge it, but it
might get wrecked again when the x86_64 tree gets sorted out.

