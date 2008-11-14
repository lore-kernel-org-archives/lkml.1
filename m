Return-Path: <linux-kernel-owner+w=401wt.eu-S1754691AbYKNXn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbYKNXn1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 18:43:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbYKNXnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 18:43:19 -0500
Received: from rv-out-0708.google.com ([209.85.198.240]:15955 "EHLO
	rv-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbYKNXnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 18:43:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Girb+DZ3BCaTEmUDHbew6haGc9hGT4AyJ2TUEiBjYB8IiV0MxrYv+6OblK5QfLibud
         HkWO7J4BHvf78142+25rt5oNeE37ko5zgkKAkBnEbb1XmDLrfswoEmgyoY1qZ8k81D6X
         uzLmXt+8VZaUzbDotottdLEWfzQ9m6uUvpN4k=
Message-ID: <3aaafc130811141543g8d1a3e6y1b8ebc473ac34bf5@mail.gmail.com>
Date: Fri, 14 Nov 2008 18:43:16 -0500
From: "J.R. Mauro" <jrm8005@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: Can you add the staging tree to -next?
Cc: "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081114230637.GA1415@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081112235600.GA27554@kroah.com>
	 <Pine.LNX.4.64.0811140825410.11953@anakin>
	 <20081114173258.GC22980@kroah.com>
	 <3aaafc130811141428ta97f929va8c62cbcdbc731f7@mail.gmail.com>
	 <20081114230637.GA1415@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 6:06 PM, Greg KH <greg@kroah.com> wrote:
> On Fri, Nov 14, 2008 at 05:28:17PM -0500, J.R. Mauro wrote:
>> There also seem to be a lot of build errors that no one hacking on
>> staging has seen before being threshed out by all the randconfig tests
>> done on -next, which will help a lot if we want the staging drivers to
>> actually go anywhere.
>
> In looking at these in some detail, the majority of them are due to api
> changes in other trees, so these changes will have to be done during the
> -rc1 merge window, which shouldn't be that big of an issue.

That's what I'm noticing, but the sooner we know about the issues on
the horizon, the better.

>
> But yes, there are some kconfig dependancies as well, Randy is really
> good at finding them :)  If you want to send me patches to fix these,
> I'd appreciate it.

Yep, I'm working on it :)

>
> thanks,
>
> greg k-h
>
