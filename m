Return-Path: <linux-kernel-owner+w=401wt.eu-S932414AbXCEOok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414AbXCEOok (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 09:44:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933491AbXCEOok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 09:44:40 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:63567 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414AbXCEOoj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 09:44:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HUck7FvIsC/fBOXP51Jb/F1A5WGaxdXE+OTeMvYWF0MaWOIQ+1BrUfdcMqOqUskRUt0pRfwayfl6xqVs/LiU0H6gD4fX/VA683li9H+Vc+vshuEZ767PVr00SLqhimqJasaOHi+5YhpFBm/i0TZqfseaWn1Vlf5gQL1cfjCL3Bs=
Message-ID: <d120d5000703050644x741564v625f0aa7a58c60ad@mail.gmail.com>
Date: Mon, 5 Mar 2007 09:44:35 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "=?ISO-8859-1?Q?Kristian_Gr=F8nfeldt_S=F8rensen?=" <kriller@vkr.dk>
Subject: Re: PROBLEM: "BUG:" when resuming from suspend-to-ram
Cc: linux-input@atrey.karlin.mff.cuni.cz, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux kernel mailing list" <linux-kernel@vger.kernel.org>
In-Reply-To: <1172781250.5042.1.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1172601905.5428.28.camel@localhost.localdomain>
	 <1172622441.4587.14.camel@localhost.localdomain>
	 <200702281345.15098.rjw@sisk.pl>
	 <200703010036.28166.dtor@insightbb.com>
	 <1172779492.7396.2.camel@localhost.localdomain>
	 <d120d5000703011225t1ffaa33akbfcde29d2954601e@mail.gmail.com>
	 <1172781250.5042.1.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/1/07, Kristian Grønfeldt Sørensen <kriller@vkr.dk> wrote:
> On Thu, 2007-03-01 at 15:25 -0500, Dmitry Torokhov wrote:
> > On 3/1/07, Kristian Grønfeldt Sørensen <kriller@vkr.dk> wrote:
> > >
> > > Hmmm.
> > >
> > > Now i get this BUG:
> > >
> >
> > Does it die the same way if you just unload the button driver without
> > suspending?
> >
>
> No. Tried unloading and loading 30 times after each other. No problems
> at all.
>

I wonder what causes unloading of the ACPI button driver during resume...

-- 
Dmitry
