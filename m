Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212AbXFVLsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbXFVLsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 07:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbXFVLsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 07:48:42 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46532 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752425AbXFVLsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 07:48:42 -0400
Date: Fri, 22 Jun 2007 12:54:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Ni@m" <niam.niam@gmail.com>
Cc: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [1/2] 2.6.22-rc5: known regressions with patches v2
Message-ID: <20070622125428.28934ee0@the-village.bc.nu>
In-Reply-To: <a9e22dff0706220439m4bc70a30i8cc83fe92cff8bc9@mail.gmail.com>
References: <467AA8CA.2020206@googlemail.com>
	<a9e22dff0706220259y6b2cec29s8f5e059ba8c42b77@mail.gmail.com>
	<6bffcb0e0706220427p203de10epeaa6e97d3f63886d@mail.gmail.com>
	<a9e22dff0706220439m4bc70a30i8cc83fe92cff8bc9@mail.gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2007 14:39:50 +0300
"Ni@m" <niam.niam@gmail.com> wrote:

> > We have patches for "very high non-preempt latency in
> > context_struct_compute_av()" and "list_add corruption. prev->next
> > should be next (f7d28794), but was f0df8ed4 (prev=f0df8ed4) Kernel Bug
> > at lib/list_debug.c:33", but both are too intrusive.
> >
> > Anyway, those bugs are not regressions.
> The question was "why linux kernel release should have some bugs that
> would be fixed fixed in future?"

Because those bug fixes are intrusive so will potentially cause more
other bugs that will need fixing - so make the kernel a worse not a
better one in the short term.

> Let's wait and publish kernel w/o known bugs. 

That would be a bit like waiting for a Debian release and never happen.

Alan
