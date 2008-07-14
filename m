Return-Path: <linux-kernel-owner+w=401wt.eu-S1756058AbYGNOET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbYGNOET (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 10:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbYGNOEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 10:04:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753454AbYGNOD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 10:03:59 -0400
Date: Mon, 14 Jul 2008 10:03:29 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@devserv.devel.redhat.com
To: David Miller <davem@davemloft.net>
cc: andi@firstfloor.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [SUGGESTION]: drop virtual merge accounting in I/O requests
In-Reply-To: <20080714.052859.88212003.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0807141000340.24718@devserv.devel.redhat.com>
References: <Pine.LNX.4.64.0807131947090.7803@devserv.devel.redhat.com>
 <20080713.174855.234796356.davem@davemloft.net>
 <Pine.LNX.4.64.0807140805380.10106@devserv.devel.redhat.com>
 <20080714.052859.88212003.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008, David Miller wrote:

> From: Mikulas Patocka <mpatocka@redhat.com>
> Date: Mon, 14 Jul 2008 08:16:13 -0400 (EDT)
>
>> As you mentioned ESP driver, it declares .sg_tablesize = SG_ALL, so
>> BIO_VMERGE_BOUNDARY has no effect on the operation of this driver. Any
>> other driver where BIO_VMERGE_BOUNDARY does matter?
>
> When BIO_VMERGE_BOUNDARY is turned on, requests that would not
> otherwise fit into the device's limits, can.

Why would someone want to overshoot SG_ALL? ... and, shouldn't the 
constant be increased then --- instead of making buggy BIO_VMERGE_BOUNDARY 
expectations?

Mikulas

> It's the only way to know ahead of time that the IOMMU is going
> to merge things for us.

