Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbYABLlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbYABLlm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 06:41:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbYABLle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 06:41:34 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:58593 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbYABLle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 06:41:34 -0500
Date: Wed, 2 Jan 2008 12:41:32 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Dave Young <hidave.darkstar@gmail.com>, Matthew Wilcox <matthew@wil.cx>,
       gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: The perfect patch - Posting a patch series (was Re: [PATCH 06/12]
 pci : Use mutex instead of semaphore in driver core)
In-Reply-To: <477B7219.4080508@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.64.0801021238450.14900@fbirervta.pbzchgretzou.qr>
References: <20071229011057.GG2883@darkstar.te-china.tietoenator.com> 
 <20071229025506.GL11638@parisc-linux.org>  <477632A7.6050208@s5r6.in-berlin.de>
 <a8e1da0801011829p15da81dcw9db0f7cbb5444467@mail.gmail.com>
 <477B7219.4080508@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 2 2008 12:14, Stefan Richter wrote:
>There is nothing wrong with a 0/n posting per se.  But whenever you
>write a 0/n posting, ask yourself:
>  - Isn't the information I provide here necessary to keep around by
>    somebody who takes my patch series into his quilt series or into his
>    source repository?
>  - Couldn't the information here be useful at a later point in time
>    when people look into the mainline Linux history?
>If "yes" or "maybe yes", then add this information to the changelogs in
>the patches.  You can then leave the 0/n posting as is, or make it
>briefer, or omit it entirely.

Please emit a [0/n] and the [m/n] as a reply so that threading-aware
mail readers can collapse and/or use delete-thread-at-a-time feature.
If there is no info in [0/n], let it be empty or a one,two-liner brief
introduction.

>It is never necessary to post a 0/n message, because _everything_ which
>could be said in this message can also be said in the i/n messages.
>(Things which are not meant for the SCM changelog can be written after a
>"---" delimiter line or other patch delimiters.)  However, it is
>sometimes convenient to repeat or summarize some of the information from
>the i/n messages in a 0/n message.  Think about convenience of the
>_recipients_ though, not about the sender's convenience.

And [0/n] sometimes contain a diffstat which gives an approximate
line count of how big the patchset actually is.
