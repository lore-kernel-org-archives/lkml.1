Return-Path: <linux-kernel-owner+w=401wt.eu-S1762046AbYJJQT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762046AbYJJQT7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 12:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759653AbYJJQTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 12:19:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58905
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758774AbYJJQTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 12:19:49 -0400
Date: Fri, 10 Oct 2008 09:19:25 -0700 (PDT)
Message-Id: <20081010.091925.120612769.davem@davemloft.net>
To: jwboyer@gmail.com
Cc: alan@redhat.com, torvalds@osdl.org, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org
Subject: Re: [PATCH 22/27] serial: Make uart_port's ioport "unsigned long".
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081010125434.GB8590@yoda.jdub.homelinux.org>
References: <20081010103447.31597.42992.stgit@localhost.localdomain>
	<20081010105052.31597.41476.stgit@localhost.localdomain>
	<20081010125434.GB8590@yoda.jdub.homelinux.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Boyer <jwboyer@gmail.com>
Date: Fri, 10 Oct 2008 08:54:34 -0400

> On Fri, Oct 10, 2008 at 11:50:56AM +0100, Alan Cox wrote:
> >From: David Miller <davem@davemloft.net>
> >
> >Otherwise the top 32-bits of the resource value get chopped
> >off on 64-bit systems, and the resulting I/O accesses go to
> >random places.
> >
> >Thanks to testing and debugging by Josip Rodin, which helped
> >track this down.
> >
> >Signed-off-by: David S. Miller <davem@davemloft.net>
> >Signed-off-by: Alan Cox <alan@redhat.com>
> 
> I emailed on an earlier posting of this about using resource_size_t
> instead as we have 32-bit CPUs with 64-bit address spaces.  If I'm
> totally wrong, that's fine but I'm still wondering if that would be
> a better general solution.

That seems like a fine idea to me, please post a follow-on patch
if you like :-)
