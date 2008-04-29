Return-Path: <linux-kernel-owner+w=401wt.eu-S1761761AbYD2TO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761761AbYD2TO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 15:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755751AbYD2TOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 15:14:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34351 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755110AbYD2TOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 15:14:19 -0400
Date: Tue, 29 Apr 2008 12:13:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: riel@redhat.com, linux-kernel@vger.kernel.org, ajackson@redhat.com,
       airlied@redhat.com, benh@kernel.crashing.org
Subject: Re: [PATCH 1/3] make access_process_vm work on device memory
Message-Id: <20080429121322.6da6b176.akpm@linux-foundation.org>
In-Reply-To: <20080429190132.GA25793@uranus.ravnborg.org>
References: <20080429113237.614f89a1@cuia.boston.redhat.com>
	<20080429110919.dc7b8565.akpm@linux-foundation.org>
	<20080429190132.GA25793@uranus.ravnborg.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008 21:01:32 +0200
Sam Ravnborg <sam@ravnborg.org> wrote:

> > urgh.
> > 
> > We have HAVE_ARCH*
> > We have __HAVE_ARCH*
> > We have ARCH_HAS*
> > We have __ARCH_HAS*
> > 
> > what a mess.
> > 
> > Probably the preferred (but still ugly) approach is to implement
> > CONFIG_ARCH_*.
> Only if it is a Kconfig symbol.
> 
> We have recently started to use 'HAVE_*' for boolean symbols used
> to select a specific function for one architecture.
> See arch/Kconfig for a few samples.
> 
> And Documentation/kbuild/kconfig-language.txt for usage hints.
> 

I think what you're telling us is to use CONFIG_HAVE_IOREMAP_PROT?
