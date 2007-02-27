Return-Path: <linux-kernel-owner+w=401wt.eu-S1751870AbXB0VSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870AbXB0VSm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 16:18:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbXB0VSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 16:18:42 -0500
Received: from smtp.osdl.org ([65.172.181.24]:52611 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870AbXB0VSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 16:18:41 -0500
Date: Tue, 27 Feb 2007 13:18:40 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] udivdi3: 64 bit divide
Message-ID: <20070227131840.672d6932@localhost>
In-Reply-To: <20070227122437.da27c3cd.akpm@linux-foundation.org>
References: <20070226173517.66bf0fec@freekitty>
	<20070227122437.da27c3cd.akpm@linux-foundation.org>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Feb 2007 12:24:37 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> > On Mon, 26 Feb 2007 17:35:17 -0800 Stephen Hemminger <shemminger@linux-foundation.org> wrote:
> > The kernel already has several implmentations and usages of 64 by 64 
> > bit divide.
> > 
> > Although it is significantly slower, there are places that need it so
> > provide one generic version using scaling, and allow existing platform
> > versions to continue.
> 
> The reason we implement 64/32 via do_div() is, for better or for worse, to
> make people think before they use it.  And to make it stand out, and so
> that we discover places that are using it by accident, where they could use
> something cheaper.
> 
> However your implementation of the presumably even more expensive 64/64
> allows us to do 64/64 with a plain old "/" operator.
> 
> If the do_div() philosophy is any good then we should surely repeat it for
> 64/64, no?
> 

Then we should pull the existing udivdi3 implementations?
