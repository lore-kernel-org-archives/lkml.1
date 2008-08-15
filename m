Return-Path: <linux-kernel-owner+w=401wt.eu-S1757565AbYHONSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565AbYHONSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 09:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753121AbYHONSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 09:18:17 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:42790 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106AbYHONSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 09:18:16 -0400
In-Reply-To: <2629CC4E1D22A64593B02C43E855530304AE4BF6@USILMS12.ca.com>
To: "Press, Jonathan" <Jonathan.Press@ca.com>
Cc: alan@lxorguk.ukuu.org.uk, andi@firstfloor.org,
       Arjan van de Ven <arjan@infradead.org>, hch@infradead.org,
       "Helge Hafting" <helge.hafting@aitel.hist.no>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       "Peter Zijlstra" <peterz@infradead.org>, viro@ZenIV.linux.org.uk
Subject: Re: [malware-list] TALPA - a threat model?  well sorta.
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.2 September 26, 2006
From: douglas.leeder@sophos.com
Date: Fri, 15 Aug 2008 14:18:12 +0100
X-MIMETrack: S/MIME Sign by Notes Client on Douglas Leeder/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 2008-08-15 14:18:10,
	Serialize by Notes Client on Douglas Leeder/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 2008-08-15 14:18:10,
	Serialize complete at 2008-08-15 14:18:10,
	S/MIME Sign failed at 2008-08-15 14:18:10: The cryptographic key was not
 found,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 15/08/2008 14:18:15,
	Serialize complete at 15/08/2008 14:18:15
Content-Type: text/plain; charset="US-ASCII"
Message-Id: <20080815131820.053BF31679D@pmx1.sophos.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Press wrote on 2008-08-15 14:10:21:

> > -----Original Message-----
> > From: malware-list-bounces@dmesg.printk.net [mailto:malware-list-
> > bounces@dmesg.printk.net] On Behalf Of Peter Zijlstra
> > Sent: Friday, August 15, 2008 6:37 AM
> > To: Helge Hafting
> > Cc: linux-kernel@vger.kernel.org; malware-list@lists.printk.net;
> hch@infradead.org;
> > andi@firstfloor.org; viro@ZenIV.linux.org.uk;
> alan@lxorguk.ukuu.org.uk; Arjan van
> > de Ven
> > Subject: Re: [malware-list] TALPA - a threat model? well sorta.
> > 
> > On Fri, 2008-08-15 at 12:07 +0200, Helge Hafting wrote:
> > > It seems to me that this "scan on file open" business is the
> > > wrong way to do things - because it reduces performance.
> > >
> > > If you scan on file open, then your security sw is too late and
> > > getting in the way.
> 
> The problem is that you have to account for the cases where the malware
> made it onto the system even if you were trying to catch it ahead of
> time.  For example:
> 
> - Administrator turns off or reduces AV protection for some reason for
> some period of time.  It happens all the time.
> 
> - New infection makes it onto the machine before the signatures have
> caught up with it.  This also happens.  There is an ongoing PR race
> among AV vendors about who was faster on the draw to get out signatures
> to detect some new malware.  The fact that this race exists reflects
> that reality that there is some window during which new malware will
> make it onto some number of machines before the scanners catch up.
> 

Not to mention removable media - it might be old hat, but infected/malware
files can come in on floppies, CDs or USB flash discs careless left on the
pavement outside an office.

-- 
Douglas Leeder

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon,
OX14 3YP, United Kingdom.

Company Reg No 2096520. VAT Reg No GB 348 3873 20.

