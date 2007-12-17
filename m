Return-Path: <linux-kernel-owner+w=401wt.eu-S934580AbXLQWTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934580AbXLQWTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 17:19:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754342AbXLQWT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 17:19:26 -0500
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:53377 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563AbXLQWTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 17:19:25 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 18.85.9.136
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18dUJg5e10S9rBHphlw8sqo
Message-ID: <4766F5D0.7050204@reed.com>
Date: Mon, 17 Dec 2007 17:18:56 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.5) Gecko/20070727 Fedora/2.0.0.5-2.fc7 Thunderbird/2.0.0.5 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Rene Herman <rene.herman@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Paul Rolland <rol@as2917.net>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
References: <20071217105744.GA14315@elte.hu> <4766684D.40202@gmail.com> <20071217130933.GB27992@elte.hu> <47667812.8050708@gmail.com> <47667A85.3080100@reed.com> <20071217143900.GA16604@elte.hu> <20071217161243.05c32df4@the-village.bc.nu> <4766E086.9090500@gmail.com> <20071217214139.GC22828@elte.hu> <4766EE79.90003@keyaccess.nl> <20071217215658.GA4782@elte.hu> <4766F1AE.4060601@keyaccess.nl>
In-Reply-To: <4766F1AE.4060601@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Besides the two reports of freezes on bugzilla.kernel.org (9511, 6307), 
the following two bug reports on bugzilla.redhat.com are almost 
certainly due to the same cause (imo, of course): 245834, 227234.

Ubuntu launchpad bug 158849 also seems to report the same problem, for 
an HP dv6258se 64-bit machine.

Also this one: 
http://www.mail-archive.com/linux-acpi@vger.kernel.org/msg10321.html

If you want to collect dmidecode data from these folks, perhaps we might 
get a wider sense of what categories of machines are affected.  They all 
seem to be recemt HP and Compaq AMD64 laptops, probably all Quanta 
motherboards.


