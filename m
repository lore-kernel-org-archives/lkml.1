Return-Path: <linux-kernel-owner+w=401wt.eu-S1754894AbYFVQ7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbYFVQ7B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 12:59:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbYFVQ6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 12:58:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:58388 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbYFVQ6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 12:58:53 -0400
Date: Sun, 22 Jun 2008 09:58:37 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Jeff Chua" <jeff.chua.linux@gmail.com>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>, ecollins@vmware.com,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       support@vmware.com
Subject: Re: Linux 2.6.26-rc7
Message-ID: <20080622095837.6f396327@infradead.org>
In-Reply-To: <b6a2187b0806220012t118d85ffp671abf715c14ea94@mail.gmail.com>
References: <alpine.LFD.1.10.0806201626140.3167@woody.linux-foundation.org>
	<b6a2187b0806220012t118d85ffp671abf715c14ea94@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jun 2008 15:12:27 +0800
"Jeff Chua" <jeff.chua.linux@gmail.com> wrote:

> On Sat, Jun 21, 2008 at 7:42 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > Another week, another -rc.
> > Linus Torvalds (4):
> >      Reinstate ZERO_PAGE optimization in 'get_user_pages()' and fix
> > XIP
> 
> [89f5b7da2a6bad2e84670422ab8192382a5aeb9f]
> 
> This broke vmware 6.0.4.
> Jun 22 14:53:03.845: vmx| NOT_IMPLEMENTED
> /build/mts/release/bora-93057/bora/vmx/main/vmmonPosix.c:774
> 
> Reverting the patch makes vmware runs again. I don't know enough to
> fix this, so would be more than test any patches.
> 

is this the open source vmware guest modules, the proprietary vmware
guest modules or the proprietary "vmware as host" kernel stuff ?


