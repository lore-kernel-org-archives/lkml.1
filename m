Return-Path: <linux-kernel-owner+w=401wt.eu-S1755258AbZGOPLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbZGOPLh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 11:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755047AbZGOPLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 11:11:37 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59706 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbZGOPLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 11:11:36 -0400
Date: Wed, 15 Jul 2009 02:10:58 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alexey Fisher <bug-track@fisher-privat.net>, ykzhao <yakui.zhao@intel.com>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
Subject: Re: [PATCH] Solve the issue with memory corruption on Intel BIOS.
Message-ID: <20090715001058.GC1552@ucw.cz>
References: <1247637314-5609-1-git-send-email-bug-track@fisher-privat.net> <20090715103431.4381b423@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090715103431.4381b423@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-07-15 10:34:31, Alan Cox wrote:
> On Wed, 15 Jul 2009 07:55:14 +0200
> Alexey Fisher <bug-track@fisher-privat.net> wrote:
> 
> > In Bug 13710 was reported "corrupted low memory after resume on Intel
> > DG45ID board". It use AMI BIOS with Intel vendor string. We need to add this
> > vendor to CONFIG_X86_RESERVE_LOW_64K workaround.
> 
> Given that this is the first report of a problem with an Intel BIOS, and
> there are millions of systems not affected your match is far too wide I
> think. Match the board identifier as well at least rather than randomly
> making everyone suffer.

Given the intel pushing linux these days... could we get them to
debug&fix their bios?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
