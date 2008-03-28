Return-Path: <linux-kernel-owner+w=401wt.eu-S1758765AbYC1TOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765AbYC1TOx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 15:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758653AbYC1TOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 15:14:38 -0400
Received: from rtr.ca ([76.10.145.34]:1983 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757818AbYC1TOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 15:14:37 -0400
Message-ID: <47ED439C.9030400@rtr.ca>
Date: Fri, 28 Mar 2008 15:14:36 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/18] ide: remove broken/dangerous HDIO_[UNREGISTER,SCAN]_HWIF
 ioctls
References: <20080208004421.17746.32557.sendpatchset@localhost.localdomain> <20080208004606.17746.90799.sendpatchset@localhost.localdomain> <47EBDBAA.2020308@ru.mvista.com>
In-Reply-To: <47EBDBAA.2020308@ru.mvista.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov wrote:
> Bartlomiej Zolnierkiewicz wrote:
> 
>> hdparm explicitely marks HDIO_[UNREGISTER,SCAN]_HWIF ioctls as DANGEROUS
>> and given the number of bugs we can assume that there are no real users:
..

There is the odd user of these, actually.

But the most recent to email me (a few weeks ago),
reported that the SCAN function was no longer working on his kernel.

I'll remove the -R and -U flags completely from hdparm-8.7.

Cheers
