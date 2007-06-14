Return-Path: <linux-kernel-owner+w=401wt.eu-S1752126AbXFNM7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbXFNM7a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 08:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbXFNM7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 08:59:22 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:43673 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbXFNM7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 08:59:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uCHK6aZjcWnQqVEl+IkGykoDyJAQ7JJT3zoQO98yrbC2Qckmagb/LhBmZoTifaq1/IuY1qpQX2YLccAK3nR8GCiU4uQZ6tchmNN7B2P7qdsLOxby/SJXHmuTAW2jgotS6PL3NzXsPeAE6vlwQ3qzbsCGA53MCU6l9JKsoigfeeU=
Message-ID: <d120d5000706140559h10461e50q2f30ff423468676e@mail.gmail.com>
Date: Thu, 14 Jun 2007 08:59:20 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH -mm 4/7] PM: Remove suspend and resume support from struct device_type
Cc: "Kay Sievers" <kay.sievers@vrfy.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       "David Brownell" <david-b@pacbell.net>, "Greg KH" <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>, "Pavel Machek" <pavel@ucw.cz>
In-Reply-To: <200706141437.16267.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706131551.51336.rjw@sisk.pl>
	 <3ae72650706131520m3091d04et31b1db64be692385@mail.gmail.com>
	 <200706140010.03438.dtor@insightbb.com>
	 <200706141437.16267.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/14/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday, 14 June 2007 06:10, Dmitry Torokhov wrote:
> > On Wednesday 13 June 2007 18:20, Kay Sievers wrote:
> > > Dmitry, you added this recently, is this used in any code you plan to
> > > merge soon?
> > >
> >
> > Yes, I will need it to implement input device resume (mainly to restore LED
> > state and repeat rate for keyboards).
>
> Would that be a big problem to reintroduce it along with the user?
>

Yes because that part is in Greg's domain so I am trying to set
infrastructure up before I can commit my patches into my tree so that
Andrew can safely pull from me into -mm. Greg normally adds such stuff
during merge window so that means if we remove it now we'd need ~2
releases to get it and the user back in.

-- 
Dmitry
