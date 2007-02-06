Return-Path: <linux-kernel-owner+w=401wt.eu-S1030225AbXBFW4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030225AbXBFW4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 17:56:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030234AbXBFW4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 17:56:25 -0500
Received: from main.gmane.org ([80.91.229.2]:46910 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030225AbXBFW4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 17:56:24 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Oleg Verych <olecom@flower.upol.cz>
Subject: Re: [PATCH]: warrning fix: unsigned->signed
Date: Tue, 6 Feb 2007 22:55:27 +0000 (UTC)
Organization: Palacky University in Olomouc, experimental physics department.
Message-ID: <slrnesi2c0.90j.olecom@flower.upol.cz>
References: <5157576d0702061339w28adbf5fp2dbc5e86661d894@mail.gmail.com> <20070206140936.24bbaded.akpm@linux-foundation.org>
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: flower.upol.cz
Mail-Followup-To: LKML <linux-kernel@vger.kernel.org>, Oleg Verych <olecom@flower.upol.cz>, Andrew Morton <akpm@linux-foundation.org>, "Tomasz Kvarsin" <kvarsin@gmail.com>, viro@zeniv.linux.org.uk, axboe@kernel.dk
User-Agent: slrn/0.9.8.1pl1 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Andrew Morton
> Newsgroups: gmane.linux.kernel
> Subject: Re: [PATCH]: warrning fix: unsigned->signed
> Date: Tue, 6 Feb 2007 14:09:36 -0800
  Mail-Followup-To: LKML <linux-kernel@vger.kernel.org>, Oleg Verych <olecom@flower.upol.cz>, Andrew Morton <akpm@linux-foundation.org>, "Tomasz Kvarsin" <kvarsin@gmail.com>, viro@zeniv.linux.org.uk, axboe@kernel.dk

> On Wed, 7 Feb 2007 00:39:45 +0300
> "Tomasz Kvarsin" <kvarsin@gmail.com> wrote:
>
>> While compiling my code, I always get bunch of warrning from headers,
>> here is fix for them:
>> __getblk is alawys called with unsigned argument,
>> but it takes signed, the same story with __bread,__breadahead and so on.
>
> The patch seems OK, but I'm curious to know why you're seeing this warning
> and nobody else is.  Are you using a compiler other than gcc?  If gcc,
> which version?  Did you add any new compiler options?

Andrew, i think it's due to 

,-*- quote -*-
| Friends don't let friends use "-W". [0]
`-*-

I get many of them, when compiling external modules with `-Wall', of
course ;)

[0] Message-Id: Pine.LNX.4.64.0611281459331.4244@woody.osdl.org
    Archived-At: <http://permalink.gmane.org/gmane.linux.kernel/470736>

____

