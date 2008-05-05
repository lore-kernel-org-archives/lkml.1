Return-Path: <linux-kernel-owner+w=401wt.eu-S1757385AbYEEDvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385AbYEEDvO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 23:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758166AbYEEDrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 23:47:31 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:62342 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758318AbYEEDr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 23:47:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OMZ+Bvp6w3vmDC/dKu0B5m7dbm/kXxItD9F/KgIYPTOQqtvbbg1fB+AIHfh1C1VrDDGsqLc38POEOI81Hix3/O3Ad5tAuy5Pv9d96d5XQ8+X6mYcaL+p0HxUA1rJeuUSqHKSf+XW6i3nU23uN5n6BmfxZEI8ssoJFRKC0TLkY6M=
Message-ID: <dd18b0c30805042047h79f1e025s51037d05e09e7fdb@mail.gmail.com>
Date: Mon, 5 May 2008 03:47:27 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Nick Piggin" <npiggin@suse.de>
Subject: Re: nopage mm.h
Cc: "Jiri Slaby" <jirislaby@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080505032843.GA14947@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30805031629x5f570b97q43f110b228054a28@mail.gmail.com>
	 <481D68E0.1040608@gmail.com>
	 <dd18b0c30805040912l2d12115bi3987d8a5ed0372bf@mail.gmail.com>
	 <20080505032843.GA14947@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 5, 2008 at 3:28 AM, Nick Piggin <npiggin@suse.de> wrote:
> On Sun, May 04, 2008 at 04:12:49PM +0000, Justin Mattock wrote:
>  > On Sun, May 4, 2008 at 7:42 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
>  > > Justin Mattock napsal(a):
>  > >
>  > > > Hello; I have a question about the nopage function that was removed in
>  > > > the kernel.
>  > > > What would be the best way for me to build a module that has a nopage
>  > > > funtion in it?
>  > > >
>  > >
>  > >  use .fault instead
>  > >
>  > Hello thanks for the response, I'll have a look into that. The problem
>  > I'm confronted with right now is the module is not going to
>  > install due to it being a non-GPL module. After doing some reading I
>  > was unawre that the kernel was going GPL-only in 2008, so with that in
>  > mind I need to comply with the regulations. So the question I have now
>  > is: Is there a module that is GPL approved that will give me 3D for
>  > the macbook pro. And also recover from suspend?
>
>  Hopefully the driver vendor should provide an update soon. Otherwise,
>  possibly you could patch back in the .nopage stuff? (It is just a
>  single commit which does nothing but remove nopage, try reverting it).
>
>
>

Hello; thanks for the info, I did revert the nopage back into the
kernel, but after all of that, I'm confronted with
the module not being a GPL-only module  `init_pid_ns'.
I've looked in kernel/pid.c and am noticing  EXPORT_SYMBOL_GPL(init_pid_ns);
With that in mind I'm more concerned about the module not being
GPL-only, is this in full enforcement, or just a thaught
that irritated a bunch of people.
regards;



-- 
Justin P. Mattock
