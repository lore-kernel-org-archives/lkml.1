Return-Path: <linux-kernel-owner+w=401wt.eu-S1756368AbXKJX4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368AbXKJX4x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 18:56:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755547AbXKJX4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 18:56:45 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36576 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755489AbXKJX4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 18:56:44 -0500
Date: Sat, 10 Nov 2007 23:56:09 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: david@lang.hm
Cc: "Dr. David Alan Gilbert" <linux@treblig.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       LSM ML <linux-security-module@vger.kernel.org>,
       apparmor-dev <apparmor-dev@forge.novell.com>
Subject: Re: AppArmor Security Goal
Message-ID: <20071110235609.00958d87@the-village.bc.nu>
In-Reply-To: <Pine.LNX.4.64.0711101546400.4780@asgard.lang.hm>
References: <473380AD.5070801@crispincowan.com>
	<20071110220455.GB24195@gallifrey>
	<47362C7C.2050202@crispincowan.com>
	<20071110222414.GC24195@gallifrey>
	<47363381.4030103@crispincowan.com>
	<20071110232545.GD24195@gallifrey>
	<Pine.LNX.4.64.0711101546400.4780@asgard.lang.hm>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> but how can the system know if the directory the user wants to add is 
> reasonable or not? what if the user says they want to store their 
> documents in /etc?

A more clear example is wanting to wrap a specific tool with temporary
rules. Those rules would depend on the exact file being edited at this
moment - something root cannot know in advance
(although with apparmor I guess mv $my_file apparmour_magic.name ; foo;
mv it back might work 8))

