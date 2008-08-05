Return-Path: <linux-kernel-owner+w=401wt.eu-S1422681AbYHEVFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422681AbYHEVFy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 17:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762205AbYHEVFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 17:05:42 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49612 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758967AbYHEVFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 17:05:41 -0400
Date: Tue, 5 Aug 2008 22:05:24 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Press, Jonathan" <Jonathan.Press@ca.com>, Greg KH <greg@kroah.com>,
       Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, linux-security-module@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a
	linuxinterfaceforon access scanning
Message-ID: <20080805210524.GH28946@ZenIV.linux.org.uk>
References: <20080805112747.2c3c4650@infradead.org> <2629CC4E1D22A64593B02C43E85553030480743E@USILMS12.ca.com> <20080805183845.GA11375@kroah.com> <2629CC4E1D22A64593B02C43E855530304AE4AD9@USILMS12.ca.com> <20080805133832.220d71c7@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080805133832.220d71c7@infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 01:38:32PM -0700, Arjan van de Ven wrote:

> This does assume that at some point you have a transition from "ok"
> program to the first time you run a "bad" one (via exec or open); and
> that you catch it at that point.
> 
> I don't yet buy the argument "but what if the virus corrupted your ld
> preload", because if it can do that your own virus scanner is also
> corrupted.
> 
> 
> Can you explain what gap is left after you do these two things?

Actually, the real question (and the reason why I question the personal
integrity of the people in "AV community" pushing that kind of trash)
is very simple:

Where Is Your Threat Profile?

Various people had been asking for _years_ to define what the hell are you
trying to prevent.  Not only there'd been no coherent answer (and no, this
list of requirements is _not_ that - it's "what kind of hooks do we want"),
you guys seem to be unable to decide whether you expect the malware in
question to be passive or to be actively evading detection with infected
processes running on the host that does scanning.

Moreover, the answer seems to be changing back and forth to suit the needs
of the moment in the argument.  Slightly exaggregated it goes like this:

-- Why don't you do $FOO?
-- Running virus would be able to evade $FOO, of course!
-- No shit, Sherlock; it would also be able to evade much more intrusive $BAR
you are proposing; here's how <obvious evasion method>
-- Oh, but that's not a problem; think of Linux server with Windows clients
and Windows viruses...
