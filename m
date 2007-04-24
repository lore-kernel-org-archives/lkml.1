Return-Path: <linux-kernel-owner+w=401wt.eu-S1754590AbXDXI3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbXDXI3X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 04:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754594AbXDXI3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 04:29:23 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51991 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754590AbXDXI3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 04:29:21 -0400
Date: Tue, 24 Apr 2007 01:29:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Keiichi KII <k-keiichi@bx.jp.nec.com>
Cc: mpm@selenic.com, davem@davemloft.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [RFC][PATCH -mm take4 2/6] support multiple logging
Message-Id: <20070424012902.1089bc02.akpm@linux-foundation.org>
In-Reply-To: <462DBC64.9070102@bx.jp.nec.com>
References: <462605DC.2080804@bx.jp.nec.com>
	<462609D1.50300@bx.jp.nec.com>
	<20070419210813.a599c54f.akpm@linux-foundation.org>
	<46288D11.4000801@bx.jp.nec.com>
	<20070420111526.01ad7f4c.akpm@linux-foundation.org>
	<462DBC64.9070102@bx.jp.nec.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007 17:14:28 +0900 Keiichi KII <k-keiichi@bx.jp.nec.com> wrote:

> > On Fri, 20 Apr 2007 18:51:13 +0900
> > Keiichi KII <k-keiichi@bx.jp.nec.com> wrote:
> > 
> >>> I started to do some cleanups and fixups here, but abandoned it when it was
> >>> all getting a bit large.
> >>>
> >>> Here are some fixes against this patch:
> >> I'm going to fix my patches by following your reviews and send new patches 
> >> on the LKML and the netdev ML in a few days.
> >>
> > 
> > Well..  before you can finish this work we need to decide upon what the
> > interface to userspace will be.
> > 
> > - The miscdev isn't appropriate
> > 
> 
> Why isn't miscdev appropriate? 
> We just shouldn't use miscdev for networking conventionally?
> 

Yes it's rather odd, especially for networking.

What does the miscdev _do_ anyway?  Is it purely a target for the ioctls?
