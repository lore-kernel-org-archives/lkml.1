Return-Path: <linux-kernel-owner+w=401wt.eu-S932314AbXH0WvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314AbXH0WvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 18:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752494AbXH0WvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 18:51:06 -0400
Received: from mail0.lsil.com ([147.145.40.20]:64092 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780AbXH0WvD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 18:51:03 -0400
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] mptsas: scan the logical volume at first
Date: Mon, 27 Aug 2007 16:50:52 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D709409DF@NAMAIL4.ad.lsil.com>
In-Reply-To: <46D3557C.9010500@sun.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] mptsas: scan the logical volume at first
Thread-Index: Acfo+9GsY0UbJ8SUSQKc70atEpWObAAAJLGQ
From: "Moore, Eric" <Eric.Moore@lsi.com>
To: <Yinghai.Lu@Sun.COM>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Prakash, Sathya" <Sathya.Prakash@lsi.com>,
       "James Bottomley" <James.Bottomley@steeleye.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       <linux-scsi@vger.kernel.org>
X-OriginalArrivalTime: 27 Aug 2007 22:50:53.0252 (UTC) FILETIME=[B8C2B840:01C7E8FC]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 27, 2007 4:52 PM,  Yinghai Lu wrote:
> Yes, I was wondering why kernel.org mainline will have 
> /dev/sdb for first raid. but it seems RHEL 5 kernel have 
> first raid before second raid...( it 
> after all left over raw devices..), maybe they already aplied 
> some patch?
> 
> can you send out patch?
> 

That is not necessary, as we have already implemented the change to sort
volumes in acsending order to Red hat and Suse, and its been accepted.
I will post the change to lsml.

Eric
