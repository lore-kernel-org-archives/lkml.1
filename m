Return-Path: <linux-kernel-owner+w=401wt.eu-S1752861AbZDGNgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbZDGNgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 09:36:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbZDGNfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 09:35:54 -0400
Received: from rtr.ca ([76.10.145.34]:43313 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbZDGNfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 09:35:53 -0400
Message-ID: <49DB56B8.1060805@rtr.ca>
Date: Tue, 07 Apr 2009 09:35:52 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ray Lee <ray-lk@madrabbit.org>, Hua Zhong <hzhong@gmail.com>,
       Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/8][RFC] IO latency/throughput fixes
References: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com>  <alpine.LFD.2.00.0904060803141.4023@localhost.localdomain>  <20090406151054.GD5178@kernel.dk> <alpine.LFD.2.00.0904060840080.3863@localhost.localdomain>  <20090406183157.GD7376@mit.edu> <alpine.LFD.2.00.0904061255160.4134@localhost.localdomain>  <002501c9b6f3$f85b4910$e911db30$@com> <20090406211931.GB8586@mit.edu>  <003001c9b6ff$a9259ce0$fb70d6a0$@com> <2c0942db0904061504l6504934bi446f7425fcd38470@mail.gmail.com> <alpine.LFD.2.00.0904061509020.7443@localhost.localdomain> <alpine.LFD.2.00.0904061604410.8214@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904061604410.8214@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
..
>  - If I did this right, this _only_ overrides the data mode if it's not 
>    explicitly specified on disk in the superblock mount options.
> 
> IOW, if you have done a 
> 
> 	tune2fs -o journal_data_ordered
> 
> then this will _not_ override that.
..

Thanks for saving me time to look up that command!  :)

With the stuff I work on here, kernel oops and sudden reboots
are not at all uncommon during development, and I really prefer
to keep "ordered" as the default on these machines for a tiny
extra margin of safety.

What happens with ext3 "writeback", and ext4 "whatever",
when one does the quickie reboot method:

   ALT-SYSRQ-S ALT-SYSRQ-U ALT-SYSRQ-S ALT-SYSRQ-B

???

Cheers
