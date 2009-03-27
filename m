Return-Path: <linux-kernel-owner+w=401wt.eu-S1758149AbZC0NEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149AbZC0NEp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 09:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbZC0NEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 09:04:37 -0400
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:53254 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751325AbZC0NEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 09:04:36 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-07.arcor-online.net E16893CA6DB
Date: Fri, 27 Mar 2009 14:04:32 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: Pavel Machek <pavel@ucw.cz>
cc: Bodo Eggert <7eggert@gmx.de>, James Morris <jmorris@namei.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: TOMOYO in linux-next
In-Reply-To: <20090327114224.GF2585@elf.ucw.cz>
Message-ID: <alpine.LSU.0.999.0903271354290.5610@be1.lrz>
References: <ck5CF-5mU-11@gated-at.bofh.it> <E1Ln8MC-0001RR-1E@be1.7eggert.dyndns.org>
 <20090327114224.GF2585@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Mar 2009, Pavel Machek wrote:
> On Fri 2009-03-27 10:28:07, Bodo Eggert wrote:
> > Pavel Machek <pavel@ucw.cz> wrote:

> > > I don't think merging that is good idea. Security should be doable
> > > without making shell-like glob matching...
> > 
> > How do you suppose a security system should handle mozilla modifying
> > ~/.bashrc differently from downloading something to ~/pr0n.jpg?
> 
> How does shell-like glob matching help there? You'd need to parse
> /etc/passwd to find all ~ directories...

That is, if you'd use HOME=`dd if=/dev/urandom ...`.

If you have your users in /home/user, you can tell /home/*/.*
is bad, /home/*/[^.]* is OK.

How would you exclude mozilla from writing to .* then? ".a" is bad,
".b" is bad ...? or "A" is OK, "a" is OK, "zzzzzzzzzzzzz" is OK"?
Either way, you'd need several universes to store the security profile.
-- 
The enemy diversion you have been ignoring will be the main attack.
