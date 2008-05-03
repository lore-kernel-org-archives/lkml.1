Return-Path: <linux-kernel-owner+w=401wt.eu-S1760901AbYECJe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760901AbYECJe3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 05:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758635AbYECJeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 05:34:22 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:52318 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758074AbYECJeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 05:34:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=xzLTTu2zWNIwnsFqw10+kWyx0kqE1oddbcLaAuw6NUriXX+FqCF4+VQyCq063QBBLmaAtriOS/x3+7Yzhz5wgKU6aYFGIyzEeJPwWSkn7d/1cIaU0SdvwDTKJaLdced+PQFxmrcmuP+3oXti5oj/HMK4Je+DD91KFvt73aGOZZI=
Message-ID: <ed10ee420805030234o39141933v8c26d7895ed3f9a@mail.gmail.com>
Date: Sat, 3 May 2008 02:34:20 -0700
From: "SL Baur" <steve@xemacs.org>
To: "Roland Kuhn" <rkuhn@e18.physik.tu-muenchen.de>
Subject: Re: cross-compiling on OS X, make menuconfig fails
Cc: "Sam Ravnborg" <sam@ravnborg.org>, "Al Viro" <viro@zeniv.linux.org.uk>,
       "Timur Tabi" <timur@freescale.com>,
       "Tony Breeds" <tony@bakeyournoodle.com>, linux-kernel@vger.kernel.org
In-Reply-To: <5460B94D-5B3B-4174-9432-C45521A9C247@e18.physik.tu-muenchen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <481529B6.6030802@freescale.com>
	 <20080428015151.GW20457@bakeyournoodle.com>
	 <481739BF.8010305@freescale.com>
	 <20080429164535.GB18018@uranus.ravnborg.org>
	 <20080429172057.GN5882@ZenIV.linux.org.uk>
	 <20080429180601.GA19652@uranus.ravnborg.org>
	 <ed10ee420805022355j4e783fa1qce38d37ab8c4841f@mail.gmail.com>
	 <5460B94D-5B3B-4174-9432-C45521A9C247@e18.physik.tu-muenchen.de>
X-Google-Sender-Auth: fcdcd1a3a1d2739b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/3/08, Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de> wrote:
> Hi Steve!
>
>
>  On 3 May 2008, at 08:55, SL Baur wrote:

> > $ uname -v
> > Darwin Kernel Version 8.11.1: Wed Oct 10 18:23:28 PDT 2007;
> > root:xnu792.25.20~1/RELEASE_I386
> >
> >
>  Yes, they changed that between Tiger and Leopard, where I have
>
>  ---
>  $ uname -v
>  Darwin Kernel Version 9.2.2: Tue Mar  4 21:17:34 PST 2008;
> root:xnu-1228.4.31~1/RELEASE_I386
>  $ /bin/bash -c 'echo -e "buh\n"'
>  buh
>
>  $ /bin/sh -c 'echo -e "buh\n"'
>  -e buh
>
>  $ /bin/echo -e "buh\n"
>  -e buh\n
>  ---
>
>  The second one is POSIX+XSI, the third one plain POSIX. The first one is
> what people are used to ;-)

Check.

$ /bin/bash -c 'echo -e "buh\n"'
buh

$ /bin/sh -c 'echo -e "buh\n"'
buh

$ /bin/echo -e "buh\n"
-e buh\n

Of all the things to "standardize" on, why something like bash
which has no standards?  pdksh, ash, dash or POSIX mode zsh,
would have been better...

-sb
