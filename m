Return-Path: <linux-kernel-owner+w=401wt.eu-S1756095AbZEHXox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095AbZEHXox (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 19:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751227AbZEHXon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 19:44:43 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:48346 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbZEHXom convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 19:44:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=QODlk14JM9G25sPbAdT49XrwfNSGSpLjpmO9hF60rb6SmjjlbUMk1+klKEQ6EzQeLa
         4MZNxgypHG1SHOOdJA6BtedjL9RQeO2lQNsxqgAZA5ZmY1d3kCo/9qqk3f87dt7CiCk5
         RL5X51/b4k0zFQhmgL0CAMR109+Q4NGR1FLU4=
MIME-Version: 1.0
In-Reply-To: <1241825408.19600.384.camel@nigel-laptop>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> 
	<200905081611.41865.rjw@sisk.pl> <1241819569.19600.281.camel@nigel-laptop> 
	<200905090046.21282.rjw@sisk.pl> <1241825408.19600.384.camel@nigel-laptop>
From: Ray Lee <ray-lk@madrabbit.org>
Date: Fri, 8 May 2009 16:44:22 -0700
X-Google-Sender-Auth: 282d201a7423df0f
Message-ID: <2c0942db0905081644l73a7a4f5i8af4677046797df@mail.gmail.com>
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
To: nigel@tuxonice.net
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       linux-pm@lists.linux-foundation.org, tuxonice-devel@lists.tuxonice.net,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 8, 2009 at 4:30 PM, Nigel Cunningham <nigel@tuxonice.net> wrote:
> > First, because it is technically too difficult to have all of the code reviewed
> > and _agreed_ _upon_ by everyone at once.  And if it's not agreed upon, you'll
> > have to modify it and it won't be the same thing any more once you've done
> > that.  Which I'd say is guaranteed, having had a quick look at the code.
>
> I think you're putting unrealistic barriers in the way. Does all code
> that goes into the kernel get "reviewed and agreed upon by everyone at
> once"? No!

Actually, yes. Any code that touches a subsystem has to get signed off
by that subsystem's maintainers. Witness any of the long series of
patches that touch all arches, or change out all drivers from one
method to another. Even Andrew Morton, the guy who's the declared 2.6
kernel maintainer, has to split his patches up by subsystem or
lieutenant and push them forward via them and their trees.

You are being treated no differently than anyone else on here, other
than Linus himself who has the power to merge into his tree at a whim,
but even he does so very reluctantly without a signoff from the
affected subsystem people.

TuxOnIce is in a harder position than most patches, as for it to work
it needs to touch so many subsystems.

Is this annoying? I'm sure. But that's why Rafael is offering to do
the annoying part for you, the part that has never worked in the past
when your patches have been posted for comment and hopeful merging:
He's offering to be the social glue between your code and the forms
that are accepted and followed here on LKML. Taking things apart from
the whole, finding the pieces that are non-controversial or easily
argued for, getting them merged upstream with a user, and then moving
on to the rest.

This way, the external TuxOnIce patch set shrinks and shrinks, until
it's eventually gone, with all functionality merged into the kernel in
one form or another.

Is your code better than uswsusp? Almost certainly. This isn't about
that. This is about making your code better than what it is today, by
going through the existing review-and-merge process.

IBM had to do it with their Device Mapper feature set they tried to
drop into the kernel, and the community said "Whoa" the same way
they're reacting to TuxOnInce (Note: Not you, the code.) IBM went off,
wrote things that intergrated in with the existing codebase, and got
it merged with the signoffs of the subsystems affected. They're a big
corp, and even they had to play by the existing rules.

Everybody does this here, it's the way things work, because the process *works*.

I personally want to see a better hibernation system in the kernel,
and I personally think it's going to be substantially similar to what
you have today. I also personally have no control over what gets
merged, so hopefully you'll read the above with some care and thought.

Please stick at this.
