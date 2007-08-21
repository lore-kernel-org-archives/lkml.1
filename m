Return-Path: <linux-kernel-owner+w=401wt.eu-S1757932AbXHUXPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932AbXHUXPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 19:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755075AbXHUXPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 19:15:41 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48234 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967AbXHUXPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 19:15:40 -0400
Date: Wed, 22 Aug 2007 00:15:33 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Alexey Dobriyan <adobriyan@sw.ru>, sam@ravnborg.org, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ver_linux is [censored]
Message-ID: <20070821231533.GE21089@ftp.linux.org.uk>
References: <20070821071938.GA17761@localhost.sw.ru> <9a8748490708210256v31a0ca00oa0d83dc401aeb98f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a8748490708210256v31a0ca00oa0d83dc401aeb98f@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 11:56:32AM +0200, Jesper Juhl wrote:
> On 21/08/07, Alexey Dobriyan <adobriyan@sw.ru> wrote:
> > Commit 4a645d5ea65baaa5736bcb566673bf4a351b2ad8 broke ver_linux
> > on etch which glibc has 3-digit version number.
> 
> Whoops, sorry about that.
> 
> > Patch replaces awk
> > wanking with more robust sed wanking.
> >
> > Tested on gentoo, etch, centos 4.2.
> >
> I tested your patch on Slackware 12.0, Debian 3.1 & Gentoo Base System
> release 1.12.9 and it works fine on those as well.

How about simply doing
sh -c 'cat /proc/$$/maps'|sed -n -e '/^.*\/libc-\([^/]*\)\.so$/{s//\1/;p;q}'
and to hell with parsing ls -l output?
