Return-Path: <linux-kernel-owner+w=401wt.eu-S1760067AbZAMXhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760067AbZAMXhe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 18:37:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759188AbZAMXg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 18:36:57 -0500
Received: from genesysrack.ru ([195.178.208.66]:48255 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758865AbZAMXg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 18:36:56 -0500
Date: Wed, 14 Jan 2009 02:36:54 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Valdis.Kletnieks@vt.edu
Cc: David Rientjes <rientjes@google.com>, Bill Davidsen <davidsen@tmr.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
Message-ID: <20090113233654.GB31490@ioremap.net>
References: <20090112155615.GA21350@ioremap.net> <20090112161931.6203f96e@lxorguk.ukuu.org.uk> <20090112162938.GA22647@ioremap.net> <496BCB7A.2010804@tmr.com> <20090112231728.GA23803@ioremap.net> <alpine.DEB.2.00.0901121746220.20329@chino.kir.corp.google.com> <20090113085244.GA13796@ioremap.net> <alpine.DEB.2.00.0901130134090.25386@chino.kir.corp.google.com> <20090113115408.GA22289@ioremap.net> <30255.1231889165@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30255.1231889165@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 06:26:05PM -0500, Valdis.Kletnieks@vt.edu (Valdis.Kletnieks@vt.edu) wrote:
> On Tue, 13 Jan 2009 14:54:08 +0300, Evgeniy Polyakov said:
> 
> > Who should adjust the scores for newly created processes? Who should
> > check that processes in the first group have negative oom ajustment and
> > in the second group a positive value? Who determines when its time to
> > ajust the scores?
> 
> Are you saying that you, as the box's administrator, don't know the answers
> to those questions?
> 
> Or are you asking what the actual method of implementation is - which process
> is supposed to write to (possibly some other process) oom_adjust, and when?

Unfortunately I do not know the answers. Since all parameters are highly
dynamic and can not be always automatically tuned. And we do not have a
daemon to watch created processes. And in the general case we can not
change the application.

-- 
	Evgeniy Polyakov
