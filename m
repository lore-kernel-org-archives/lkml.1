Return-Path: <linux-kernel-owner+w=401wt.eu-S965903AbXIKCoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965903AbXIKCoE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 22:44:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965452AbXIKCnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 22:43:53 -0400
Received: from barikada.upol.cz ([158.194.242.200]:52016 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965414AbXIKCnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 22:43:53 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Sami Farin <safari-kernel@safari.iki.fi>
Subject: Re: Broken mail setup
In-Reply-To: <20070910143934.1a695d54@the-village.bc.nu>
References: <20070910135912.29ad26e8@the-village.bc.nu> <20070910132042.33g4fhsgra4bzysh@m.safari.iki.fi> <20070910143934.1a695d54@the-village.bc.nu>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Sami Farin <safari-kernel@safari.iki.fi>
User-Agent: slrn + jed (x86_64-pc-linux-glibc-debian)
Date: Tue, 11 Sep 2007 04:59:08 +0200
Message-Id: <E1IUvy0-00084n-Bx@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Mon, 10 Sep 2007 14:39:34 +0100
* Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
>
> On Mon, 10 Sep 2007 16:20:42 +0300
> Sami Farin <safari-kernel@safari.iki.fi> wrote:
>
>> On Mon, Sep 10, 2007 at 13:59:12 +0100, Alan Cox wrote:
>> > Will RMK (rmk@arm.linux.org.uk) please fix his email setup otherwise I
>> > can't send serial/tty/arm stuff to him.
>> > 
>> > "<<< 550 You have no reverse DNS; please try again when you have resolved
>> 
>> Well, outpipe-village-512-1.bc.nu is NXDOMAIN.
>> It should have A record 81.2.110.250.
>
> I've yet to see a specification which requires this.

This is very brutal way of doing things, that somebody forced to do
against unwilling e-mails. I have it enabled in exim also as an
experiment (thus, see reply-to/mail-follow-up). It doesn't stop, but
reduces spam.

Especially this is wrong WRT mailing list. That's why i've proposed

* trivial checking for `in-reply-to/references' (SHOULD in rfc2822)
  (see, wizard -- no hands!)

* starting new threads will require valid ticket-requesting message
  first (as part of patch bomb of something like that, for instance).

My experiments show, that spam doesn't have any hint of mail header
magic, only stupid ms outlook stuff. Thus i don't think that idea is
very insecure and all that kind of things. Conversely developers like
Alan will not spend time and energy arguing about `modern ways of
dealing with reality' :)

--
-o--=O`C
 #oo'L O
<___=E M
