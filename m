Return-Path: <linux-kernel-owner+w=401wt.eu-S965309AbXCLIFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965309AbXCLIFG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 04:05:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965263AbXCLIFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 04:05:06 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:49604 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965316AbXCLIEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 04:04:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=lhY6QzDhiTN5uozYbHk2btiwng9aAMdTEO148VVWDImzU2RbxEulrFdubENL5Yq1UfR6foFpuzdH4Rw/Vj6TT3IzbGpu9edWTV+Zk/5BGra9NrtxsZpxfpNXi02l1Pl5U4LjzBtGgV43xtIVWpB6M/8fuKcJA4ikbXGOY6gSWAE=
Message-ID: <45F509A7.8030705@gmail.com>
Date: Mon, 12 Mar 2007 17:04:55 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: rol@as2917.net
CC: "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Jeff Garzik'" <jeff@garzik.org>, "'Alan Cox'" <alan@redhat.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       linux-ide@vger.kernel.org, "'LKML'" <linux-kernel@vger.kernel.org>,
       "'Eric D. Mudama'" <edmudama@gmail.com>
Subject: Re: [git patches] libata fixes
References: <001b01c7647c$921ced00$4b00a8c0@donald>
In-Reply-To: <001b01c7647c$921ced00$4b00a8c0@donald>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Rolland wrote:
>> I keep forgetting about this.  I'll ask SIMG how to deal with 
>> this.  For
>> the time being, connecting a device to the PMP port should remove the
>> timeouts.
> 
> That sounds a quite expensive solution ;)

You should be able to just move the drive attached at ata1 to ata2.
Please report whether that works.

-- 
tejun
