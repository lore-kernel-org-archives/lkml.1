Return-Path: <linux-kernel-owner+w=401wt.eu-S1757387AbYHSVKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387AbYHSVKg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 17:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752719AbYHSVK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 17:10:26 -0400
Received: from wbmler2.mail.xerox.com ([13.13.138.217]:47486 "EHLO
	wbmler2.mail.xerox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbYHSVK0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 17:10:26 -0400
X-Xerox-Source-Ip: 13.151.210.15
X-Xerox-Source-Name: usa7061gw002.na.xerox.net
X-Xerox-Reported-Name: USA7061GW002.na.xerox.net
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [linux-pm] Power management for SCSI
Date: Tue, 19 Aug 2008 17:08:58 -0400
Message-ID: <556445368AFA1C438794ABDA8901891C09532734@USA0300MS03.na.xerox.net>
In-Reply-To: <Pine.LNX.4.44L0.0808131636400.2144-100000@iolanthe.rowland.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [linux-pm] Power management for SCSI
Thread-Index: Acj9hMdd4YoWXr9BQdmkLeoNIZuPgAEuqcOw
References: <556445368AFA1C438794ABDA8901891C094876DA@USA0300MS03.na.xerox.net> <Pine.LNX.4.44L0.0808131636400.2144-100000@iolanthe.rowland.org>
From: "Leisner, Martin" <Martin.Leisner@xerox.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Cc: "Oliver Neukum" <oneukum@suse.de>,
       "Linux-pm mailing list" <linux-pm@lists.osdl.org>,
       "kernel list" <linux-kernel@vger.kernel.org>, <teheo@novell.com>,
       <James.Bottomley@hansenpartnership.com>, "Pavel Machek" <pavel@suse.cz>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>
X-OriginalArrivalTime: 19 Aug 2008 21:09:00.0433 (UTC) FILETIME=[CD1F1010:01C9023F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Being able to drop power on the disk on demand is a useful concept.

We do it, but need a number of custom patches in a number of places.

When the system WANTS to access the disk, it does what is necessary to
get the disk to spin up...

I'm not sure dropping disk power in a control way should trigger a
hot-plug
event --if everyone EXPECTS it.

I'm just looking for a more generic way to enable this...I'm going to be
looking a 2.6.26/27 for this soon...

marty

>   -----Original Message-----
>   From: Alan Stern [mailto:stern@rowland.harvard.edu]
>   Sent: Wednesday, August 13, 2008 4:39 PM
>   To: Leisner, Martin
>   Cc: Oliver Neukum; Linux-pm mailing list; kernel list;
teheo@novell.com;
>   James.Bottomley@hansenpartnership.com; Pavel Machek; Stefan Richter
>   Subject: RE: [linux-pm] Power management for SCSI
>   
>   On Wed, 13 Aug 2008, Leisner, Martin wrote:
>   
>   > Regarding these scsi suspend patches, there's a general
>   > problem to drop power on disk devices on a running system.
>   > I discussed it in:
>   >
>   > http://www.gossamer-threads.com/lists/linux/kernel/811598
>   
>   There's a much worse problem which that thread completely ignored:
>   
>   When you turn off power to a disk device, to the system it looks
like a
>   hot-unplug event.  Any mounted filesystems or memory mappings on
that
>   disk will be lost.
>   
>   Alan Stern

