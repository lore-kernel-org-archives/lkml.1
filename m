Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509AbZINMvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbZINMvB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 08:51:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755456AbZINMvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 08:51:00 -0400
Received: from cantor.suse.de ([195.135.220.2]:44436 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755496AbZINMu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 08:50:59 -0400
Date: Mon, 14 Sep 2009 14:50:59 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Salvatore Iovene <salvatore.iovene@googlemail.com>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org
Subject: Re: /lib/modules/2.6.31-10/build/drivers/input/hid-ids.h - where is
  it?
In-Reply-To: <c64207c00909140546v691d17f5sfc94bf425307e037@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.0909141448560.25928@twin.jikos.cz>
References: <c64207c00909140434t46d89025yaee72908143f128c@mail.gmail.com>  <200909141438.11560.elendil@planet.nl> <c64207c00909140546v691d17f5sfc94bf425307e037@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1747641777-17817450-1252932662=:25928"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1747641777-17817450-1252932662=:25928
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Mon, 14 Sep 2009, Salvatore Iovene wrote:

> > AFAICT in this case the file was simply moved to:
> > drivers/hid/hid-ids.h
> >        ^^^
> 
> Actually, that's the place where the file is looked for, despite the
> mistake in the subject of my email (I said I recalled from memory :))
> 
> See line 38 at http://linuxwacom.cvs.sourceforge.net/viewvc/linuxwacom/linuxwacom-dev/src/2.6.31/Makefile.in?revision=1.1&view=markup
> 
> So the question remains: why don't I have that file?

Probably this is because you don't have kernel-source package installed 
(or however is it called in your distro). /lib/modules/<version>/build is 
supposed to be symlink to the appropriate kernel sources, and apparently, 
in your case, it's not.

This is distro-specific/installation question though, so it's unlikely 
you'll get too much support on this mailinglist.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

---1747641777-17817450-1252932662=:25928--
