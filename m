Return-Path: <linux-kernel-owner+w=401wt.eu-S1760563AbXE2Qot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760563AbXE2Qot (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 12:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757647AbXE2Qok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 12:44:40 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:36930 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbXE2Qoj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 12:44:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YP5sV0CWoHmjmnkz7N14G388/DzZeBsem+/dyiGryqxqDZN72/aJFsye3LxOaB3NzH5tAlsqG3/sR3kfNyPc6Ts3lMLcTbtqxO1qdD+PhR2rhtMn+609ubAX1NkQVeQwmHBi/JdT0cOnYjuJOCgCG9nRQj+Yi+EdJEGkP8Li38g=
Message-ID: <de6d2b4f0705290944i69ca8f2dudda10775ebc41c07@mail.gmail.com>
Date: Tue, 29 May 2007 17:44:37 +0100
From: "M Macnair" <mmacnair@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: Seeding /dev/random not working
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <p73zm3nefcc.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
References: <de6d2b4f0705290453kec2b050pb4d0bebc256b87a5@mail.gmail.com>
	 <p73zm3nefcc.fsf@bingen.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 May 2007 18:58:59 +0200, Andi Kleen <andi@firstfloor.org> wrote:
> "M Macnair" <mmacnair@gmail.com> writes:
> >
> > Many distros ship with an init script that saves and restores the
> > entropy pool on startup and shutdown.  The bit that interests me that
> > is called on startup is (my comments):
> >       if [ -f $random_seed ]; then
> >               cat $random_seed >/dev/urandom  # should seed the pool
> OA
> Writing doesn't actually work; to get real accounted entropy for /dev/random
> you need to use a special ioctl. I ran into this problem some years ago
> and ended up writing http://www.muc.de/~ak/rndfeed.c
>
> -Andi

If this doesn't work, then it seems to me as though all the
debian-esque distros that use equivalents of the above script are
wasting their time, and the man page recommending that technique (man
4 random) is also wrong.  Is that interpretation correct?

Mike
