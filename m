Return-Path: <linux-kernel-owner+w=401wt.eu-S1753337AbZLPFWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbZLPFWJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 00:22:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbZLPFWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 00:22:07 -0500
Received: from vms173019pub.verizon.net ([206.46.173.19]:51827 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbZLPFWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 00:22:05 -0500
Date: Wed, 16 Dec 2009 00:21:39 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: =?ISO-8859-15?Q?J=2EA=2E_Magall=F3n?= <jamagallon@ono.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: Useless thermal acpi driver ?
In-reply-to: <20091215234619.62d0ebc1@werewolf.home>
Message-id: <alpine.LFD.2.00.0912160009100.28497@localhost.localdomain>
References: <20091209232608.25aed4ca@werewolf.home>
 <4B20483C.6090309@gmail.com>
 <alpine.LFD.2.00.0912110122570.24891@localhost.localdomain>
 <20091211094515.4b4872ef@werewolf.home>
 <alpine.LFD.2.00.0912142159540.9446@localhost.localdomain>
 <20091215234619.62d0ebc1@werewolf.home>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: MULTIPART/MIXED; BOUNDARY="8323328-1091088405-1260940899=:28497"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1091088405-1260940899=:28497
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Tue, 15 Dec 2009, J.A. Magallón wrote:

> On Mon, 14 Dec 2009 22:00:25 -0500 (EST), Len Brown <lenb@kernel.org> wrote:
> 
> > this DSDT returns a constant temperature, always:
> > 
> >             Method (_TMP, 0, NotSerialized)
> >             {
> >                 Return (0x0BB8)
> >             }
> > 
> > 
> > so in this case, Linux is just reporting the (lack of) news:-)
> > 
> 
> So, lets see...:
> 
> - Someone decided ACPI is the only-real-good-way
> - Only a few devices are ported to ACPI
> - The old way is unusable
> - We can not return to the old way
> 
> So, any solution ? Thermal ACPI info in this boards (and I suspect in many
> others) is useless. We can not disable that part of ACPI, we can not enable
> sensors. So no thermal monitoring.
> Nice.
> 
> Ayways, as in this case the ACPI part does not any real work, is still
> present the problem of two drivers poking the same hardware or could I use
> that 'lax' trick ?
> 
> And second, can the traditional sensor drivers be ported to offer an ACPI
> device replacing the default one, or is that a stupid question ?
> 

Check, for an updated BIOS from the vendor.
If there is none, then express your displeasure to the vendor
and consider a different one for your next purchase.

For the box you have, try "acpi_enforce_resources=lax"
and load your native sensor driver.
Likely you'll be happy with that -- I just can't guarantee it.

cheers,
-Len Brown, Intel Open Source Technology Center


--8323328-1091088405-1260940899=:28497--
