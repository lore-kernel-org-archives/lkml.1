Return-Path: <linux-kernel-owner+w=401wt.eu-S1753025AbXDMCeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025AbXDMCeK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 22:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753029AbXDMCeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 22:34:09 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:64679 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbXDMCeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 22:34:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BqxrB454Nl3lFQIgKl2sBWxB6eCzqHBqX7XqUZXsqnCIDSDBOTgDF3RI28VDvLk1SIM5tu8RMesk4j0Cc9GJmiiPDbdVWxI86r4M1Lm+6xP6Q7s6pfF9Zuh7SGBn17cAMm7WXXv8B5zlDYret6OKAY4BhNwKhVVYhixO2RkYuVQ=
Message-ID: <41840b750704121934g2771cc0er308eb4f9c8a1cb80@mail.gmail.com>
Date: Thu, 12 Apr 2007 22:34:06 -0400
From: "Shem Multinymous" <multinymous@gmail.com>
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Subject: Re: [Kernel-discuss] Re: [PATCH 3/7] [RFC] Battery monitoring class
Cc: "Anton Vorontsov" <cbou@mail.ru>, "Paul Sokolovsky" <pmiscml@gmail.com>,
       "Matthew Garrett" <mjg59@srcf.ucam.org>, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org
In-Reply-To: <20070413005112.GA20890@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070411232503.GC20095@zarina>
	 <20070412130817.GA29900@srcf.ucam.org> <20070412141505.GA25552@zarina>
	 <20070412142430.GA31240@srcf.ucam.org>
	 <1734853889.20070412173626@gmail.com>
	 <20070412185630.GC27804@khazad-dum.debian.net>
	 <20070412204413.GA3151@zarina>
	 <20070413005112.GA20890@khazad-dum.debian.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 4/12/07, Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
> On Fri, 13 Apr 2007, Anton Vorontsov wrote:
> > * Yup, I've read last discussion regarding batteries, and I've seen
> >   objections against "charge" term, quoting Shem Multinymous:
> >
> >   "And, for the reasons I explained earlier, I strongly suggest not using
> >   the term "charge" except when referring to the action of charging.
> >   Hence:
> >   s/charge_rate/rate/;  s/charge/capacity/"
> >
> >   But lets think about it once again? We'll make things much cleaner
> >   if we'll drop "capacity" at all.
>
> I stand with Shem on this one.  The people behind the SBS specification
> seems to agree... that specification is aimed at *engineers* and still
> avoids the obvious trap of using "charge" due to its high potential for
> confusion.
>
> I don't even want to know how much of a mess the people writing applets
> woudl make of it...

With fixed-units files, having *_energy and *_capacity isn't too clear
either... Nor is it consistent with SBS, since SBS uses "capacity" to
refer to either energy or charge, depending on a units attribute.

As a compromise, how about using "energy" and "charge" for quantities,
and "charging" (i.e., a verb) when referring to the operation?

BTW,  tp_smapi uses "charge" and "charging" interchangeably; that was
a  mistake.

  Shem
