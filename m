Return-Path: <linux-kernel-owner+w=401wt.eu-S1763642AbXF0XF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763642AbXF0XF3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 19:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbXF0XFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 19:05:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42113
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751433AbXF0XFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 19:05:16 -0400
Date: Wed, 27 Jun 2007 16:05:35 -0700 (PDT)
Message-Id: <20070627.160535.71552808.davem@davemloft.net>
To: crispin@novell.com
Cc: seanlkml@sympatico.ca, bunk@stusta.de, akpm@linux-foundation.org,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 00/44] AppArmor security module overview
From: David Miller <davem@davemloft.net>
In-Reply-To: <4682E8E1.6090701@novell.com>
References: <4682D13C.6060107@novell.com>
	<20070627172940.1cabd5c4.seanlkml@sympatico.ca>
	<4682E8E1.6090701@novell.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Crispin Cowan <crispin@novell.com>
Date: Wed, 27 Jun 2007 15:46:57 -0700

> But we do not want to prevent other people from using SELinux if it
> suits them. Linux is about choice, and that is especially vital in
> security. As Linus himself observed when LSM was started, there are a
> lot of security models, they have various strengths and weaknesses, and
> often are not compatible with each other. That is why it is important
> that LSM persist, that SELinux not be the only in-tree user of LSM, and
> why we think AppArmor should be included upstream, so that non-SUSE
> users can also use AppArmor if it suits them.

Anyone can apply the apparmour patch to their tree, they get the
choice that way.  Nobody is currently prevented from using apparmour
if they want to, any such suggestion is pure rubbish.

It is even more incredulious to imply that just by having apparmour
in the upstream kernel all the userland bits will magically appear
on every user's distribution.

Give me a break.

What you get by the code going into the upstream kernel tree is that
it a) adds some pseudo legitimacy to AppArmour (which I don't
personally think is warranted) and b) gets the work of keeping
apparmour working with upstream largely off of your back and in the
hands of the upstream community.

Neither of those are reasons why something should go into the tree.

Frankly I think AppArmour is a joke, and all of this integration with
LSM business is just a face saving effort, nothing more.  And saving
face is not, and has never been, a reason for something to be put into
the upstream tree.

