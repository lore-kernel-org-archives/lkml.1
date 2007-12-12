Return-Path: <linux-kernel-owner+w=401wt.eu-S1758810AbXLLS5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758810AbXLLS5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 13:57:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbXLLS53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 13:57:29 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:13529 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbXLLS52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 13:57:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IIMVaAxSf4TdhnEXW8Rm0Y8qssYK1hbHbbH2x2YPuT0/r/hLBLwix8/+Ad24sefpvlENhI1n1LCizhW4QDgRZMoVPmS/KGwF6DDCIpSuIP+BIQIytRgL9ZaH5e6ALJmi5Jsc88f1FU7F6S/uN0GWUzWS7Pe0HSL5mCdKPma+VlI=
Message-ID: <fa4052ef0712121057o51230b22ycb79723091438779@mail.gmail.com>
Date: Wed, 12 Dec 2007 13:57:27 -0500
From: Shane <gnome42@gmail.com>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
Subject: Re: 2.6.24-rc5 "videobuf_read_start" [drivers/media/video/videobuf-dvb.ko] undefined!
Cc: "Adrian Bunk" <bunk@kernel.org>, "Brandon Philips" <brandon@ifup.org>,
       linux-kernel@vger.kernel.org,
       video4linux-list <video4linux-list@redhat.com>
In-Reply-To: <fa4052ef0712120837i36cee3elbe0a5170f5904d2f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa4052ef0712112120l1165af5btc108ea2131760328@mail.gmail.com>
	 <20071212090709.GF14204@stusta.de> <1197457394.4807.40.camel@gaivota>
	 <20071212120308.GG14204@stusta.de> <1197469316.4744.22.camel@gaivota>
	 <fa4052ef0712120837i36cee3elbe0a5170f5904d2f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 12, 2007 11:37 AM, Shane <gnome42@gmail.com> wrote:
> On Dec 12, 2007 9:21 AM, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> ...
> > The proper solution is provided by this changeset:
> > http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;h=19fb1457990b6b7e15586ec7331541a184233acc
>
> I applied this and it seems fine with a bttv card.

Ugh, after further testing with a bttv card it seems this is not fine.

vbi doesn't work anymore and my application gets stuck in a Zombie,
unkillable, have to reboot state :(

mythtv    3683     1  -3  2.4  0.0      0     0 ?        Z<l  13:40:35
00:00:06 [mythbackend] <defunct>

Reverting Mauro's patch above does fix the problem.

Shane
