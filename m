Return-Path: <linux-kernel-owner+w=401wt.eu-S1753147AbZLUOOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbZLUOOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 09:14:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbZLUOOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 09:14:35 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:59528 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbZLUOOe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 09:14:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=PxhpkN3zZByiIM8AuqRpY0W0MeyNwwNp9+JFmwp0yiCz6diNsRT5P0TJ1dzN5GFMgD
         80RDYiFfjeU/n9tBAdNWe62r4HfEkRJKoEj2meqPXpBx85H6sEJo1UWoqM/wuvOAFBmB
         G6YjlUkWafp1IiswcPR+lecnmrYG/KQ+sXqXk=
MIME-Version: 1.0
In-Reply-To: <20090930071555.GA13915@merkur.ravnborg.org>
References: <20090929103353.GA11183@redhat.com> <20090929124347.GA11375@infradead.org> 
	<20090930071555.GA13915@merkur.ravnborg.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 21 Dec 2009 09:14:14 -0500
Message-ID: <8bd0f97a0912210614p37029355yabd4388d4bf02172@mail.gmail.com>
Subject: Re: [PATCHv2 0/4] scsi: export and clean up headers
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       "Michael S. Tsirkin" <mst@redhat.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Boaz Harrosh <bharrosh@panasas.com>,
       Ulrich Drepper <drepper@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 02:15, Sam Ravnborg wrote:
> On Tue, Sep 29, 2009 at 08:43:47AM -0400, Christoph Hellwig wrote:
>> On Tue, Sep 29, 2009 at 12:33:53PM +0200, Michael S. Tsirkin wrote:
>> > This implements a minor cleanup of exported scsi headers,
>> > and adds export of headers that are de-facto used by userspace.
>> > The patches are on top of 2.6.32-rc1.
>> > Can these be queued for 2.6.32?
>> > Thanks.
>>
>> Before we do anything in this area we need to find an agreement who
>> owns /usr/include/scsi/ .  Right now that's glibc, and if we want to
>> change it to the kernel headers we need to find a transition agreement
>> with the glibc maintainer (aka mostly Uli).
>
> The scsi headers are exported. So it does not matter if glibc or any
> other libc for that amtter uses the headers or not.
> Exported headers has some rules to follow and scsi are no exception here.
>
> Now if we get the scsi headers in good shape then and only then we can
> go to glibc people and tell them that we have a better set of scsi headers
> than they have.
>
> Postponing updates to the exported scsi headers just beacause we do not
> have any users of them at the moment is the wrong thing to do.
> We should rather use the opportunity to streamline the exported headers
> so we have a superior set of headers to offer.

can we get these fixes merged ?  i dont see them in 2.6.33-rc1 ...
-mike
