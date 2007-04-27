Return-Path: <linux-kernel-owner+w=401wt.eu-S1755604AbXD0LFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbXD0LFx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 07:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755605AbXD0LFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 07:05:53 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:63388 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755604AbXD0LFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 07:05:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qHLN6n0ARlJ4jsHM6uTe6qkgXlOygsHob+bpn/I/M/krgz+KhIy3w+pKPguzY9tJe7JbqfdZrgehcLZyXnD4g20j4yFLDDuqVhbXFaX7vHWvJBviMUgHsLQOkb7M/YLV9zt9tIkdO2tUrggTv8ua0BoEY1gngqN06QDBqwueYVQ=
Message-ID: <9a8748490704270405w1b02119dic0422a0ce661357c@mail.gmail.com>
Date: Fri, 27 Apr 2007 13:05:50 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: bryan.wu@analog.com
Subject: Re: [patch 00/33] 2.6.20-stable review
Cc: "Greg KH" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org, "Justin Forbes" <jmforbes@linuxtx.org>,
       "Zwane Mwaikambo" <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Dave Jones" <davej@redhat.com>,
       "Chuck Wolber" <chuckw@quantumlinux.com>,
       "Chris Wedgwood" <reviews@ml.cw.f00f.org>,
       "Michael Krufky" <mkrufky@linuxtv.org>,
       "Chuck Ebbert" <cebbert@redhat.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
In-Reply-To: <1177668954.5969.18.camel@roc-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070426165445.GA1898@kroah.com>
	 <1177668954.5969.18.camel@roc-desktop>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/04/07, Wu, Bryan <bryan.wu@analog.com> wrote:
> On Thu, 2007-04-26 at 09:54 -0700, Greg KH wrote:
> > This is the start of the stable review cycle for the 2.6.20.10 release.
> > There are 33 patches in this series, all will be posted as a response to
> > this one.  If anyone has any issues with these being applied, please let
> > us know.  If anyone is a maintainer of the proper subsystem, and wants
> > to add a Signed-off-by: line to the patch, please respond with it.
> >
> > These patches are sent out with a number of different people on the Cc:
> > line.  If you wish to be a reviewer, please email stable@kernel.org to
> > add your name to the list.  If you want to be off the reviewer list,
> > also email us.
>
> Hi Greg:
>
> I am just wondering that is there any rule for stable kernel version
> release?
>
> AFAIK, 2.6.x kernels are all stable release and 2.6.x.y is for stable
> tree bug fixing and long term supporting. But I found 2.6.16.y got 49
> version updating, it is more active than other stable release such as
> 2.6.17 and 2.6.19. It looks like 2.6.16 is a long-long term supporting
> version and even number 2.6.x kernel is more active than odd number
> 2.6.x kernel.
>
> You know for some customer's product, they want to use the stable and
> long term support kernel instead to use the latest one.
>
> Could you please give us some idea about this regular?
>

2.6.16.y is special in that Adrian Bunk took it upon himself to
maintain that branch more or less indefinately. But that's not how
-stable normally works, it's Adrians own project.

The normal way -stable works is that it tracks the latest 2.6.x kernel
that has been released.
Now that 2.6.21 has been released, a final flush of the patch queue
against 2.6.20 is done, that will be 2.6.20.10, and then -stable will
switch to 2.6.21.y, when 2.6.22 comes out a final 2.6.21.y is made and
then it's off to track 2.6.22

The rules for what is suitable for a -stable release etc is written in
Documentation/stable_kernel_rules.txt

I believe the above reflects reality - if I've said something wrong I
assume Greg will correct me :)

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
