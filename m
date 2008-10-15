Return-Path: <linux-kernel-owner+w=401wt.eu-S1754110AbYJOUh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbYJOUh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 16:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077AbYJOUhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 16:37:18 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:26900 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbYJOUhR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 16:37:17 -0400
From: "Brown, John M (WGBU R&D)" <john.brown3@hp.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Len Brown <lenb@kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Date: Wed, 15 Oct 2008 20:35:54 +0000
Subject: RE: [PATCH] ACPI suspend: Blacklist HP xw4600 Workstation for old
 code ordering
Thread-Topic: [PATCH] ACPI suspend: Blacklist HP xw4600 Workstation for old
 code ordering
Thread-Index: Acku0H6Ihgb7eBEqQDWJIpnS27lNAQANKc3A
Message-ID: <C075D3D77BA5EF4FBB0939047B182ABF25C79AD3EE@GVW1144EXB.americas.hpqcorp.net>
References: <200810142254.07024.rjw@sisk.pl>
 <20081015085809.GA1061@srcf.ucam.org> <200810151605.35883.rjw@sisk.pl>
 <20081015141526.GA5633@srcf.ucam.org>
In-Reply-To: <20081015141526.GA5633@srcf.ucam.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't know the technical details behind *how* Windows copes with it, but I can tell you that it works fine on Windows.  Naturally we'd like it to work fine on Linux, too, and Rafael's blacklist fix accomplishes that.  There may be other solutions to this issue on Linux that are worth looking into, but perhaps we can accept Rafael's fix as a workaround for now.

BTW, there is probably at least one more fairly recent vintage HP workstation that will require this same fix.  My testing isn't complete yet, though.

John

-----Original Message-----
From: Matthew Garrett [mailto:mjg59@srcf.ucam.org]
Sent: Wednesday, October 15, 2008 8:15 AM
To: Rafael J. Wysocki
Cc: Len Brown; ACPI Devel Maling List; Andrew Morton; LKML; Brown, John M (WGBU R&D)
Subject: Re: [PATCH] ACPI suspend: Blacklist HP xw4600 Workstation for old code ordering

On Wed, Oct 15, 2008 at 04:05:35PM +0200, Rafael J. Wysocki wrote:
> On Wednesday, 15 of October 2008, Matthew Garrett wrote:
> > I think trying to work out what would be more useful than just
> > adding it to a blacklist.
>
> Well, machines that require the "old" ordering are simply broken,
> because you just can't assume that specific devices are not in D3
> before you execute _PTS.
>
> IOW, we aren't doing anything wrong and the BIOS is buggy.

So how does Windows cope with this?

--
Matthew Garrett | mjg59@srcf.ucam.org
