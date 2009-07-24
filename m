Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017AbZGXTWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbZGXTWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 15:22:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbZGXTWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 15:22:12 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:39122 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbZGXTWL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 15:22:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TLo8KgAdfFhBgOoUuK23k0ooqnRJzINzTy8z/Y0WoyV/M2CLaSnCFDeVpgueinU7Ir
         pLnuZluZdDS1ijPupqsGdQaHrmSmD9ITsQDp3CVai5edl0Bt70YJNPUhqV00zPVeYksX
         r2Pn9+KIJZOQIkJef4NOCD1/Ybhc1Zio0AL5E=
MIME-Version: 1.0
In-Reply-To: <bad58e960907241047o7558a715u6a36535f2496c49d@mail.gmail.com>
References: <20090724124803.ltfbg57ooyoko0gs@my5.dal.ca>
	 <20090724173422.GA10989@suse.de>
	 <bad58e960907241047o7558a715u6a36535f2496c49d@mail.gmail.com>
Date: Fri, 24 Jul 2009 16:22:10 -0300
Message-ID: <bad58e960907241222j5d7ad970tce4860aa7c273c44@mail.gmail.com>
Subject: Fwd: [PATCH] Removed useless retval variables in usb-serial.c
From: Trevor Pace <trevorpace@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forgot to CC the mailing list as well on this one.

Sorry,

Trevor Pace




---------- Forwarded message ----------
From: Trevor Pace <trevorpace@gmail.com>
Date: Fri, Jul 24, 2009 at 2:47 PM
Subject: Re: [PATCH] Removed useless retval variables in usb-serial.c
To: Greg KH <gregkh@suse.de>


Hey Greg,

First off, thanks for the feedback. As you can probably tell I haven't
done much kernel patching before.

Perhaps "useless" wasn't the term I should have used. Those retval
variables seemed to just add more to the code then appears to be
necessary.  You are right though the compiler probably optimized them
right out of the code so I can't imagine a performance increase as a
result of this.

I quite like that idea of having the code fall out the bottom and I
guess I just never really thought about it that way.

Anyway thanks again,

Trevor Pace



On Fri, Jul 24, 2009 at 2:34 PM, Greg KH<gregkh@suse.de> wrote:
> On Fri, Jul 24, 2009 at 12:48:03PM -0300, Trevor Pace wrote:
>> Removed useless return value variables.
>
> Why are they "useless"?
>
> They seem useful to me, especially as it causes the code to fall out of
> the function at the bottom, and not in the middle, which makes
> maintaining the code easier to do over time, right?
>
> And did this actually cause any generated code to be
> faster/smaller/better?
>
> Oh, and you seem to have messed up a bit of whitespace, please always
> run your patches through scripts/checkpatch.pl first.
>
> thanks,
>
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
