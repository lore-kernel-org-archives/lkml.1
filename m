Return-Path: <linux-kernel-owner+w=401wt.eu-S1759842AbYLLS1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759842AbYLLS1A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 13:27:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758628AbYLLS0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 13:26:52 -0500
Received: from sith.mimuw.edu.pl ([193.0.96.4]:45228 "EHLO sith.mimuw.edu.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757802AbYLLS0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 13:26:51 -0500
Date: Fri, 12 Dec 2008 19:26:50 +0100
From: Jan Rekorajski <baggins@sith.mimuw.edu.pl>
To: Manfred Spraul <manfred@colorfullife.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: Nasty regression from .27.7 to .27.8: idle samba goes crazy
Message-ID: <20081212182650.GA6383@sith.mimuw.edu.pl>
Mail-Followup-To: Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
	Manfred Spraul <manfred@colorfullife.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	linux-kernel@vger.kernel.org, stable@kernel.org
References: <pan.2008.12.08.06.18.57.357875@wizards.de> <200812080834.22924.rjw@sisk.pl> <pan.2008.12.08.08.07.29.439625@wizards.de> <493D4F5C.7020606@s5r6.in-berlin.de> <493D7349.10200@s5r6.in-berlin.de> <20081208222246.GA29232@sith.mimuw.edu.pl> <20081209123703.043067eb@dhcp-100-2-144.bos.redhat.com> <493FFE5E.2000404@colorfullife.com> <20081212010806.GA1007@sith.mimuw.edu.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081212010806.GA1007@sith.mimuw.edu.pl>
X-Operating-System: Linux 2.6.26.5 i686
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Dec 2008, Jan Rekorajski wrote:

> On Wed, 10 Dec 2008, Manfred Spraul wrote:
> 
> >> On Mon, 8 Dec 2008 23:22:46 +0100
> >> Jan Rekorajski <baggins@sith.mimuw.edu.pl> wrote:
> >>
> >>> I think you can safely rule out NIC, I'm also seeing this behaviour on a
> >>> brand new server with imap hanging in some busy-loop.
> >>> Network card in my case:
> >>> Broadcom Corporation NetXtreme II BCM5708 Gigabit Ethernet (rev 12)
> >>>
> >>> What I observer was one CPU doing 100% system work, and the number of
> >>> timer interrupts went from 1k per second to 4k (for the whole system).
> >>>
> >>>     
> > Could you try the attached patch?
> > It should fix the bug.
> 
> Thank you, I'm currently running 2.6.27.8 with your patch, I'll report
> after 12-24 hours.

top - 19:20:59 up 17:22, 34 users,  load average: 0.34, 0.41, 0.33

So, it seems that your patch cured my problem, as that server couldn't
survive more than 8 hours previously (2-3 was norm).

Jan
-- 
Jan Rekorajski            |  ALL SUSPECTS ARE GUILTY. PERIOD!
baggins<at>mimuw.edu.pl   |  OTHERWISE THEY WOULDN'T BE SUSPECTS, WOULD THEY?
BOFH, MANIAC              |                   -- TROOPS by Kevin Rubio
