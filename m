Return-Path: <linux-kernel-owner+w=401wt.eu-S934009AbZFLTEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934009AbZFLTEo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 15:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933949AbZFLTEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 15:04:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59403 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933891AbZFLTEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 15:04:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 12/19] PM/Suspend: Do not shrink memory before suspend
Date: Fri, 12 Jun 2009 21:04:33 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, Magnus Damm <damm@igel.co.jp>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Sergio Luis <sergio@larces.uece.br>,
       Lauro Salmito <laurosalmito@gmail.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Nigel Cunningham <nigel@tuxonice.net>
References: <0615007ad8090a890586d530b5d3bb98da566014.1244752872.git.rjw@sisk.pl> <S4AoGnG.A.6G.dgYMKB@chimera> <20090612110235.GL18682@elf.ucw.cz>
In-Reply-To: <20090612110235.GL18682@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906122104.34958.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 June 2009, Pavel Machek wrote:
> On Thu 2009-06-11 22:39:03, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Remove the shrinking of memory from the suspend-to-RAM code, where
> > it is not really necessary.
> 
> I still have not seen any explanation why it is not neccessary.
> 
> It is true that I did not have time to stress my system to the point
> when it has 0 pages free, but we certainly know that it is possible,
> and we know that at least one driver allocates memory and will be
> broken if that happens.
> 
> NAK.

Sorry, I'm going to let Linus decide about this one.

Best,
Rafael
