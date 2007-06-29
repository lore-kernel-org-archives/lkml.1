Return-Path: <linux-kernel-owner+w=401wt.eu-S1760358AbXF2JA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760358AbXF2JA2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 05:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754507AbXF2JAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 05:00:21 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:17868 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303AbXF2JAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 05:00:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MAw/fbU5HKlOj8YRg/XYxagPTWri5EBk1+D5AlwnpEdoUav1KorTz2Pd9WeSi66/B2rRJMPh3rBJRfTFxjPn/PjNnH8UvKnVb8KiGz8RKIYGg2HE5ftUqaH2pTvsMgDqYitZ7YM13rf1TSUjE2tJf87nXTJ7sVM6D+wmRQ7eZ8A=
Message-ID: <a8e1da0706290200x156a80ci2365646f67b279e9@mail.gmail.com>
Date: Fri, 29 Jun 2007 09:00:17 +0000
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: i386 boot fail, EIP in __change_page_attr:166
Cc: "Chuck Ebbert" <cebbert@redhat.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <468273FC.5080905@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0706242043w56ed75f0h208ee9646ae7b7d0@mail.gmail.com>
	 <467FF37D.5000304@redhat.com>
	 <a8e1da0706251811k636b7b8dmc21e5bfc26b09e06@mail.gmail.com>
	 <46814D85.5070406@redhat.com>
	 <a8e1da0706261815sc25dd1t6bf0dc809923e859@mail.gmail.com>
	 <468273FC.5080905@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>On 6/27/07, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> dave young wrote:
> > 2007/6/26, Chuck Ebbert <cebbert@redhat.com>:
> >> On 06/25/2007 09:11 PM, dave young wrote:
> >> > Hi,
> >> >
> >> > 2007/6/25, Chuck Ebbert <cebbert@redhat.com>:
> >> >> On 06/24/2007 11:43 PM, dave young wrote:
> >> >> > Hi,
> >> >> > I reconfig my kernel, boot and oops, EIP in
> >> __change_page_attr:166, I
> >> >> > tried 2.6.22-rc4-mm2 and 2.6.22-rc5 , same result.
> >> >> >
> >> >> > Anyone has some clues?
> >> >> >
> >> >> > here is my config file:
> >> >>
> >> >> Where are the oops messages?
> >> > Attached please find the screenshots. sorry for my phone camera
> >> resolution.
> >> > screen1.png : vga=ask select mode 6
> >> > screen2.png : normal 80x25 console
> >>
> >> That's 2.6.22-rc4-mm2 which I don't have.
> >>
> >> netsc520 is doing iounmap() of an area it did
> >> ioremap_nocache() on earlier, because it has now failed to
> >> find a device. Why it went BUG() I have no idea.
> >>
> >
> > Hi, maybe some config option cause this issue, here is my current
> > working-ok config file:
>
> What are the differences from the non-working config?
>
>     J
>
The diffrences is net520c item.
