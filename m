Return-Path: <linux-kernel-owner+w=401wt.eu-S1762165AbYDSUyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762165AbYDSUyY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 16:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963AbYDSUyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 16:54:17 -0400
Received: from rv-out-0708.google.com ([209.85.198.250]:32934 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755817AbYDSUyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 16:54:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fKaLOghm/553duYgrZZkk5CD0wP+1p/zlG3j3ur1JrIlHBbh05qL9vcqVuIj/7kp3t9laGqxK9NvGQXJtofrTDpp/cQrSrMNnMcDdAddFy+QyB1dNzUZXi9FbH4dfPmF9pvI8HoynEEJEjIAw42UAQpiN2gTZ+dpD8/EaRNBuM0=
Message-ID: <86802c440804191354q45fdedelce0ec38ba52f3880@mail.gmail.com>
Date: Sat, 19 Apr 2008 13:54:14 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: x86: memtest bootparam
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Yinghai Lu" <yhlu.kernel.send@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080419133333.GC23873@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804181717.m3IHHicT031344@hera.kernel.org>
	 <20080418145202.c96460a2.akpm@linux-foundation.org>
	 <20080419133333.GC23873@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 19, 2008 at 6:33 AM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>
>  > Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:
>  >
>  > > Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=c64df70793a9c344874eb4af19f85e0662d2d3ee
>  > > Commit:     c64df70793a9c344874eb4af19f85e0662d2d3ee
>  > > Parent:     9b967106da0357ef8b08847dce35584a04134f20
>  > > Author:     Yinghai Lu <yhlu.kernel.send@gmail.com>
>  > > AuthorDate: Fri Mar 21 18:56:19 2008 -0700
>  > > Committer:  Ingo Molnar <mingo@elte.hu>
>  > > CommitDate: Thu Apr 17 17:41:21 2008 +0200
>  > >
>  > >     x86: memtest bootparam
>  > >
>  > > ...
>  > >
>  > >
>  > > +   memtest=        [KNL,X86_64] Enable memtest
>  > > +                   Format: <integer>
>  > > +                   range: 0,4 : pattern number
>  > > +                   default : 0 <disable>
>  >
>  > OK.  Did the new memtest feature get documented anywhere, btw?  I'm only
>  > vaguely aware of its existence.
>
>  Actually it would be nice if memtest was global, not x86-specific,
>  feature.
>
>  I had some fun with arm running with 256mb, when only 128mb was
>  present. It booted succesfully...

depends if you have find_e820_area_size in you platform. that need
reserve_early...

maybe we need to make reserve_early generic at first.

YH
