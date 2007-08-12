Return-Path: <linux-kernel-owner+w=401wt.eu-S935654AbXHLPXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935654AbXHLPXz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 11:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758891AbXHLPXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 11:23:43 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:48676 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756766AbXHLPXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 11:23:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=m9fR8wnMCPHG6u5txhnhDmuFa+xS96eSdxom6tAS/sKjXygYlcwcKVlOKwrLXyMKqHT+oEg1hWlel9Or1LJ88WP8XMCIvMlCMHDJybCK6du0GOd2PQ4QCCoF5IyTK7HVvHdZSSk7WgLkHmlucyvvP+VQJE19nqxIwSDFOQIEBoc=
Message-ID: <46BF2573.20807@googlemail.com>
Date: Sun, 12 Aug 2007 17:21:23 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: 2.6.23-rc2-mm2
References: <20070809224254.11f42716.akpm@linux-foundation.org>	<46BC3CB1.2090503@googlemail.com>	<46BC5B75.80102@googlemail.com> <20070810093817.a9bec74f.akpm@linux-foundation.org>
In-Reply-To: <20070810093817.a9bec74f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 10 Aug 2007 14:35:01 +0200 Gabriel C <nix.or.die@googlemail.com> wrote:
> 
>> In file included from include/linux/blkdev.h:17,
>>                  from kernel/sched.c:45:
>> include/linux/bsg.h:67: warning: 'struct request_queue' declared inside parameter list
>> include/linux/bsg.h:67: warning: its scope is only this definition or declaration, which is probably not what you want
>> include/linux/bsg.h:71: warning: 'struct request_queue' declared inside parameter list
> 
> Thanks, I'll fix that up.
> 

I just realized this problem exists in mainline too , introduced by this commit :

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=a4ee0df8b3d007f0d685d38a56dc0b91e01aaaf7;hp=2cd614c8732172524c36cd5245620338928062b6
