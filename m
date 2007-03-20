Return-Path: <linux-kernel-owner+w=401wt.eu-S933971AbXCTQJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933971AbXCTQJq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 12:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934019AbXCTQJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 12:09:46 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:36800 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933971AbXCTQJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 12:09:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BvynU3QEI4GX8ef4mFORzRMxbvuPyXQNZg2nleKk4myvxkpFn2K6PbKJmqbWML9UJE7Tn2CspzbYgWdFbw4gpeOV8H7L6eejkfi7hx4zUivR/x4a3KF/PHYk7SDL/1Sdd1+xItvCv92Nbo8Z0ZgRDvlYJzTFqrjAp5FBb7P6pU4=
Message-ID: <d120d5000703200909v326ab6benc3fb85badc061018@mail.gmail.com>
Date: Tue, 20 Mar 2007 12:09:42 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: strange keyboard lag after suspend testing
Cc: "Andreas Mohr" <andi@rhlx01.fht-esslingen.de>, vojtech@suse.cz,
       "kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070320160338.GC5533@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070320153332.GA5533@elf.ucw.cz>
	 <20070320160006.GA14843@rhlx01.hs-esslingen.de>
	 <20070320160338.GC5533@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/20/07, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
> > > I was testing suspend in 2.6.21-rc4 a lot, and now... machine feels
> > > like someone added 50..100msec delay somewhere in keyboard
> > > handling. Mouse does not seem affected. /proc/interrupts seem to
> > > increase as they should, for both keyboard and mouse. Can someone
> > > reproduce it? Any ideas how to debug it?
> >
> > Probably just asking the obvious:
> > it's not a trivial "failed to re-configure repeat rate upon resume"
> > (which one could rule out by running "kbdrate" again)
> > but a lag in some interrupt handler or somewhere else deeper, right?
>
> No, it is not keyboard rate. Keyboard lags during normal typing,
> sometimes letters come in groups of two or so...

I might start looking at embedded controller changes and switches. If
ACPI misbehaves that could starve keyboard controller... But you said
that mouse is OK... Hmm, what happens if you load evbug and type while
watching syslog. Do you observe the same delays?

-- 
Dmitry
