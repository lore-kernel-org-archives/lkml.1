Return-Path: <linux-kernel-owner+w=401wt.eu-S1753021AbZBQBOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021AbZBQBOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 20:14:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbZBQBOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 20:14:37 -0500
Received: from qb-out-0506.google.com ([72.14.204.228]:44892 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbZBQBOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 20:14:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ia9stVhbSk1OkZzvGqk/8dkmUjK5FWEP8vCRGO8vVW57YWPuLQDqmgbxg+RZHrmI+w
         rQ/RO+XRG+xnj8qN8cKTgQQsaFzc1tnRev18n+W9O9dPon7sfHbD+9VZuuPN3oLJiLjs
         XIVJMl/T6vwRxRsCXA6TOAcDm+LkzKiBIr4vU=
MIME-Version: 1.0
In-Reply-To: <20090205180856.GA20805@kroah.com>
References: <1233319715-4877-1-git-send-email-tom.leiming@gmail.com>
	 <20090130065224.47729f41@infradead.org>
	 <20090204230851.GF18484@kroah.com>
	 <20090204170858.2d07b546@infradead.org>
	 <20090205180856.GA20805@kroah.com>
Date: Tue, 17 Feb 2009 09:14:34 +0800
Message-ID: <d82e647a0902161714y46ac2785lbd0bd964902289e5@mail.gmail.com>
Subject: Re: [PATCH] driver core: remove polling for driver_probe_done(v3)
From: Ming Lei <tom.leiming@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Arjan van de Ven <arjan@infradead.org>, kay.sievers@vrfy.org,
       cornelia.huck@de.ibm.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Greg
Would you mind queuing this patch into your tree?
Thanks!

2009/2/6 Greg KH <greg@kroah.com>:
> On Wed, Feb 04, 2009 at 05:08:58PM -0800, Arjan van de Ven wrote:
>> On Wed, 4 Feb 2009 15:08:51 -0800
>> Greg KH <greg@kroah.com> wrote:
>>
>> > On Fri, Jan 30, 2009 at 06:52:24AM -0800, Arjan van de Ven wrote:
>> > > On Fri, 30 Jan 2009 20:48:35 +0800
>> > > tom.leiming@gmail.com wrote:
>> > >
>> > > > From: Ming Lei <tom.leiming@gmail.com>
>> > > >
>> > > > This patch adds a function : driver_wait_probe_done,
>> > > > which waits on condition of probing done to replace
>> > > > polling for driver_probe_done in fs initialization.
>> > > >
>> > > > There is no better way to avoid polling for
>> > > > driver_probe_done _and_ existence of the root device,
>> > > > so we does not replace the driver_probe_done with
>> > > > driver_wait_probe_done in such special case.
>> > > >
>> > > > Removing polling in fs initialization may lead to
>> > > > a faster boot.
>> > > >
>> > > > Signed-off-by: Ming Lei <tom.leiming@gmail.com>
>> > >
>> > > ok this one will work fine ;)
>> > >
>> > > Reviewed-by: Arjan van de Ven <arjan@linux.intel.com>
>> > >
>> > > thanks for fixing this up
>> > > (it will clash with the patch that moves this to one place, but the
>> > > same cleanup can be done there)
>> >
>> > What patch is that?  Should i be taking this?  Or are they in some
>> > other tree?
>>
>> it's the suspend-resume regression fixes that either you already have
>> or that raphael sent to you
>
> Hm, ok, I don't see any left in my tree, or queue, so perhaps someone
> might want to resend them to me?
>
> thanks,
>
> greg k-h
>



-- 
Lei Ming
