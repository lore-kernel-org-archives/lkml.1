Return-Path: <linux-kernel-owner+w=401wt.eu-S1754930AbZJZXqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930AbZJZXqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 19:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754839AbZJZXqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 19:46:07 -0400
Received: from mail001.aei.ca ([206.123.6.130]:44474 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754792AbZJZXp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 19:45:59 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
Date: Mon, 26 Oct 2009 19:45:56 -0400
User-Agent: KMail/1.11.4 (Linux/2.6.31.4-crc; KDE/4.2.4; x86_64; ; )
Cc: Boyan <btanastasov@yahoo.co.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       " =?iso-8859-1?q?Fr=E9d=E9ric_L=2E_W=2E?= Meunier" 
	<fredlwm@gmail.com>,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
References: <G2WU8XrUVpF.A.lxF.Ref5KB@chimera> <4AE621CB.6000700@yahoo.co.uk> <alpine.LFD.2.01.0910261543400.31845@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0910261543400.31845@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910261945.58027.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 October 2009 18:45:27 Linus Torvalds wrote:
> 
> On Tue, 27 Oct 2009, Boyan wrote:
> > 
> > I think it is fixed in 2.6.31.5. I can't reproduce the problem with it.
> 
> It was fixed by mainline commit c8e33141911bf8fe87dc6c92793b9a59b2be0130 
> ("tty: Make flush_to_ldisc() locking more robust"), which got back-ported 
> to 2.6.31.5 as commit 86d23a057.

I can confirm that the keyboard is no longer missbehaving here  with 31.5

Ed
