Return-Path: <linux-kernel-owner+w=401wt.eu-S1758933AbZFYIOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933AbZFYIOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 04:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751622AbZFYIOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 04:14:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60082 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750753AbZFYIOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 04:14:05 -0400
Date: Thu, 25 Jun 2009 09:15:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
       Brian Swetland <swetland@google.com>,
       Arve =?ISO-8859-14?B?SGr4bm5lduVn?= <arve@android.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org,
       hackbod@android.com, Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH 1/6] staging: android: binder: Remove some funny &&
 usage
Message-ID: <20090625091519.23bc42ff@lxorguk.ukuu.org.uk>
In-Reply-To: <1245889219.32124.280.camel@desktop>
References: <1244832678-30329-1-git-send-email-dwalker@fifo99.com>
	<1245254936.5982.261.camel@desktop>
	<4A391A54.7000109@goop.org>
	<d6200be20906171426n71979124i4b359b6f4fc35d7e@mail.gmail.com>
	<1245274308.5982.268.camel@desktop>
	<a55d774e0906191220i7280fe77qb724037fb92fab86@mail.gmail.com>
	<1245451983.32124.25.camel@desktop>
	<d6200be20906191713n161d4281u1f43804e675e29ac@mail.gmail.com>
	<1245849223.32124.112.camel@desktop>
	<a55d774e0906241514w761f86fva294784583cdd8a4@mail.gmail.com>
	<63386a3d0906241701o720fa667t662b9e3d4f080397@mail.gmail.com>
	<1245889219.32124.280.camel@desktop>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jun 2009 17:20:19 -0700
Daniel Walker <dwalker@fifo99.com> wrote:

> On Thu, 2009-06-25 at 02:01 +0200, Linus Walleij wrote:
> 
> > What I really want to know, is how this relates to the vmsplice() and
> > other zero-copy buffer passing schemes already in the kernel. I was
> > sort of dreaming that D-Bus and other IPC could be accelerated on
> > top of that.
> 
> Marcel had mentioned earlier in this thread that D-Bus could be
> accelerated with shared memory or moving the dbus-daemon into the
> kernel. splice() and vmplice() seem like fairly robust system calls. I
> would think they could be used also ..

Except for very large amounts of data what makes you think zero copy
buffer passing will be fast ? TLB shootdowns are expensive and they scale
horribly badly with threaded apps on multiprocessor systems ?
