Return-Path: <linux-kernel-owner+w=401wt.eu-S932330AbXB1VkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330AbXB1VkT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 16:40:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932374AbXB1VkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 16:40:18 -0500
Received: from smtp.osdl.org ([65.172.181.24]:44682 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932330AbXB1VkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 16:40:16 -0500
Date: Wed, 28 Feb 2007 13:40:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: John Reiser <jreiser@BitWagon.com>, linux-kernel@vger.kernel.org
Subject: Re: fully honor vdso_enabled [i386, sh; x86_64?]
Message-Id: <20070228134010.345763e2.akpm@linux-foundation.org>
In-Reply-To: <20070228091110.GA26128@linux-sh.org>
References: <45DDFD98.4080300@BitWagon.com>
	<20070228091110.GA26128@linux-sh.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Feb 2007 18:11:11 +0900
Paul Mundt <lethal@linux-sh.org> wrote:

> On Thu, Feb 22, 2007 at 12:31:20PM -0800, John Reiser wrote:
> > This patch changes arch_setup_additonal_pages() to honor vdso_enabled.
> > For i386 it also allows the option of a fixed addresss to avoid
> > fragmenting the address space.  Compiles and runs on i386.
> > x86_64 [IA32 support] and sh maintainers also please comment.
> > 
> We didn't actually have the sysctl entry wired up on SH, but once that's
> done, this patch works fine there too.
> 
> Andrew, do you want a separate patch for the vdso_enabled sysctl or
> is it more convenient through my git tree?
> 

If it's an sh-only thing then through your tree is fine, thanks.
