Return-Path: <linux-kernel-owner+w=401wt.eu-S1757119AbZKXAhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119AbZKXAhO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 19:37:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbZKXAhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 19:37:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40080 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540AbZKXAhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 19:37:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mike Smith <scgtrp@gmail.com>
Subject: Re: Toshiba Satellite ACPI problems
Date: Tue, 24 Nov 2009 01:37:39 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rc8-rjw; KDE/4.3.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
References: <525c5a6c0911231620u6d23810fu9fed3605617fe421@mail.gmail.com>
In-Reply-To: <525c5a6c0911231620u6d23810fu9fed3605617fe421@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911240137.39266.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding linux-acpi to the CC list.]

On Tuesday 24 November 2009, Mike Smith wrote:
> I have a brand new Satellite L505D-S5983 which I'm trying to install
> Linux on. Whenever I boot a Linux kernel on it with no special
> parameters it enters an in(de)finite loop dumping messages like this:
> 
> ACPI Error (uteval-0313): Return object type is incorrect
> [\_SB_.HSB1._STA] (Node ffff8800af8121a0), AE_TYPE
> ACPI Error: Type returned from _STA was incorrect: Device, expected
> Btypes: 1 20090521 uteval-319
> ACPI Error (psargs-0359): [DR ] Namespace lookup failure, AE_NOT_FOUND
> ACPI Error (psparse-0537): Method parse/execution failed
> [\_SB_.VALZ._STA] (Node ffff8800af812540), AE_NOT_FOUND
> ACPI Error: Found unknown opcode 39 at AML address ffffc900000132cd
> offset 0, ignoring 20090521 psloop-137
> [...]
> 
> If I boot with acpi=noirq these messages only continue for a few
> seconds, although they cause a couple of initscripts to hang later on.
> With ACPI fully enabled they keep appearing forever and the system
> doesn't finish booting. With acpi=off they don't appear at all (but
> the fan stays at low speed and the laptop gets quite hot if run for
> more than a few minutes).
> 
> I've found only one other mention of this problem on the internet
> (http://ubuntuforums.org/showthread.php?p=8358864#post8358864) from
> someone with the same laptop as mine, but there was no working fix
> posted to that thread beyond completely disabling ACPI. More research
> told me that there used to be a way of fixing up the DSDT and having
> it loaded from the initrd but the new policy is to just ask the
> manufacturer to fix it and the kernel developers to work around it,
> so... here it is. (Angry emails to Toshiba and Best Buy pending.)
> 
> Full dmesg output can be found at http://slexy.org/view/s25zU08AKJ
> (By the way, what's the correct way to include dmesg output in a lkml
> message if you don't know for sure which parts are relevant? Dumping
> all 50k or so of it into the email seems like the wrong thing to
> do...)

I think it's better if you file a bug report against ACPI at bugzilla.kernel.org.

Thanks,
Rafael
