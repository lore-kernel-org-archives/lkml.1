Return-Path: <linux-kernel-owner+w=401wt.eu-S1754581AbXDXEzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbXDXEzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 00:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754582AbXDXEzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 00:55:19 -0400
Received: from amhost.net ([216.32.88.10]:46934 "EHLO ldic83.amhost.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754581AbXDXEzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 00:55:17 -0400
Message-ID: <462D8D92.9050301@amhost.net>
Date: Tue, 24 Apr 2007 07:54:42 +0300
From: Alex Vorona <voron@amhost.net>
User-Agent: Thunderbird 2.0.0.0 (X11/20070413)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: sendfile to nonblocking socket
References: <MDEHLPKNGKAHNMBLJOLKGEAJDEAC.davids@webmaster.com>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKGEAJDEAC.davids@webmaster.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Schwartz пишет:
> You have a misunderstanding about the semantics of 'sendfile'. The 'sendfile' function is just a more efficient version of a read followed by a write. If you did a read followed by a write, it would block as well (in the read).
>
> DS
>   
sendfile function is not just a more efficient version of a read 
followed by a write.  It reads from one fd and write to another at tha 
same time. Please try to read 2G, and then write 2G - and how much 
memory you will be need and how much time you will loose while reading 
2G from disk, but not writing them to socket.  If you know more 
efficient method to transfer file from disk to network - please advise. 
Now all I want is really non-blocking sendfile. Currently sendfile is 
non-blocking on network, but not on disk i/o. And when I have network 
faster than disk - I get block.

Thank you,
Alex


