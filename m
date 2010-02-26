Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933102Ab0BZJ6m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 04:58:42 -0500
Received: from mail-iw0-f182.google.com ([209.85.223.182]:37263 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932641Ab0BZJ6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 04:58:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=TJwfGkvDvMkPKTPUcKiyfrgyrcArmiOvi41ZH0tVLruCotdfogBGyvtIHQClGoiz5f
         0V1/O2W2cu+FsHLQHYDhWeVRDYl274Kw+RDNmDGUGpcRrhv2D3GsDeD6AR/Fs+Gsf4A/
         915OU8DBprJ6rtmFvbOAlUZOkX100qRnc2dsA=
MIME-Version: 1.0
In-Reply-To: <a8e1da1002260155l5e75a473oca5649ab33cce124@mail.gmail.com>
References: <20100225155359.GA2722@darkstar> <20100225185515.GB3305@core2>
	 <a8e1da1002251714l55ccbd44ibc1119770667c62b@mail.gmail.com>
	 <b6fcc0a1002252315k1fd5360ehf5ea33566c19515d@mail.gmail.com>
	 <a8e1da1002252333g6e8bf94crba465c59c0cbc07a@mail.gmail.com>
	 <1267170179.12041.4.camel@Joe-Laptop.home>
	 <a8e1da1002260155l5e75a473oca5649ab33cce124@mail.gmail.com>
Date: Fri, 26 Feb 2010 11:58:40 +0200
Message-ID: <b6fcc0a1002260158k59117d7cib3ed7fc72afff86d@mail.gmail.com>
Subject: Re: [PATCH 03/07] kernel.h string cleanup
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 11:55 AM, Dave Young <hidave.darkstar@gmail.com> wrote:
> It will be more clean to put externs/declarations to their own header files.
> At the same time compiling time benifits as well.
>
> printk/panic/string/trace header are splited then included by kernel.h so
> just hexdump/int_sqrt are actually seperated.
>
> fresh boot

You mean cold-cache compile so results are basically random?

> and same .config, make without -j, test result as following:
>
> with the patches applied:
>
> time:
> real 15m16.504s
> user 12m51.866s
> sys 1m39.700s
>
> vmlinux .text size: 003bfcd2
>
> without the patches applied*
> time:
> real 15m20.518s
> user 12m54.120s
> sys 1m40.190s

Not scientific at all.
