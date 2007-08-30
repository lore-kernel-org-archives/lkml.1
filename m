Return-Path: <linux-kernel-owner+w=401wt.eu-S932636AbXH3Q5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636AbXH3Q5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 12:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758432AbXH3Q53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 12:57:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51300 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757532AbXH3Q52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 12:57:28 -0400
Date: Thu, 30 Aug 2007 09:56:22 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Cc: linux-kernel@vger.kernel.org, bugme-daemon@kernel-bugs.osdl.org
Subject: Re: [Bugme-new] [Bug 8957] New: Exported functions and variables
Message-ID: <20070830095622.28504717@laptopd505.fenrus.org>
In-Reply-To: <910709.35108.qm@web52002.mail.re2.yahoo.com>
References: <910709.35108.qm@web52002.mail.re2.yahoo.com>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Aug 2007 09:41:41 -0700 (PDT)
Matti Linnanvuori <mattilinnanvuori@yahoo.com> wrote:

> I thought that the bug might happen when two kernel modules are being
> loaded. If module A is loaded and its code includes references to
> functions exported by module B, I thought module A could call those
> functions before the module_init function of module B has finished. I
> was not thinking about buggy calls to registering interface
> functions. I just thought that the kernel should not allow symbols
> exported by   EXPORT_SYMBOLto be visible to other modules before the
> module_init function is finished. One could code the exported
> functions so that they could be safely called by anyone while the
> module_init function is being called but that would be an unnecessary
> burden for coders. I think that a module should expose its functions
> and variables only by calling registering interface  functions before
> the module_init function is finished. So I think the design of the
> kernel modules is flawed if it allows anyone to call exported
> functions before the module_init function is finished.
> 

have you seen this?
module loading is pretty much serialized, so that no 2 modules are
being loaded in parallel...
