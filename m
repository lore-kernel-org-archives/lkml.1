Return-Path: <linux-kernel-owner+w=401wt.eu-S1759330AbYFNJwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330AbYFNJwz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 05:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756188AbYFNJwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 05:52:43 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:56567 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756023AbYFNJwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 05:52:42 -0400
Message-ID: <485394E6.9080809@garzik.org>
Date: Sat, 14 Jun 2008 05:52:38 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [0/3] POHMELFS high performance network filesystem. First steps
 in parallel processing.
References: <20080613163700.GA25860@2ka.mipt.ru>
In-Reply-To: <20080613163700.GA25860@2ka.mipt.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov wrote:
> Hi.
> 
> I'm pleased to announce POHMEL high performance network parallel
> distributed filesystem.
> POHMELFS stands for Parallel Optimized Host Message Exchange Layered File System.
> 
> Development status can be tracked in filesystem section [1].
> 
> This is a high performance network filesystem with local coherent cache of data
> and metadata. Its main goal is distributed parallel processing of data.
> 
> This release brings following features:
>  * Read requests (data read, directory listing, lookup requests) balancing
>  	between multiple servers.
>  * Write requests are sent to multiple servers and completed only
>  	when all of them sent an ack.
>  * Ability to add and/or remove servers from working set at run-time from
> 	 userspace (via netlink, so the same command can be processed from
> 	 real network though, but since server does not support it yet,
> 	 I dropped network part).
>  * Documentation (overall view and protocol commands)!
>  * Rename command (oops, forgot it in previous releases :)
>  * Several new mount options to control client behaviour instead of
> 	hardcoded numbers.
>  * Bug fixes.

Neat :)  Thanks for protocol documentation, too.  Do you plan to add 
write-pages in addition to write-page?  Also, write-page does not appear 
to be documented.

Is race-across-directories race-free?  That is a sticky area, see 
Documentation/filesystems/directory-locking in particular.

With the exception of encryption, do you think the POHMELFS client is 
mostly complete, at this point?

	Jeff


