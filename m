Return-Path: <linux-kernel-owner+w=401wt.eu-S1752538AbXFNOoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538AbXFNOoz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 10:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751429AbXFNOor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 10:44:47 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:44977 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbXFNOoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 10:44:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=F5RFxQ67bo/3IxNqWQ0n3XPH7P4jouw3ntTKHXk7tbOgEmdcSwFmnCRad5jw+7UfEnZ/hKv/oLzg/kqd/NyuhtbdIvL4YhBbcMxJ6TCjPdXNXBOpeSsIkL57N5BgYnyVNbudpgQYqqXRjX0tl9221lk5f/QTuCc/pdEzLSD0Ay4=
Message-ID: <d120d5000706140744w13f3ed50xc923f11bda7cb8e6@mail.gmail.com>
Date: Thu, 14 Jun 2007 10:44:45 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH -mm 4/7] PM: Remove suspend and resume support from struct device_type
Cc: "Kay Sievers" <kay.sievers@vrfy.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alan Stern" <stern@rowland.harvard.edu>, "Greg KH" <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>, "Pavel Machek" <pavel@ucw.cz>
In-Reply-To: <200706140719.28829.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706131551.51336.rjw@sisk.pl>
	 <3ae72650706131520m3091d04et31b1db64be692385@mail.gmail.com>
	 <200706140010.03438.dtor@insightbb.com>
	 <200706140719.28829.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/14/07, David Brownell <david-b@pacbell.net> wrote:
> On Wednesday 13 June 2007, Dmitry Torokhov wrote:
> > On Wednesday 13 June 2007 18:20, Kay Sievers wrote:
> > > Dmitry, you added this recently, is this used in any code you plan to
> > > merge soon?
> > >
> >
> > Yes, I will need it to implement input device resume (mainly to restore LED
> > state and repeat rate for keyboards).
>
> Why wouldn't that use the class device suspend/resume mechanism?
>

Because they are not class devices anymore.

-- 
Dmitry
