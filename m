Return-Path: <linux-kernel-owner+w=401wt.eu-S1752595AbXJ2TWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbXJ2TWE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 15:22:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbXJ2TVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 15:21:53 -0400
Received: from smtp-out.google.com ([216.239.45.13]:20942 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbXJ2TVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 15:21:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:references:in-reply-to:content-type:content-transfer-encoding;
	b=EloYCCYunXH2o905kEfrczQS7r/WOHvn1WeUQR+YcLpZ2X56hYkJBKz5JXOE7GTFY
	oQjMoZBz6RtkGzjoUopsw==
Message-ID: <472631FE.9070003@google.com>
Date: Mon, 29 Oct 2007 12:18:22 -0700
From: Mike Waychison <mikew@google.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Zach Brown <zab@zabbo.net>
CC: Chris Mason <chris.mason@oracle.com>, Anton Altaparmakov <aia21@cam.ac.uk>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/6][RFC] Cleanup FIBMAP
References: <20071026233732.568575496@crlf.corp.google.com>	<E579083F-FED3-4990-8E24-275ED38E9E3B@cam.ac.uk> <20071029101001.4378a7cf@think.oraclecorp.com> <47260AB1.9000003@zabbo.net>
In-Reply-To: <47260AB1.9000003@zabbo.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zach Brown wrote:
>>> And another of my pet peeves with ->bmap is that it uses 0 to mean  
>>> "sparse" which causes a conflict on NTFS at least as block zero is  
>>> part of the $Boot system file so it is a real, valid block...  NTFS  
>>> uses -1 to denote sparse blocks internally.
>> Reiserfs and Btrfs also use 0 to mean packed.  It would be nice if there
>> was a way to indicate your-data-is-here-but-isn't-alone.  But that's
>> more of a feature for the FIEMAP stuff.
> 
> And maybe we can step back and see what the callers of FIBMAP are doing
> with the results they're getting.
> 
> One use is to discover the order in which to read file data that will
> result in efficient IO.
> 
> If we had an interface specifically for this use case then perhaps a
> sparse block would be better reported as the position of the inode
> relative to other data blocks.  Maybe the inode block number in ext* land.
> 

Can you clarify what you mean above with an example?  I don't really follow.

Thanks,

Mike Waychison


