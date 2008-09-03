Return-Path: <linux-kernel-owner+w=401wt.eu-S1755855AbYICO0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855AbYICO0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 10:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754350AbYICO0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 10:26:34 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:35087 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329AbYICO0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 10:26:34 -0400
Message-ID: <48BE9E95.3020706@fr.ibm.com>
Date: Wed, 03 Sep 2008 16:26:29 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Louis.Rilling@kerlabs.com
CC: Andrey Mirkin <major@openvz.org>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] OpenVZ kernel based checkpointing/restart
References: <1220439476-16465-1-git-send-email-major@openvz.org>	<20080903134951.GQ14473@hawkmoon.kerlabs.com> <20080903140636.GS14473@hawkmoon.kerlabs.com>
In-Reply-To: <20080903140636.GS14473@hawkmoon.kerlabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> Forgot a global comment: you will probably get the same (rather pointless for a
> proof of concept, IMHO) requests as Oren got, to
> 1) improve coding style:
>   a) especially avoid error handling like:
> 	err = foo();
> 	if (!err)
> 		err = bar();
> 	if (!err)
> 		err = baz();
> 
> and prefer
> 	err = foo();
> 	if (err)
> 		goto foo_err;
> 	err = bar();
> 	...
> 
>   b) do not write conditions on a single line, like
> 	if (foo) bar;
> 
> 2) put arch-dependent code in arch/ subdirs.
> 3) I probably forgot other ones.

./scripts/checkpatch.pl catches most of it (and it does catch a few on your 
patches)

but Dave is even better ! :) 

Cheers, 

C.

 
> I obviously do not personally request you to take these requests into account ;)

