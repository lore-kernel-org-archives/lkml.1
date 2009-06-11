Return-Path: <linux-kernel-owner+w=401wt.eu-S1755819AbZFKRby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819AbZFKRby (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 13:31:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbZFKRbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 13:31:46 -0400
Received: from sandeen.net ([209.173.210.139]:20567 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782AbZFKRbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 13:31:46 -0400
Message-ID: <4A313F84.20900@sandeen.net>
Date: Thu, 11 Jun 2009 12:31:48 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Kernel 2.6.30: Memory/XFS leak, OOM killer kills many processes
References: <alpine.DEB.2.00.0906111158470.2563@p34.internal.lan> <alpine.DEB.2.00.0906111255280.6809@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.00.0906111255280.6809@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> 
> On Thu, 11 Jun 2009, Justin Piszcz wrote:
> 
>> Hello,
>>
>> I have a daily cron that backs up my root filesystem using xfsdump, it has 
>> remain unchanged for at least 7-10 kernel versions.  When I migrated to 
>> 2.6.30, when the xfsdump ran at its scheduled time, nearly all of my 
>> processes were killed due to an OOM situation, I can reproduce the situation.
>>
>> Kernel: 2.6.30
>> Dist: Debian Testing
>> xfsdump: 2.2.48-1
> 
> Kernel 2.6.29.4 does not exhibit this problem:
> 
> xfsdump: estimated dump size: 8694781376 bytes
> xfsdump: creating dump session media file 0 (media 0, file 0)
> xfsdump: dumping ino map
> xfsdump: dumping directories
> xfsdump: dumping non-directory files
> xfsdump: ending media file
> xfsdump: media file size 8294709848 bytes
> xfsdump: dump size (non-dir files) : 8208863560 bytes
> xfsdump: dump complete: 102 seconds elapsed
> xfsdump: Dump Status: SUCCESS
> 
> XFS(?) bug in 2.6.30.

Any chance for a bisect run? :)

Or, just as a thought, watch slabtop while you run the dump?

-Eric
