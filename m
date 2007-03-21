Return-Path: <linux-kernel-owner+w=401wt.eu-S933916AbXCUUBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933916AbXCUUBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 16:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933821AbXCUUBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 16:01:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:29897 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933916AbXCUUBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 16:01:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OhjgnQp3mH632z5D3p+G6qnfJlANW8vwLbzu6nKA6JpsqXq6QK6pEnrCHGFv0cYtHgR9iu9lTc//ZLc6WRcpPvWk4RE1bVzIg4uA7XCep6u2OaG1y1gnO56mzHsuzN/3isS1cp9oiFlRxYBapaO0aaBTCaShvpZSjABBvsgqcEQ=
Message-ID: <d12bb7ab0703211301n22a3e6eeh8cad4ed447d493d3@mail.gmail.com>
Date: Wed, 21 Mar 2007 21:01:34 +0100
From: "Victor Fernandes" <victor.dias.fernandes@gmail.com>
To: "Dmitry Torokhov" <dtor@insightbb.com>
Subject: Re: New kernel mouse recognition problem
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <d12bb7ab0703201053q7860c42fl9d78a8985a2a414b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <63140.87.244.133.121.1174080814.squirrel@postino>
	 <39605.87.244.133.121.1174151177.squirrel@postino>
	 <200703191259.31104.dtor@insightbb.com>
	 <d12bb7ab0703201053q7860c42fl9d78a8985a2a414b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oh yes it helps, it works nicely, on X and on the console with gpm.

Most probably psmouse is built-in on the kernel because I have no
module with that name and if I check on the, what I suppose was the
build .config kernel file, I can see the following:

CONFIG_INPUT_MOUSE=y
 CONFIG_MOUSE_PS2=y

 Do you want me to check something else?

Don't bother to Cc me directly anymore, I have subscribe to the
mailing list with another e-mail address to avoid problems. Some
domain migration issues, sorry for the inconveniency. Regards,

Victor Fernandes

On 3/19/07, Dmitry Torokhov <dtor@insightbb.com> wrote:
>  Hi Victor,
>
> On Saturday 17 March 2007 13:06, Victor Fernandes wrote:
> > Dmitry,
> >
> > Thanks for you feedback, sorry for the delay on my reply but because
> > I'm not subscribe to the list, only now I saw your message. I hope you
> > will be able to see that this message is a follow up on the previous ones.
> > If you do not mind can you please Cc directly to me.
> >
>
> I did CC you on my reply but unfortunaltely your mail server did
> not like me. Let's see if this one goes through.
>
> > Now to answer your questions.
> > The mouse do not works properly, I mean with this that I have the mouse
> > pointer on the screen, with gpm and X, but it jumps randomly when used.
> >
>
> Does it help if you boot with "psmouse.proto=exps"? (Is psmouse a built-in
> or a module)?
>
> --
> Dmitry
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
