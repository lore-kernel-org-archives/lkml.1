Return-Path: <linux-kernel-owner+w=401wt.eu-S1764836AbXHNQZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764836AbXHNQZA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 12:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762027AbXHNQYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 12:24:51 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:35316 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757039AbXHNQYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 12:24:50 -0400
Date: Tue, 14 Aug 2007 18:24:53 +0200
From: Olaf Hering <olaf@aepfle.de>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
Message-ID: <20070814162453.GA14532@aepfle.de>
References: <1175610345.2665.15.camel@shinybook.infradead.org> <17938.57292.870224.132415@cargo.ozlabs.ibm.com> <20070814114931.GA13319@aepfle.de> <1187092392.3707.74.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1187092392.3707.74.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, David Woodhouse wrote:

> On Tue, 2007-08-14 at 13:49 +0200, Olaf Hering wrote:
> > On Wed, Apr 04, Paul Mackerras wrote:
> > 
> > > David Woodhouse writes:
> > > 
> > > > There are proper device numbers registered for pmac_zilog now. Use them.
> > 
> > Which numbers?
> 
> shinybook /shiny/git/mtd-utils $ ls -l /dev/ttyPZ*
> crw-rw---- 1 root uucp 204, 192 2007-08-13 11:48 /dev/ttyPZ0
> crw-rw---- 1 root uucp 204, 193 2007-08-13 11:48 /dev/ttyPZ1

I dont see 204:192 in devices.txt
