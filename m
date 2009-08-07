Return-Path: <linux-kernel-owner+w=401wt.eu-S1757090AbZHGJ4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757090AbZHGJ4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 05:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755933AbZHGJ4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 05:56:39 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44254 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755894AbZHGJ4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 05:56:38 -0400
Date: Fri, 7 Aug 2009 10:57:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Andi Kleen <andi@firstfloor.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 3/5] tty: handle VT specific compat ioctls in vt driver
Message-ID: <20090807105732.1340a115@lxorguk.ukuu.org.uk>
In-Reply-To: <20090807062356.GA4955@nowhere>
References: <1249564170-18627-1-git-send-email-arnd@arndb.de>
	<1249564170-18627-4-git-send-email-arnd@arndb.de>
	<20090807062356.GA4955@nowhere>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Aug 2009 08:23:58 +0200
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Hi,
> 
> 
> On Thu, Aug 06, 2009 at 03:09:28PM +0200, Arnd Bergmann wrote:
> > The VT specific compat_ioctl handlers are the only ones
> > in common code that require the BKL. Moving them into
> > the vt driver lets us remove the BKL from the other handlers
> > and cleans up the code.
> 
> 
> Why does it require the bkl?

It's always taken the BKL - you have to prove it doesn't need it. Which
btw isn't true - it does need it in various places still.

Alan
