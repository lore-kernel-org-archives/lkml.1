Return-Path: <linux-kernel-owner+w=401wt.eu-S1756835AbYEEFHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835AbYEEFHS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 01:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752878AbYEEFHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 01:07:05 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:17849 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbYEEFHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 01:07:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MV7EGSSdnI29tGMa/3bEY+J5edLV2zwlW3lOOwz0JS45InTOWAnEA0ivh/2mpw+0EKRHv9m7sX+UVOHnls+Vf/E8cHZAYVoWJohJj/im/2ODU/tWcDnNCFzD+1GMC8fjDrQBUx7k27SiLlim7wPwG0MUJ+a/oRNAUdv9Z4AzRSU=
Message-ID: <dd18b0c30805042207j4df0d78dx1291555889894776@mail.gmail.com>
Date: Mon, 5 May 2008 05:07:00 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Nick Piggin" <npiggin@suse.de>
Subject: Re: nopage mm.h
Cc: "Jiri Slaby" <jirislaby@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080505041954.GB17640@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30805031629x5f570b97q43f110b228054a28@mail.gmail.com>
	 <481D68E0.1040608@gmail.com>
	 <dd18b0c30805040912l2d12115bi3987d8a5ed0372bf@mail.gmail.com>
	 <20080505032843.GA14947@wotan.suse.de>
	 <dd18b0c30805042047h79f1e025s51037d05e09e7fdb@mail.gmail.com>
	 <20080505041954.GB17640@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 5, 2008 at 4:19 AM, Nick Piggin <npiggin@suse.de> wrote:
>
> On Mon, May 05, 2008 at 03:47:27AM +0000, Justin Mattock wrote:
>  > On Mon, May 5, 2008 at 3:28 AM, Nick Piggin <npiggin@suse.de> wrote:
>  > > On Sun, May 04, 2008 at 04:12:49PM +0000, Justin Mattock wrote:
>  > >  > On Sun, May 4, 2008 at 7:42 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
>  > >  > > Justin Mattock napsal(a):
>  > >  > >
>  > >  > > > Hello; I have a question about the nopage function that was removed in
>  > >  > > > the kernel.
>  > >  > > > What would be the best way for me to build a module that has a nopage
>  > >  > > > funtion in it?
>  > >  > > >
>  > >  > >
>  > >  > >  use .fault instead
>  > >  > >
>  > >  > Hello thanks for the response, I'll have a look into that. The problem
>  > >  > I'm confronted with right now is the module is not going to
>  > >  > install due to it being a non-GPL module. After doing some reading I
>  > >  > was unawre that the kernel was going GPL-only in 2008, so with that in
>  > >  > mind I need to comply with the regulations. So the question I have now
>  > >  > is: Is there a module that is GPL approved that will give me 3D for
>  > >  > the macbook pro. And also recover from suspend?
>  > >
>  > >  Hopefully the driver vendor should provide an update soon. Otherwise,
>  > >  possibly you could patch back in the .nopage stuff? (It is just a
>  > >  single commit which does nothing but remove nopage, try reverting it).
>  > >
>  > >
>  > >
>  >
>  > Hello; thanks for the info, I did revert the nopage back into the
>  > kernel, but after all of that, I'm confronted with
>  > the module not being a GPL-only module  `init_pid_ns'.
>  > I've looked in kernel/pid.c and am noticing  EXPORT_SYMBOL_GPL(init_pid_ns);
>  > With that in mind I'm more concerned about the module not being
>  > GPL-only, is this in full enforcement, or just a thaught
>  > that irritated a bunch of people.
>  > regards;
>
>  OK, not sure about that one... but if it is just your personal kernel,
>  and not for redistribution, then you are of course free to make any
>  changes you like. Including changing EXPORT_SYMBOL_GPL. Maybe it is
>  a reasonable temporary measure for you until you get some better
>  drivers.
>
>

Cool; yes this is just for personal use only, not redistribution.
Then in that case I'll have a look into seeing if I can get up and running again
with 2.6.26-rc1.
regards;

-- 
Justin P. Mattock
