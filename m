Return-Path: <linux-kernel-owner+w=401wt.eu-S1760698AbZANAf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760698AbZANAf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 19:35:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755501AbZANAft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 19:35:49 -0500
Received: from netgear.net.ru ([195.178.208.66]:60362 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755079AbZANAfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 19:35:48 -0500
Date: Wed, 14 Jan 2009 03:35:46 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
Message-ID: <20090114003546.GA1705@ioremap.net>
References: <20090112231728.GA23803@ioremap.net> <alpine.DEB.2.00.0901121746220.20329@chino.kir.corp.google.com> <20090113085244.GA13796@ioremap.net> <alpine.DEB.2.00.0901130134090.25386@chino.kir.corp.google.com> <20090113115408.GA22289@ioremap.net> <20090113121510.68a55fe9@lxorguk.ukuu.org.uk> <20090113122904.GC25011@ioremap.net> <20090113131937.GB17664@mit.edu> <20090113133555.GA28107@ioremap.net> <496D30C3.4010905@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496D30C3.4010905@tmr.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 07:24:35PM -0500, Bill Davidsen (davidsen@tmr.com) wrote:
> >So effectively oom_adj only works as enable/disable switch, and since no
> >one knows how to tune it, it is better to do not touch at all. And get
> >ssh killed. I believe if it is ever used then only to disable oom at
> >all, which is wrong, since task still may be killed but after some
> >others. My patch adds a simple priority for that based on the name of
> >the process, which are known to the administrators who maintain given
> >system.
> >  
> If nothing else, this would seem to reduce the number of processes for 
> which the OOM coefficient of evil must be calculated.

Yes, it allows this.

-- 
	Evgeniy Polyakov
