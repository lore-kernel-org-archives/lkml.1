Return-Path: <linux-kernel-owner+w=401wt.eu-S1753408AbZGUBHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbZGUBHN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 21:07:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbZGUBHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 21:07:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39912 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751379AbZGUBHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 21:07:12 -0400
Date: Mon, 20 Jul 2009 18:05:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Marc Dionne <marc.c.dionne@gmail.com>
cc: Krzysztof Oledzki <olel@ans.pl>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.27.27
In-Reply-To: <4A650DE1.20105@gmail.com>
Message-ID: <alpine.LFD.2.01.0907201803170.19335@localhost.localdomain>
References: <20090720040655.GA11940@kroah.com> <4A645A45.9060509@ans.pl> <20090720151008.GC10015@suse.de> <alpine.LFD.2.01.0907200848530.13838@localhost.localdomain> <alpine.LNX.1.10.0907202341580.29729@bizon.gios.gov.pl> <alpine.LFD.2.01.0907201504470.19335@localhost.localdomain>
 <4A650219.3060003@gmail.com> <alpine.LFD.2.01.0907201650570.19335@localhost.localdomain> <4A650DE1.20105@gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 20 Jul 2009, Marc Dionne wrote:
> > 
> > It could be ccache too, of course.
> 
> Actually in my case it turns out that it is ccache after all - if I remove it
> from the picture everything is fine.  If I re-enable it, even with a clean
> cache, I get the problem.
> 
> It might just be a coincidence that it's triggered by the -fwrapv change.

Btw, do you find any core-files lying around if you enable them before the 
build with

	ulimit -c unlimited

or similar?

And how did you clean ccache? There's "-c" and then there's "-C".

		Linus
