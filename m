Return-Path: <linux-kernel-owner+w=401wt.eu-S1757275AbYAYRcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275AbYAYRcJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 12:32:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753880AbYAYRb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 12:31:56 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:62055 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823AbYAYRbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 12:31:55 -0500
Date: Fri, 25 Jan 2008 18:31:44 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Bodo Eggert <7eggert@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Introduce softpanic
In-Reply-To: <p73ejc67xvb.fsf@bingen.suse.de>
Message-ID: <alpine.LSU.0.999.0801251706200.2201@be1.lrz>
References: <alpine.LSU.0.999.0801251551060.21522@be1.lrz>
 <p73ejc67xvb.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX18jJIG1DOUShllTz7qtv66CmjjHNB0bIa7eRfE
 HbdrIpg3r8L/81Utt8iL9CIrDEPqJxbR+SDZuFV7rX4dPnWsOQ
 QIXydqwCT9aE3KjKvax4g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jan 2008, Andi Kleen wrote:
> Bodo Eggert <7eggert@gmx.de> writes:

> > Enabling this option changes a hard panic on boot errors to a
> > soft panic, which does not stop the system completely.
> > You can still scroll the screen and read the messages.
> 
> I don't think it's a good idea to keep the network running in the
> soft panic. A lot of people have set ups that use ping was a watchdog
> and with nfsroot/ip=dhcp ping does work quite well before
> mounting root and then the watchdog might not pick up the 
> soft panic.

> Using a polled keyboard driver after panic seems to be the better
> option to me, but if you want softpanic you should probably
> at least add a suitable panic notifier to the network stack 
> to shut it all down.

I have no idea on how to do it. If somebody has a big red arrow pointing to 
a HOWTO, I can give it a try.

OTOH, I think the panic timeout should do the job nicely.
-- 
If you talk about race, it does not make you a racist. If you see distinctions
between the genders, it does not make you a sexist. If you think critically
about a denomination, it does not make you anti-religion. If you accept but
don't celebrate homosexuality, it does not make you a homophobe.Charlton Heston
