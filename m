Return-Path: <linux-kernel-owner+w=401wt.eu-S1754598AbZJZWqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbZJZWqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 18:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754286AbZJZWqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 18:46:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44073 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754122AbZJZWqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 18:46:18 -0400
Date: Mon, 26 Oct 2009 15:45:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Boyan <btanastasov@yahoo.co.uk>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       =?ISO-8859-15?Q?=22Fr=E9d=E9ric_L=2E_W=2E_Meunier=22?= 
	<fredlwm@gmail.com>,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
In-Reply-To: <4AE621CB.6000700@yahoo.co.uk>
Message-ID: <alpine.LFD.2.01.0910261543400.31845@localhost.localdomain>
References: <G2WU8XrUVpF.A.lxF.Ref5KB@chimera> <vX3ILojF2dJ.A.lYG.ref5KB@chimera> <4AE621CB.6000700@yahoo.co.uk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 27 Oct 2009, Boyan wrote:
> 
> I think it is fixed in 2.6.31.5. I can't reproduce the problem with it.

It was fixed by mainline commit c8e33141911bf8fe87dc6c92793b9a59b2be0130 
("tty: Make flush_to_ldisc() locking more robust"), which got back-ported 
to 2.6.31.5 as commit 86d23a057.

			Linus
