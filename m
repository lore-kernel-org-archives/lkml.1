Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab0CCRLu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 12:11:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43866 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751831Ab0CCRLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 12:11:48 -0500
Date: Wed, 3 Mar 2010 09:10:46 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Wu Fengguang <fengguang.wu@intel.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, "H. Peter Anvin" <hpa@linux.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sachin Sant <sachinp@in.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Ian Campbell <ian.campbell@citrix.com>,
       Alok Kataria <akataria@vmware.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       =?ISO-8859-15?Q?Pasi_K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: [GIT PULL] x86/mm fixes
In-Reply-To: <20100303020845.GD6477@localhost>
Message-ID: <alpine.LFD.2.00.1003030909590.3627@localhost.localdomain>
References: <201003020010.o220Ax3Z025848@hera.kernel.org> <alpine.LFD.2.00.1003021038410.3616@localhost.localdomain> <4B8D67A4.8080602@zytor.com> <20100303020845.GD6477@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Mar 2010, Wu Fengguang wrote:
> 
> Anyway I just hacked /usr/share/quilt/refresh to automatically run the
> kernel style checker:
> 
> # wfg: check for kernel coding style
> if [ -x scripts/checkpatch.pl ]; then
>         scripts/checkpatch.pl $patch_file
> fi

It's probably sensible to check things, but do remember that some of the 
things checkpatch warns about are better left the way they are, rather 
than make the code uglier just to make checkpatch happy.

			Linus
