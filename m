Return-Path: <linux-kernel-owner+w=401wt.eu-S1762656AbXGZXub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762656AbXGZXub (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 19:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbXGZXuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 19:50:21 -0400
Received: from mail.tmr.com ([64.65.253.246]:49340 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbXGZXuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 19:50:20 -0400
Message-ID: <46A933A1.7050601@tmr.com>
Date: Thu, 26 Jul 2007 19:52:01 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Kyle Rose <krose@akamai.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: sk98lin for 2.6.23-rc1
References: <46A8BAD4.8020004@akamai.com>
In-Reply-To: <46A8BAD4.8020004@akamai.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Rose wrote:
> From http://www.krose.org/~krose/computing.html:
> 
> Since the sky2 driver continues to suck ass (which is a technical
> description for "it hangs all the time under load, at least on my
> hardware" :-) ), I've fixed the sk98lin driver to compile for
> linux-2.6.23-rc1. Those who continue to have problems with sky2 can
> still use 2.6.23-rc1, simply by doing the following:
> 
Bless you, extends my update capability for another version. ;-)

However, Ingo posted a patch for the thread "network dies after random 
time" which probably didn't make it into rc1. In all fairness applying 
that might fix the problem, it's possible if unlikely that the new 
driver tickles a bug the stable sk98lin driver didn't.

Does skge work for your hardware? Based on a sample size of one (four to 
go) everything worked for me except NFS, jumbo packets work with tcp, 
not with udp. I don't have everything nailed down enough for a proper 
bug report, it's just something to note. In truth there's little to 
choose between tcp and udp for machines in the same room, I could live 
with skge.

haven't tried shy2, there was a build failure on my last server build, 
won't look at it until Monday.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
