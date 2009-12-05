Return-Path: <linux-kernel-owner+w=401wt.eu-S1756922AbZLERug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922AbZLERug (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 12:50:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756743AbZLERuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 12:50:35 -0500
Received: from mail.perches.com ([173.55.12.10]:1027 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756699AbZLERue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 12:50:34 -0500
Subject: Re: [PATCH net-next-2.6] drivers/net: Move && and || to end of
 previous line
From: Joe Perches <joe@perches.com>
To: William Allen Simpson <william.allen.simpson@gmail.com>
Cc: Brice Goglin <brice@myri.com>, David Miller <davem@davemloft.net>,
       netdev@vger.kernel.org,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>
In-Reply-To: <4B1A557D.4080707@gmail.com>
References: <1259001504.16503.79.camel@Joe-Laptop.home>
	 <20091123.104130.117837098.davem@davemloft.net>
	 <1259528449.29779.194.camel@Joe-Laptop.home>
	 <20091129.165557.84377714.davem@davemloft.net>
	 <1259863101.22783.63.camel@Joe-Laptop.home>  <4B190A29.5080905@myri.com>
	 <1259947271.22783.120.camel@Joe-Laptop.home>  <4B1A557D.4080707@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Dec 2009 09:50:40 -0800
Message-ID: <1260035440.11126.50.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-12-05 at 07:43 -0500, William Allen Simpson wrote:
> Joe Perches wrote:
> > On Fri, 2009-12-04 at 14:10 +0100, Brice Goglin wrote:
> >> Joe Perches wrote:
> >>> Only files where David Miller is the primary git-signer.
> >>> wireless, wimax, ixgbe, etc are not modified.
> >> What's the point? Having them at the beginning of the next line is
> >> easier to read from my point of view.
> > It's just a stupid consistency thing.
> Joe *agrees* that
> having them on the beginning of the line is preferred.

This is not true.

I prefer code that I write for myself to
use leading continuation tests.

For the Linux code, as should be obvious
from the patches I submit, I prefer to
have adherence to one predominant majority
style.  I don't much care what form that
style actually takes.

> Thousands of
> contributors throughout the tree agree.
> This is entirely a Miller thing.

Nope.  There have been many efforts to
help standardize on single form styles.

> My main objection to these sweeping patches is that it makes it much
> more difficult to maintain and apply patches across different versions of
> the tree.

I think you underestimate the value of
standardization and overestimate the
quantity of work to sort it out for
the -stable versions.

cheers, Joe

