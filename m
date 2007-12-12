Return-Path: <linux-kernel-owner+w=401wt.eu-S1757532AbXLLHaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532AbXLLHaY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 02:30:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754253AbXLLHaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 02:30:11 -0500
Received: from ext-ch1gw-7.online-age.net ([64.37.194.15]:50256 "EHLO
	ext-ch1gw-7.online-age.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754248AbXLLHaJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 02:30:09 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: Re: [PATCH 1/1] fix 2.6.24-rc1 nfs_file_mmap change for NOMMU
Date: Wed, 12 Dec 2007 08:29:52 +0100
Message-ID: <050A770C1DB41144817F02E395E493105257D4@FLRMLVEM02.e2k.ad.ge.com>
In-reply-to: <1197427230.27750.3.camel@heimdal.trondhjem.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/1] fix 2.6.24-rc1 nfs_file_mmap change for NOMMU
Thread-Index: Acg8aGP/ofUyUTeqTcCVWqibuXTP1gAKBVYg
References: <050A770C1DB41144817F02E395E493104CE014@FLRMLVEM02.e2k.ad.ge.com> <1197427230.27750.3.camel@heimdal.trondhjem.org>
From: "Berkhan, Enrik (GE Infra, Oil & Gas)" <enrik.berkhan@ge.com>
To: "Trond Myklebust" <trond.myklebust@fys.uio.no>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 12 Dec 2007 07:30:06.0773 (UTC) FILETIME=[D17E4650:01C83C90]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust wrote:
> On Sun, 2007-12-09 at 19:52 +0100, Berkhan, Enrik (GE Infra, Oil & Gas)
> wrote:
>> - generic_file_mmap returns -ENOSYS for NOMMU systems; replicate this  
>> behaviour 
> 
> Why do that after going through the process of revalidating the inode
> etc.? Just replace nfs_file_mmap() with a function returning ENOSYS in
> the case of CONFIG_MMU.
> 
> Better still, in the case of CONFIG_MMU, instead of having an
> nfs_file_mmap(), just replace the .mmap field in nfs_file_operations
> with a call to generic_file_mmap().

I just tried to make it work without really knowing what I do :)

I have mailed another patch implementing your second suggestion (the system
still boots with nfsroot).

Enrik
