Return-Path: <linux-kernel-owner+w=401wt.eu-S1758228AbZKESYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228AbZKESYA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 13:24:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758211AbZKESX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 13:23:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55574 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758181AbZKESX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 13:23:59 -0500
Date: Thu, 5 Nov 2009 10:22:43 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jack Steiner <steiner@sgi.com>
cc: Michael Buesch <mb@bu3sch.de>, Jiri Kosina <jkosina@suse.cz>,
       Michael Gilbert <michael.s.gilbert@gmail.com>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: CVE-2009-2584
In-Reply-To: <20091105181628.GA2239@sgi.com>
Message-ID: <alpine.LFD.2.01.0911051021320.31845@localhost.localdomain>
References: <20091104170542.e40b12ec.michael.s.gilbert@gmail.com> <alpine.LFD.2.01.0911050831330.31845@localhost.localdomain> <alpine.LFD.2.01.0911050923580.31845@localhost.localdomain> <200911051847.36103.mb@bu3sch.de> <20091105181628.GA2239@sgi.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 5 Nov 2009, Jack Steiner wrote:
> 
> "buf" should be larger than 16. The string could be "0x" + 16 characters.

I have 'char buf[20];' in my tree now.

> I'll verify the the rest.
> 
> We have the hardware :-)

Thanks. I've committed it locally, but if I get a tested-by or an ack (or 
a fix) soon enough, I'll update the commit before I push it out.

		Linus
