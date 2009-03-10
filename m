Return-Path: <linux-kernel-owner+w=401wt.eu-S1755648AbZCJONV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648AbZCJONV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 10:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752287AbZCJOMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 10:12:48 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40352 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbZCJOMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 10:12:47 -0400
Date: Tue, 10 Mar 2009 15:12:38 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Alexandre Rostovtsev <tetromino@gmail.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lenovo-sl-laptop : driver for review
Message-ID: <20090310141238.GC1374@ucw.cz>
References: <20090216025918.66d7a466@leftboat.lan> <20090227132752.GG1482@ucw.cz> <20090228143711.GB17541@khazad-dum.debian.net> <20090310112209.GB1337@ucw.cz> <20090310113419.GC371@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090310113419.GC371@khazad-dum.debian.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > That's quite a lot of code for verbatim copy; create shared helper?
> > > 
> > > Yeah, I am game.  But let's do it later on and not delay anything because of
> > > it, please.  I will start breaking thinkpad-acpi into multiple source files,
> > > and after that is done (should take a while, thinkpad-acpi is a big module
> > > with a LOT of subdriver interdependencies) we can look for the best way to
> > > reduce code duplication.
> > 
> > Well,  this monolith is quite long/hard to review. IMO it should be
> > split to make review easy. 
> 
> thinkpad-sl could be split, yes.  But if you guys are going to wait for
> thinkpad-acpi to be split _as well_ to do some common-path merging, THAT is
> going to take quite a while...

I guess waiting is not neccessary; plus having split thinkpad-sl
driver should make common-path merging easier for you later...

> An alternative is to submit a minimal thinkpad-sl, then add features to it
> patch-by-patch.  That makes reviewing it easier.

Yeah but as we are moving away from mega-driver, anyway, ...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
