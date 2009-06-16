Return-Path: <linux-kernel-owner+w=401wt.eu-S1756803AbZFPJ1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbZFPJ1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 05:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751438AbZFPJ1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 05:27:38 -0400
Received: from cantor.suse.de ([195.135.220.2]:38278 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbZFPJ1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 05:27:37 -0400
Date: Tue, 16 Jun 2009 11:27:38 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org
Subject: Re: 2.6.{28,30} Keyboard not working on oldish machine
In-Reply-To: <20090614122734.GA1499@gallifrey>
Message-ID: <alpine.LRH.2.00.0906161126330.31685@twin.jikos.cz>
References: <20090613230842.GA18347@gallifrey> <4A349B67.1070603@zytor.com> <20090614122734.GA1499@gallifrey>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Jun 2009, Dr. David Alan Gilbert wrote:

> > > [    3.147416] PNP: No PS/2 controller found. Probing ports directly.
> > > [    3.174456] serio: i8042 KBD port at 0x60,0x64 irq 1
> > > [    3.174961] serio: i8042 AUX port at 0x60,0x64 irq 12
> > > [    3.186312] mice: PS/2 mouse device common for all mice
> > It does, correctly, identify the keyboard and mode port, so it's
> > somewhat odd that it doesn't get used...
> Indeed. The only other observation in the older kernel that works
> it detects the AUX port first.

Booting with 'i8042.debug' will spit some more output into dmesg, which 
might help us to see if i8042 is really properly initialized, or something 
strange is going on during initialization.

-- 
Jiri Kosina
SUSE Labs

