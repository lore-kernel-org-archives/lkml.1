Return-Path: <linux-kernel-owner+w=401wt.eu-S1758524AbYHZQ23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524AbYHZQ23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 12:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752915AbYHZQ2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 12:28:20 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60011 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752642AbYHZQ2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 12:28:19 -0400
Date: Tue, 26 Aug 2008 17:10:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Avi Kivity <avi@qumranet.com>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>, Pavel Machek <pavel@suse.cz>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] x86: default to reboot via ACPI
Message-ID: <20080826171051.778bc9be@lxorguk.ukuu.org.uk>
In-Reply-To: <48B40631.5090007@qumranet.com>
References: <1219659087-17536-1-git-send-email-avi@qumranet.com>
	<20080826095032.GA309@elf.ucw.cz>
	<48B3D579.40502@qumranet.com>
	<20080826113317.520cbab1@lxorguk.ukuu.org.uk>
	<48B3F3A9.8030709@qumranet.com>
	<Pine.LNX.4.55.0808261406330.28361@cliff.in.clinika.pl>
	<48B40631.5090007@qumranet.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Only common sense.  Non-recent machines are barely usable these days.  
> Sure they work well as a firewall or server-in-a-closet, but if you run 
> a desktop or a server that actually does useful work, you're running a 
> relatively recent machine.

Or a properly written desktop, or a thin client for desktop or ...

The really old boxes are actually not the problem, we don't try and use
ACPI on them so we won't try ACPI reboot. For those later ones it is
probably worth trying anyway - we might end up with a different blacklist
to before but there are multiple servers that really don't like old style
reboot nowdays.

Alan
