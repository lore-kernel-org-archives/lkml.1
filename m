Return-Path: <linux-kernel-owner+w=401wt.eu-S932786AbYBNMMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786AbYBNMMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 07:12:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758041AbYBNMMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 07:12:33 -0500
Received: from trashmail.net ([213.155.82.90]:34661 "EHLO trashmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757720AbYBNMMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 07:12:32 -0500
Message-ID: <47B430A4.2010000@trashmail.net>
Date: Thu, 14 Feb 2008 13:14:28 +0100
From: Mika Lawando <rzryyvzy@trashmail.net>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: assarix@pandora.be
Subject: Re: Is there a
References: <W8217824349298681202982295@nocme1bl6.telenet-ops.be>
In-Reply-To: <W8217824349298681202982295@nocme1bl6.telenet-ops.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tom Van Looy schrieb:
> You can create a symlink to /dev/null and name it whatever you want?
>
> $ ln -s /dev/null tempfile
> $ echo blablabla > tempfile
> $ wc tempfile
> 0 tempfile
>   
The problem is, what do you do if the filename would be:
tempfile.<TIMESTAMP>

where <TIMESTAMP> is replaced by the unix timestamp. I mean how do you 
redirect to /dev/null if you don't know in advance the filename your 
application will create.

Its true the quick way would be to write a filesystem in Perl with fuse. 
But it would be better to implement this natively in the kernel, because 
there is a loss of performance in fuse between the communication of the 
fuse client and the fuser server (it uses a socket mechanism).

-- 
Best regards,
Mika Lawando

