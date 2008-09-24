Return-Path: <linux-kernel-owner+w=401wt.eu-S1754693AbYIXXGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbYIXXGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 19:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754060AbYIXXFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 19:05:20 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:23170 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbYIXXFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 19:05:17 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: matthieu castet <castet.matthieu@free.fr>
Subject: Re: [Bug 11603] Re: ACPI PnP on Intel MU440EX
Date: Wed, 24 Sep 2008 17:05:12 -0600
User-Agent: KMail/1.9.9
Cc: Martin Doucha <next_ghost@quick.cz>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       bugme-daemon@bugzilla.kernel.org
References: <48BA9B2C.7060007@quick.cz> <200809221701.13569.bjorn.helgaas@hp.com> <48D95FB2.4050108@free.fr>
In-Reply-To: <48D95FB2.4050108@free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809241705.13410.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If you want you could try to run the attached program on your pc in 
> "auto/bidirectional" or "auto/EPP" mode.
> 
> This program does what _STA methods do.

I'm just curious -- what do you hope to learn from this program?
Do you think it will tell us more than what actually running _STA
did?

The best solution I can think of would be to have a parameter like
"parport.nopnp" that made parport just probe the legacy addresses,
and document that you might need that on machines with broken ACPI
firmware.  But I'm a little afraid to touch parport_pc.c.
