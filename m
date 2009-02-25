Return-Path: <linux-kernel-owner+w=401wt.eu-S1763483AbZBYXeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763483AbZBYXeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 18:34:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762550AbZBYXee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 18:34:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47218 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762542AbZBYXed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 18:34:33 -0500
Message-ID: <49A5D55A.9080402@zytor.com>
Date: Wed, 25 Feb 2009 15:33:46 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: Matthew Wilcox <matthew@wil.cx>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, sandeen@redhat.com
Subject: Re: ATA support for 4k sector size
References: <1235600698-6446-1-git-send-email-matthew@wil.cx>	<49A5CBF7.9000501@zytor.com> <yq1hc2iumg9.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1hc2iumg9.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin K. Petersen wrote:
> 
> I'll defer to people like yourself for how this needs to work wrt. boot
> loaders and creating partition tables.  I'm CC:ing Eric Sandeen because
> he's also looking at this...
> 

I wish it was left to people like myself.  Realistically when it comes 
to disks with 4096-byte logical sectors it going to matter how the 
firmware chooses to expose it.

Most likely, the universe will explode at this time, since very few 
bootloaders can deal with a sector size other than 512 bytes, and 
virtually every partition table format contains a sector size 
dependency, which also means you'll break any mechanical imaging solution.

It's going to hurt :(

	-hpa
