Return-Path: <linux-kernel-owner+w=401wt.eu-S933439AbXCJO12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933439AbXCJO12 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 09:27:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933460AbXCJO11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 09:27:27 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:20015 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933439AbXCJO11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 09:27:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=SJoUvqnVza1EOiDEkvNNQEuuIels+ykbrFqsCHU3q+DH+nbl/pJ1X7HsX605MI0MqaZEFeTyOZwpieE3QHVKEXj1Wp8hyKCxLiwYTJ15HxfKc/eLzXOP8DW7rCdEG45VjWc7NDvrd6X/0tQQJEr4c41uwqqc4ROBAJL9qlU1NVk=
Message-ID: <3ae72650703100627l66be6787kd1488fba65930ea7@mail.gmail.com>
Date: Sat, 10 Mar 2007 15:27:24 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [PATCH] Use attribute groups in struct device_type
Cc: "Dmitry Torokhov" <dtor@insightbb.com>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20070310072210.GA21776@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703100137.35203.dtor@insightbb.com>
	 <20070310065443.GA20302@suse.de> <20070310065556.GB20302@suse.de>
	 <200703100212.05770.dtor@insightbb.com>
	 <20070310072210.GA21776@suse.de>
X-Google-Sender-Auth: 664d0f781c191d79
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/10/07, Greg KH <gregkh@suse.de> wrote:
> On Sat, Mar 10, 2007 at 02:12:04AM -0500, Dmitry Torokhov wrote:
> > On Saturday 10 March 2007 01:55, Greg KH wrote:
> > > On Fri, Mar 09, 2007 at 10:54:43PM -0800, Greg KH wrote:
> > > > On Sat, Mar 10, 2007 at 01:37:34AM -0500, Dmitry Torokhov wrote:
> > > > > Greg,
> > > > >
> > > > > Please consider applying the patch below. It switches struct device_type
> > > > > to using attribute groups which os more flexible. I am using it in my
> > > > > input class_device -> device conversion (which is 99% done btw).
> > > >
> > > > Argh, I never sent you my version of that, did I?  Very sorry about
> > > > that, I was working on fixing up the device namespace issue first, which
> > > > isn't done yet :(
> > > >
> > > > Anyway, my patch that did that is below, feel free to use it or not if
> > > > you want.
> > > >
> > > > > I looked through -mm and the latest git and there does not seem to be
> > > > > any users of struct device_type yet...
> > > >
> > > > Yes, the input patch below uses it and I have a block-device patch from
> > > > Kay in my tree that Andrew doesn't pull from (as it's usually really
> > > > messed up and I know to hide this kind of breakage from him...)
> > >
> > > Oops, that patch didn't use it, this follow-on patch from Kay uses them.
> >
> > Ok, so input portion in your tree does not use type->attrs so we don't
> > have a conflict here. Unless my patch messes up Kay's blockdev patch
> > badly I'd like you to accept it. Input uses 3 attribute groups and I
> > don't want to open-code their creation/removal.
>
> I'll take your patch and see if it messes up Kay's.  If it does, I'm
> sure he will fix it up for me later :)

Sure, no problem. I like Dmitry's change.

Kay
