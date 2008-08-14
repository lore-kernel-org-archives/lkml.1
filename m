Return-Path: <linux-kernel-owner+w=401wt.eu-S1758773AbYHNMDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773AbYHNMDv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 08:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753889AbYHNMDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 08:03:42 -0400
Received: from mail13.ca.com ([141.202.248.42]:5479 "EHLO mail13.ca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754275AbYHNMDl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 08:03:41 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [malware-list] TALPA - a threat model?  well sorta.
Date: Thu, 14 Aug 2008 08:03:40 -0400
Message-ID: <2629CC4E1D22A64593B02C43E855530304AE4BCB@USILMS12.ca.com>
In-Reply-To: <20080814093103.6CD102FE8B4@pmx1.sophos.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [malware-list] TALPA - a threat model?  well sorta.
Thread-Index: Acj98IxSTfagrVLVT+yfstb5VMlIZQAFNn8Q
References: <20080813192922.GI8232@mit.edu> <20080814093103.6CD102FE8B4@pmx1.sophos.com>
From: "Press, Jonathan" <Jonathan.Press@ca.com>
To: <tvrtko.ursulin@sophos.com>, "Theodore Tso" <tytso@mit.edu>
Cc: <peterz@infradead.org>, <linux-kernel@vger.kernel.org>,
       <malware-list@lists.printk.net>, <hch@infradead.org>,
       <viro@ZenIV.linux.org.uk>, <andi@firstfloor.org>,
       <malware-list-bounces@dmesg.printk.net>, <alan@lxorguk.ukuu.org.uk>,
       "Arjan van de Ven" <arjan@infradead.org>
X-OriginalArrivalTime: 14 Aug 2008 12:03:40.0699 (UTC) FILETIME=[CA931EB0:01C8FE05]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: malware-list-bounces@dmesg.printk.net [mailto:malware-list-
> bounces@dmesg.printk.net] On Behalf Of tvrtko.ursulin@sophos.com
> Sent: Thursday, August 14, 2008 5:31 AM
> To: Theodore Tso
> Cc: peterz@infradead.org; linux-kernel@vger.kernel.org; malware-
> list@lists.printk.net; hch@infradead.org; viro@ZenIV.linux.org.uk;
> andi@firstfloor.org; malware-list-bounces@dmesg.printk.net;
> alan@lxorguk.ukuu.org.uk; Arjan van de Ven
> Subject: Re: [malware-list] TALPA - a threat model? well sorta.

 
> Hm, maybe by implementing a facility with which a client can register
it's
> interface usage intent? Something like:
> 
> register(I_HAVE_NO_INTEREST_IN_CONTENT);
> register(I_WANT_TO_EXAMINE_CONTENT);
> 
> All former ones would run first because they only want to have the
> opportunity to block and do something unrelated to file content (like
> HSMs), and later group would be ran last since they want to examine
the
> content.
> 
> Ordering inside those two groups is not important because I don't see
how
> a model other than restrictive can make sense with content security
> scanning.

I'm not sure I understand why "interest in content" means not blocking,
and vice versa.  However, I think this is a good idea if made more
explicit, i.e.:

> register(BLOCK);
> register(DON'T_BLOCK);


Jon Press

