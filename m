Return-Path: <linux-kernel-owner+w=401wt.eu-S1757887AbXHVACy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887AbXHVACy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 20:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbXHVACq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 20:02:46 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:9925 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbXHVACp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 20:02:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Z3TEyCcQk2rEOn8BKTqANmSFaOS3jooSGp/0kyJzT4NKpe5LZJbKAFrBv7RXKXbxP9wyGdcn6B7Lw2f7ra1pDVPaE4kmbCoAUPoYxOVvehWrc5rNuj+CvbUajOv66XccjOp9h2xNceuGCaWAHVp38VezFKzEjRfnX4apkjBLFos=
Message-ID: <9a8748490708211702q7ed2649ft978cea8ab07b63fa@mail.gmail.com>
Date: Wed, 22 Aug 2007 02:02:44 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Al Viro" <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] ver_linux is [censored]
Cc: "Alexey Dobriyan" <adobriyan@sw.ru>, sam@ravnborg.org, akpm@osdl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070821231533.GE21089@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070821071938.GA17761@localhost.sw.ru>
	 <9a8748490708210256v31a0ca00oa0d83dc401aeb98f@mail.gmail.com>
	 <20070821231533.GE21089@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/08/07, Al Viro <viro@ftp.linux.org.uk> wrote:
> On Tue, Aug 21, 2007 at 11:56:32AM +0200, Jesper Juhl wrote:
> > On 21/08/07, Alexey Dobriyan <adobriyan@sw.ru> wrote:
> > > Commit 4a645d5ea65baaa5736bcb566673bf4a351b2ad8 broke ver_linux
> > > on etch which glibc has 3-digit version number.
> >
> > Whoops, sorry about that.
> >
> > > Patch replaces awk
> > > wanking with more robust sed wanking.
> > >
> > > Tested on gentoo, etch, centos 4.2.
> > >
> > I tested your patch on Slackware 12.0, Debian 3.1 & Gentoo Base System
> > release 1.12.9 and it works fine on those as well.
>
> How about simply doing
> sh -c 'cat /proc/$$/maps'|sed -n -e '/^.*\/libc-\([^/]*\)\.so$/{s//\1/;p;q}'
> and to hell with parsing ls -l output?
>
Works for me.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
