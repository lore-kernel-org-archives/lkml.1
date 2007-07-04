Return-Path: <linux-kernel-owner+w=401wt.eu-S1756609AbXGDWq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609AbXGDWq7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 18:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754051AbXGDWqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 18:46:51 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53541 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753987AbXGDWqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 18:46:50 -0400
Date: Wed, 4 Jul 2007 15:46:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
cc: Dmitry Torokhov <dtor@insightbb.com>, Andi Kleen <ak@suse.de>,
       Indan Zupancic <indan@nul.nu>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       bwalle@suse.de, rpurdie@rpsys.net
Subject: Re: blink driver power saving
In-Reply-To: <20070704223200.GA2053@elf.ucw.cz>
Message-ID: <alpine.LFD.0.98.0707041545490.9434@woody.linux-foundation.org>
References: <51563.81.207.0.53.1183376603.squirrel@secure.samage.net>
 <200707021439.27357.ak@suse.de> <20070702230827.GA9071@elf.ucw.cz>
 <200707030142.36252.dtor@insightbb.com> <20070704223200.GA2053@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 5 Jul 2007, Pavel Machek wrote:
>
> Actually here's one that does not immediately oops when I plug USB
> keyboard in.

Why do you use a delayed workqueue and then always use it without a delay? 
That seems silly.

		Linus
