Return-Path: <linux-kernel-owner+w=401wt.eu-S1758636AbXFAIjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758636AbXFAIjs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 04:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbXFAIjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 04:39:41 -0400
Received: from twin.jikos.cz ([213.151.79.26]:37532 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698AbXFAIjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 04:39:40 -0400
Date: Fri, 1 Jun 2007 10:38:51 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Anand Jahagirdar <anandjigar@gmail.com>
cc: Jens Axboe <jens.axboe@oracle.com>, security@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Patch related with Fork Bombing Atack
In-Reply-To: <25ae38200705312348r3cd02c90h5080617fa1f0a987@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706011032490.29896@twin.jikos.cz>
References: <25ae38200705310645n5e913a91weaa14521908f7989@mail.gmail.com> 
 <20070531134611.GZ32105@kernel.dk> <25ae38200705312348r3cd02c90h5080617fa1f0a987@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2007, Anand Jahagirdar wrote:

>     when they try to flood the syslog using fork bombing attack, their 
> messge will be printed only once in syslog and it will show how many 
> times it has repeated. due to this he will not able to flood the 
> syslog.and i am using only one single variable in my printk messge so it 
> is quite not possible to flood the syslog.

Your argument is flawed - if the kernel provides more than one possibility 
to flood the syslogd, the is free to invoke the events interleaved. This 
trivially prevents syslogd from grouping identical reports together.

-- 
Jiri Kosina
