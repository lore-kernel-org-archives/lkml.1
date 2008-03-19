Return-Path: <linux-kernel-owner+w=401wt.eu-S933001AbYCSUYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001AbYCSUYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621AbYCSTjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:39:31 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:47510 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbYCSTjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:39:04 -0400
Date: Wed, 19 Mar 2008 12:43:33 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jan Kara <jack@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Do not allow setting of quota limits to too high
 values
In-Reply-To: <20080319095442.GA22109@duck.suse.cz>
Message-ID: <alpine.LNX.1.00.0803191243070.12369@fbirervta.pbzchgretzou.qr>
References: <20080312172255.GB21395@duck.suse.cz> <20080313130355.6a84d0c5.akpm@linux-foundation.org> <20080317131138.GA17307@duck.suse.cz> <alpine.LNX.1.00.0803181740300.8851@fbirervta.pbzchgretzou.qr> <20080318164410.GR23104@duck.suse.cz>
 <alpine.LNX.1.00.0803182248390.8851@fbirervta.pbzchgretzou.qr> <20080319095442.GA22109@duck.suse.cz>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 19 2008 10:54, Jan Kara wrote:
>>
>> Does this also affect XFS?
>  No. All XFS quotas have in common with VFS quotas is the name of the
> syscall (quotactl()). All the rest is different and XFS has everywhere
> 64-bit fields.

Just as I thought :^)

