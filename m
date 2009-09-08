Return-Path: <linux-kernel-owner+w=401wt.eu-S1753543AbZIHDpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbZIHDpz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 23:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbZIHDpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 23:45:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:59244 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315AbZIHDpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 23:45:54 -0400
Date: Mon, 7 Sep 2009 20:49:13 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Luming Yu <luming.yu@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: [RFC PATCH] C2 could be mapped to C3 so need a flush cache
Message-ID: <20090907204913.2aef5c49@infradead.org>
In-Reply-To: <3877989d0909071926q77aac67cj532137513710025d@mail.gmail.com>
References: <3877989d0909071926q77aac67cj532137513710025d@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Sep 2009 10:26:06 +0800
Luming Yu <luming.yu@gmail.com> wrote:

> Hi there,
> 
> I came across acpi_idle_enter_simple, noticed it looks like a bug if
> we don't flush cache for C2.
> Because some platforms just map C2 to C3.

I think you are confusing ACPI C3 with HW C3.

Only for ACPI C3 class do you need to flush the cache for this case.
For HW C3, if you would need to flush the cache, the BIOS would assign
it ACPI C3 class.
