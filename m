Return-Path: <linux-kernel-owner+w=401wt.eu-S1752638Ab0AUGFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab0AUGFh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 01:05:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423Ab0AUGFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 01:05:36 -0500
Received: from casper.infradead.org ([85.118.1.10]:45384 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab0AUGFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 01:05:35 -0500
Date: Wed, 20 Jan 2010 22:05:53 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Driver-Core: devtmpfs - remove EXPERIMENTAL and enable it by 
 default
Message-ID: <20100120220553.66af4fd7@infradead.org>
In-Reply-To: <ac3eb2511001200953g3fc2be3ay30174b0429707c93@mail.gmail.com>
References: <1263505677.2074.2.camel@yio.site>
	<20100115065638.005ac690@infradead.org>
	<20100115180341.GA12146@kroah.com>
	<20100117065803.6e5e089e@infradead.org>
	<ac3eb2511001200953g3fc2be3ay30174b0429707c93@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jan 2010 18:53:49 +0100
Kay Sievers <kay.sievers@vrfy.org> wrote:

> On Sun, Jan 17, 2010 at 15:58, Arjan van de Ven <arjan@infradead.org>
> wrote:
> > On Fri, 15 Jan 2010 10:03:41 -0800
> > Greg KH <greg@kroah.com> wrote:
> >> > removing experimental is fine... but setting it by default is a
> >> > bit over the top and very inconsistent with how the 'default'
> >> > option is used.
> >>
> >> Why?
> >
> > because the convention is that we use "default y" only for those
> > things that used to be on, and are now turned into a config option.
> 
> Oh, I never heard of such a convention. Sure, we can remove that "y",
> if this is the way it should be used, not be used.

For example in (this is just the first one google found, there's been a
bunch of discussion at various times)

http://article.gmane.org/gmane.linux.kernel/706458

Linus was rather explicit:

The rule of thumb should be:

	NO NEW FEATURES SHOULD _EVER_ DEFAULT TO 'ON'!


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
