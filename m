Return-Path: <linux-kernel-owner+w=401wt.eu-S1030220AbXBLWjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030220AbXBLWjV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 17:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030216AbXBLWi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 17:38:57 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:36268 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030220AbXBLWi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 17:38:56 -0500
Subject: Re: NAK new drivers without proper power management?
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Tilman Schmidt <tilman@imap.cc>, Pavel Machek <pavel@ucw.cz>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200702122106.25939.rjw@sisk.pl>
References: <1171058269.1484.64.camel@nigel.suspend2.net>
	 <45CFB06B.5080102@imap.cc> <1171253309.5473.15.camel@nigel.suspend2.net>
	 <200702122106.25939.rjw@sisk.pl>
Content-Type: text/plain
Date: Tue, 13 Feb 2007 09:38:54 +1100
Message-Id: <1171319934.4081.55.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Mon, 2007-02-12 at 21:06 +0100, Rafael J. Wysocki wrote:
> On Monday, 12 February 2007 05:08, Nigel Cunningham wrote:
> > Nope. I'm assuming that the driver author knows what needs to be done to
> > get the driver out of whatever state the BIOS puts it in to start with,
> > and into an operational state, and that they therefore also know what
> > needs to be done to take it out of the operational state again. I'm
> > admitting that there's also another state - the post suspend-to-ram
> > driver state - that they may not know how to deal with. But for
> > suspend-to-disk, if you know how to get the driver to work in the first
> > place, you know enough to stop it working (.suspend) and start it up
> > again (.resume) for the hibernate case at least.
> 
> We're talking about _both_ the STR and STD.  The drivers that have problems
> with the STR cannot be regarded as suspend/resume-safe IMO.

Yeah, I'm not disagreeing at all. I'm just admitting my bias toward the
bit I concentrate on more.

[...]

> > Mmm, so that's a case where we need to prod those who write
> > documentation and bus support first. You're probably closer! :)
> 
> Actually, the lack of documentation is a major problem that we all should
> try to fix in the first place.  Unfortunately the code has been recently
> changing quite often, so that's difficult.

Yeah.

Nigel

