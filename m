Return-Path: <linux-kernel-owner+w=401wt.eu-S1760569AbZAMNhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760569AbZAMNhS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 08:37:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbZAMNhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 08:37:04 -0500
Received: from mailout.artfiles.de ([80.252.97.80]:59968 "EHLO
	mailout.artfiles.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbZAMNhD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 08:37:03 -0500
X-Greylist: delayed 2028 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Jan 2009 08:37:03 EST
Subject: AW: 2.6.29-rc1: thinkpad problems during resume
Date: Tue, 13 Jan 2009 14:03:10 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-ID: <B4ED8DE8E195E84A872496A085BC07822EF5@exchange01.corp.win-professional.com>
In-Reply-To: <200901131342.44562.borntraeger@de.ibm.com>
Content-class: urn:content-classes:message
X-MS-Has-Attach: 
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.29-rc1: thinkpad problems during resume
Thread-Index: Acl1fN6dpSByTzkzTQmWTzb2F/PsUgAAOWiQ
References: <20090113081316.GA2292@elf.ucw.cz> <200901131239.21995.rjw@sisk.pl> <200901131342.44562.borntraeger@de.ibm.com>
From: "Morten P.D. Stevens" <mstevens@win-professional.com>
To: "Christian Borntraeger" <borntraeger@de.ibm.com>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 13 Jan 2009 13:03:11.0648 (UTC) FILETIME=[49D0B200:01C9757F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

i´ve got the same problem with 2.6.29-rc1 and a thinkpad T61p. But there is something very strange with 2.6.29-rc1-git3 it works perfectly.

-----Ursprüngliche Nachricht-----
Von: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] Im Auftrag von Christian Borntraeger
Gesendet: Dienstag, 13. Januar 2009 13:43
An: Rafael J. Wysocki
Cc: Pavel Machek; kernel list
Betreff: Re: 2.6.29-rc1: thinkpad problems during resume

Am Dienstag 13 Januar 2009 schrieb Rafael J. Wysocki:
> On Tuesday 13 January 2009, Pavel Machek wrote:
> > Hi!
> > 
> > Just when I thought long merge window means less problems...
> > 
> > ...suspend seemed to work until last tuesday or so. Now it hanged two
> > times; once so hard that power button powercycle did not result in
> > booting machine. (thinkpad x60)
> > 
> > I'll do some more tests...
> 
> There are a couple of things you may want to revert, like
> 7503bfbae89eba07b46441a5d1594647f6b8ab7d and
> a0d4922da2e4ccb0973095d8d29f36f6b1b5f703 .
> 
> Please let me know if that helped.

I tested rc1+ these two reverts yesterday on my T61p. Doesnt work. There must 
be at least one more patch that broke S2R on my thinkpad. In fact, it is cpu 
hotplug that is broken (unplug works).

I will try to bisect that as well, but currently I am busy trying to find a 
virtio regression....

Christian
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
