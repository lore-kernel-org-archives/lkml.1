Return-Path: <linux-kernel-owner+w=401wt.eu-S1759283AbXHHJ3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759283AbXHHJ3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 05:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753817AbXHHJ3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 05:29:47 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:24750 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbXHHJ3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 05:29:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=SFG15onpHvx2WSjuw3X5l9lsvLa9mvJlI55mAEJ1WQxXuq71DkqgOrgVvqQhF0hRnckJBRFVH1CEUF9wd5qpaXbltnaKVhch/iKAb9sfwrAOFZmmzQC8RoM9yfdpKFWGsMT1I/JpeqrTrkltlFUZ7/4pwFvve+M7xzq22HOcXVE=
Subject: Re: Disk spin down issue on shut down/suspend to disk
From: Michael Sedkowski <sedmich@gmail.com>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, trenn@suse.de,
       Tejun Heo <htejun@gmail.com>, Robert Hancock <hancockr@shaw.ca>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org
In-Reply-To: <8db1092f0708071428lde63dc7o2b422ed81797a16e@mail.gmail.com>
References: <fa.bsWpbo79BZgHoaIGhEMfTEBxs54@ifi.uio.no>
	 <8db1092f0708071309h5cf6f68bo80b44d9a2fbeabeb@mail.gmail.com>
	 <200708072233.52500.rjw@sisk.pl> <200708072241.24091.rjw@sisk.pl>
	 <8db1092f0708071428lde63dc7o2b422ed81797a16e@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Wed, 08 Aug 2007 11:29:37 +0200
Message-Id: <1186565377.4410.2.camel@nx6310>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia 07-08-2007, Wt o godzinie 23:28 +0200, Maciej Rutecki napisał(a):
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
> 
> 4. After:
> rutek:/home/maciek# /usr/sbin/smartctl --all -d ata /dev/sda | grep
> Power-Off_Retract_Count
> 192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age
> Always       -       61
> 
> (it doesn't change=61).
> 
> I wait for Michael, He has new shutdown from Sidux, and the same notebook.
> 
Same here. On suspend to disk the problem disappeared, on shut down
remained unchanged, although it is a bit faster. The emergency unload
count remain unchanged. I have the updated shut down...

