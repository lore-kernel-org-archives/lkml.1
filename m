Return-Path: <linux-kernel-owner+w=401wt.eu-S1757648AbZAMM3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648AbZAMM3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 07:29:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753750AbZAMM3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 07:29:07 -0500
Received: from corega.com.ru ([195.178.208.66]:36456 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753594AbZAMM3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 07:29:05 -0500
Date: Tue, 13 Jan 2009 15:29:04 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Rientjes <rientjes@google.com>, Bill Davidsen <davidsen@tmr.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
Message-ID: <20090113122904.GC25011@ioremap.net>
References: <20090112155615.GA21350@ioremap.net> <20090112161931.6203f96e@lxorguk.ukuu.org.uk> <20090112162938.GA22647@ioremap.net> <496BCB7A.2010804@tmr.com> <20090112231728.GA23803@ioremap.net> <alpine.DEB.2.00.0901121746220.20329@chino.kir.corp.google.com> <20090113085244.GA13796@ioremap.net> <alpine.DEB.2.00.0901130134090.25386@chino.kir.corp.google.com> <20090113115408.GA22289@ioremap.net> <20090113121510.68a55fe9@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113121510.68a55fe9@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 12:15:10PM +0000, Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> > Who should adjust the scores for newly created processes? Who should
> > check that processes in the first group have negative oom ajustment and
> > in the second group a positive value? Who determines when its time to
> > ajust the scores?
> 
> This is policy. Where does policy go ? User space

Don't you notice how many 'who' were placed and only single 'user space'
answer? Becasue it is not an answer, it is a theoretical POV, which does
not really work in practice, since it is way too unconvenient and
error-prone, and actually it does not work when needed, since because of
its complexity something will be missed. I've just talked with the
admins who originally requested 'kill-by-name' feature why they did not
work with /proc/.../oom_adj, and got a nice answer: we tries, but
likely something went wrong and it did not work the way we wanted.

There is no way to know that adjustment is correct, that everything was
uptodate when oom happend, that nothing was forgotten and practice shows
that there are always such problems and invalid tasks are killed.

When you put a name you do know that it works, since it is only single
place to be updated and no need to bother with ugly tools or changes
especially to handle short-living processes.

-- 
	Evgeniy Polyakov
