Return-Path: <linux-kernel-owner+w=401wt.eu-S933662AbZDBUSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933662AbZDBUSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 16:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932241AbZDBUSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 16:18:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41210 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763131AbZDBUSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 16:18:21 -0400
Date: Thu, 2 Apr 2009 15:16:21 -0500
From: Clark Williams <williams@redhat.com>
To: =?ISO-8859-1?B?RnLpZOlyaWM=?= Weisbecker <fweisbec@gmail.com>
Cc: Jon Masters <jcm@jonmasters.org>, LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jcm@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Subject: Re: [PATCH 1/2] SMI Detector: a simple module for detecting System
  Management Interrupts
Message-ID: <20090402151621.171a95c9@torg>
In-Reply-To: <c62985530904021205t2030c81o3d6439ab6a3a5e1e@mail.gmail.com>
References: <1238691005-25286-1-git-send-email-jcm@jonmasters.org>
	<1238691005-25286-2-git-send-email-jcm@jonmasters.org>
	<c62985530904021205t2030c81o3d6439ab6a3a5e1e@mail.gmail.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n32KIYqu017107

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On Thu, 2 Apr 2009 21:05:26 +0200
Frédéric Weisbecker <fweisbec@gmail.com> wrote:


> > +#if 1
> > +       val = simple_strtol(buffer, NULL, 10);
> > +#else
> > +       if (strict_strtol(buffer, 10, &val))
> > +               return -EINVAL;
> > +#endif
> 
> 
> 
> So I guess the #else statement can disappear? :-)
> 
> 

Ugh, don't blame Jon for that. I was trying to get rid of some
checkpatch warnings and was experimenting with strict vs. simple
strtol. 

I'll clean that up in the next iteration. Or Jon can and will then
abuse me :)

Clark

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAknVHRoACgkQHyuj/+TTEp0ndwCfe4ZeEsdflVY3udv9ukk7wKVQ
OycAn1Nl1OQr7nPUxPp3rln5SYVE4Bcn
=kZRN
-----END PGP SIGNATURE-----
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
