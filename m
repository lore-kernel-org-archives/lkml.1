Return-Path: <linux-kernel-owner+w=401wt.eu-S1755990AbYICOxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbYICOxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 10:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408AbYICOxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 10:53:15 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:4691 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140AbYICOxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 10:53:14 -0400
From: Andrey Mirkin <major@openvz.org>
To: Cedric Le Goater <clg@fr.ibm.com>
Subject: Re: [PATCH 0/9] OpenVZ kernel based checkpointing/restart
Date: Wed, 3 Sep 2008 18:53:42 +0400
User-Agent: KMail/1.8.2
Cc: Louis.Rilling@kerlabs.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <1220439476-16465-1-git-send-email-major@openvz.org> <20080903140636.GS14473@hawkmoon.kerlabs.com> <48BE9E95.3020706@fr.ibm.com>
In-Reply-To: <48BE9E95.3020706@fr.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809031853.44212.major@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 September 2008 18:26 Cedric Le Goater wrote:
> > Forgot a global comment: you will probably get the same (rather pointless
> > for a proof of concept, IMHO) requests as Oren got, to
> > 1) improve coding style:
> >   a) especially avoid error handling like:
> > 	err = foo();
> > 	if (!err)
> > 		err = bar();
> > 	if (!err)
> > 		err = baz();
> >
> > and prefer
> > 	err = foo();
> > 	if (err)
> > 		goto foo_err;
> > 	err = bar();
> > 	...
> >
> >   b) do not write conditions on a single line, like
> > 	if (foo) bar;
> >
> > 2) put arch-dependent code in arch/ subdirs.
> > 3) I probably forgot other ones.
>
> ./scripts/checkpatch.pl catches most of it (and it does catch a few on your
> patches)

Thanks, I will use this script to brush up the code.

>
> but Dave is even better ! :)
I'm waiting for his comments :)

Regards,
Andrey

>
> > I obviously do not personally request you to take these requests into
> > account ;)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
