Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbZFLLc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbZFLLc2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 07:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751103AbZFLLcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 07:32:19 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:51452 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbZFLLcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 07:32:19 -0400
Date: Fri, 12 Jun 2009 13:32:18 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, Magnus Damm <damm@igel.co.jp>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Sergio Luis <sergio@larces.uece.br>,
       Lauro Salmito <laurosalmito@gmail.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Nigel Cunningham <nigel@tuxonice.net>
Subject: Re: [PATCH 19/19] PM: Add empty suspend/resume device irq functions
Message-ID: <20090612113218.GB6355@osiris.boeblingen.de.ibm.com>
References: <0615007ad8090a890586d530b5d3bb98da566014.1244752872.git.rjw@sisk.pl> <S4AoGnG.A.AI.ZjYMKB@chimera> <20090612111317.GP18682@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090612111317.GP18682@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 01:13:17PM +0200, Pavel Machek wrote:
> On Thu 2009-06-11 22:42:09, Rafael J. Wysocki wrote:
> > From: Heiko Carstens <heiko.carstens@de.ibm.com>
> > 
> > git commit 0a0c5168 "PM: Introduce functions for suspending and resuming
> > device interrupts" introduced some helper functions. However these
> > functions are only available for architectures which support
> > GENERIC_HARDIRQS.
> 
> I believe architectures that do not use GENERIC_HARDIRQs should just
> provide the empty functions themselves.
> 
> If we want to help them, perhaps few attribute((weak)) functions in
> the core are the way to go...

We can still do that when there actually is an architecture that doesn't
support GENERIC_HARDIRQs _and_ needs non-empty functions.
