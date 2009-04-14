Return-Path: <linux-kernel-owner+w=401wt.eu-S1758188AbZDNRan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188AbZDNRan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 13:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757796AbZDNR2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 13:28:23 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:60088 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757774AbZDNR2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 13:28:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WbIYCofb6DR1LzEArgOkWE3ZUydDD3c/8cmVC7qA+ENvul56qOu1wuZhGAXksxG5Oe
         sodtZ9iBYNuyH91mFCA9MQ0myXG0Qc6/SC9MOaDvyRlGZ5Dn1xeAwebNM0QXUTz3t6jt
         F/6MOmesq8nGme2wlOfIwvTyZ/wlF0iLiKOVU=
Date: Tue, 14 Apr 2009 21:28:33 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Oren Laadan <orenl@cs.columbia.edu>, xemul@parallels.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       hch@infradead.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH 10/30] cr: core stuff
Message-ID: <20090414172833.GA27985@x200.localdomain>
References: <20090410023539.GK27788@x200.localdomain> <49E41D7B.8030003@cs.columbia.edu> <20090414160003.GD27461@x200.localdomain> <1239727190.32604.72.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239727190.32604.72.camel@nimitz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 09:39:50AM -0700, Dave Hansen wrote:
> On Tue, 2009-04-14 at 20:00 +0400, Alexey Dobriyan wrote:
> > > Are you suggesting that conversion of a checkpoint image from an older
> > > version to a newer version be done in the kernel ?
> > 
> > For mainline kernel it's completely unrealistic to support all backwards
> > compatibility code for previous versions. Some mythical userspace
> > program will convert images.
> > 
> > But it's completely realistic and much easier for distro kernel because
> > distro kernel doesn't generally include patches with significant in-kernel
> > internals changes, so they simply can support
> > '2.6.26-1-amd64' => '2.6.26-2-amd64' situation.
> > 
> > Distros can write conversion program too, but I don't expect they will.
> 
> Yeah, I'm with you on this.  If distros ever start to care about c/r
> *that* much, they'll start making this part of their testing process.
> Personally, I think just giving a kernel version is pretty worthless
> these days.  People do tons of stuff to the kernel without bumping it at
> all. 

Well, to some extent this is cop-out.

It allows to easily see (hexdump(1) :-) what kernel dumped image.
And it allows for distro to easily check if it's restart on same version
or from previous version with high degree of confidentness.

Distro kernels have very specific unames if looking for kernels and
kernel updates they officially ship, but yes, this is not 100% reliable.
