Return-Path: <linux-kernel-owner+w=401wt.eu-S937593AbXHGWVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937593AbXHGWVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 18:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764396AbXHGWVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 18:21:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35166 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756791AbXHGWVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 18:21:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Maciej Rutecki" <maciej.rutecki@gmail.com>
Subject: Re: Disk spin down issue on shut down/suspend to disk
Date: Wed, 8 Aug 2007 00:30:51 +0200
User-Agent: KMail/1.9.5
Cc: "Michael Sedkowski" <sedmich@gmail.com>, trenn@suse.de,
       "Tejun Heo" <htejun@gmail.com>, "Robert Hancock" <hancockr@shaw.ca>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org
References: <fa.bsWpbo79BZgHoaIGhEMfTEBxs54@ifi.uio.no> <200708072241.24091.rjw@sisk.pl> <8db1092f0708071428lde63dc7o2b422ed81797a16e@mail.gmail.com>
In-Reply-To: <8db1092f0708071428lde63dc7o2b422ed81797a16e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708080030.52481.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 7 August 2007 23:28, Maciej Rutecki wrote:
> > > Well, on my box (nx6325) with the appended (experimental) patch applied
> > > on top of 2.6.23-rc1 with the patchset from
> >
> > s/2.6.23-rc1/2.6.23-rc2/
> >
> 
> HP nx 6310, _old_ shutdown 2.6.23-rc2+above patches:
> 
> 1. Before:
> rutek:/home/maciek# /usr/sbin/smartctl --all -d ata /dev/sda | grep
> Power-Off_Retract_Count
> 192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age
> Always       -       61
> 
> 2. Try suspend to disk, double spin down doesn't exist
> 
> 3. Normal shutdown, double spin down exists, BUT NOTE: I have still
> old shutdown utility from Debian package.

I should have said explicitly that my patch only affects hibernation (it
doesn't touch the normal shutdown code path).

Greetings,
Rafael
