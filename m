Return-Path: <linux-kernel-owner+w=401wt.eu-S1755363AbZHCQBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbZHCQBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 12:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755219AbZHCQBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 12:01:45 -0400
Received: from relay.atmel.no ([80.232.32.139]:56144 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755208AbZHCQBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 12:01:44 -0400
Date: Mon, 3 Aug 2009 18:01:37 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: nicolas.ferre@atmel.com, linux@maxim.org.za, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Switch atmel_serial to dev_pm_ops
Message-ID: <20090803180137.6961a832@hskinnemoen-d830>
In-Reply-To: <20090803155049.GD5002@laptop>
References: <1249310347-22291-1-git-send-email-albin.tonnerre@free-electrons.com>
	<20090803170947.2f199b93@hskinnemoen-d830>
	<20090803155049.GD5002@laptop>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Albin Tonnerre wrote:
> On Mon, Aug 03, 2009 at 05:09:47PM +0200, Haavard Skinnemoen wrote :
> > Why not
> 
> > #define atmel_serial_pm_ops	NULL
> 
> Because the .pm field is set to the address of atmel_serial_pm_ops, and iirc
> taking the address of NULL is not allowed.

Good point.

> > >  		.name	= "atmel_usart",
> > >  		.owner	= THIS_MODULE,
> > > +		.pm = &atmel_serial_pm_ops,
> 
> > Please use a TAB instead of space to make everything nice and
> > consistent.
> 
> That's weird, because my editor does show a TAB there, and applying the patch
> with git am results in a TAB.

Hmm, it doesn't show a TAB when I apply it here...

Oh well, it's not a big deal either way.

Haavard
