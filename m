Return-Path: <linux-kernel-owner+w=401wt.eu-S1754619AbYIZQOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbYIZQOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 12:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbYIZQOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 12:14:06 -0400
Received: from wvmler2.mail.xerox.com ([13.8.138.217]:55066 "EHLO
	wvmler2.mail.xerox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbYIZQOF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 12:14:05 -0400
X-Greylist: delayed 1195 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Sep 2008 12:14:05 EDT
X-Xerox-Source-Ip: 13.135.210.15
X-Xerox-Source-Name: usa0300gw002.na.xerox.net
X-Xerox-Reported-Name: USA0300GW002.na.xerox.net
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: disk IO directly from PCI memory to block device sectors
Date: Fri, 26 Sep 2008 11:51:34 -0400
Message-ID: <556445368AFA1C438794ABDA8901891C0999203A@USA0300MS03.na.xerox.net>
In-Reply-To: <20080926091135.GV2677@kernel.dk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: disk IO directly from PCI memory to block device sectors
Thread-Index: Ackft/EbO2XwIXgbTUmiuIadbnxwzgANi5DQ
References: <247018.46515.qm@web50603.mail.re2.yahoo.com> <20080926094653.1e0a9260@lxorguk.ukuu.org.uk> <20080926091135.GV2677@kernel.dk>
From: "Leisner, Martin" <Martin.Leisner@xerox.com>
To: "Jens Axboe" <jens.axboe@oracle.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: "marty" <martyleisner@yahoo.com>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 26 Sep 2008 15:52:33.0292 (UTC) FILETIME=[E399C4C0:01C91FEF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>   -----Original Message-----
>   From: Jens Axboe [mailto:jens.axboe@oracle.com]
>   Sent: Friday, September 26, 2008 5:12 AM
>   To: Alan Cox
>   Cc: marty; linux-kernel@vger.kernel.org; Leisner, Martin
>   Subject: Re: disk IO directly from PCI memory to block device
sectors
>   
>   On Fri, Sep 26 2008, Alan Cox wrote:
>   > > What I'm looking is for a more generic/driver independent way of
>   sticking
>   > > contents of PCI ram onto a disk.
>   >
>   > Ermm seriously why not have a userspace task with the PCI RAM
mmapped
>   > and just use write() like normal sane people do ?
>   
>   To avoid the fault and copy, I would assume.
>   
>   --
>   Jens Axboe

Also:
   a) to deal with interrupts from the hardware
   b) using legacy code/design/architecture
   
The splice approaches look very interesting...thanks...

marty
