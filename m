Return-Path: <linux-kernel-owner+w=401wt.eu-S1756300AbZCLObF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300AbZCLObF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 10:31:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755652AbZCLOax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 10:30:53 -0400
Received: from rtr.ca ([76.10.145.34]:38385 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551AbZCLOaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 10:30:52 -0400
Message-ID: <49B91C98.4090309@rtr.ca>
Date: Thu, 12 Mar 2009 10:30:48 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Norman Diamond <n0diamond@yahoo.co.jp>
Cc: Jim Paris <jim@jtan.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Robert Hancock <hancockrwd@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: Off-by-one in both LIBATA and IDE drivers
References: <20090311015039.42922.qmail@web4115.mail.ogk.yahoo.co.jp> <20090311030340.GA617@psychosis.jim.sh> <9CEE6A51B15649D3ABEBD9BE0241A345@DIAMOND8600>
In-Reply-To: <9CEE6A51B15649D3ABEBD9BE0241A345@DIAMOND8600>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Norman Diamond wrote:
> Jim Paris wrote:
>> Norman Diamond wrote:
>>>
>>> It looks like both LIBATA and the old IDE drivers have an off-by-one 
>>> error in deciding whether to use READ SECTOR(S) instead of READ 
>>> SECTOR(S) EXT.
>>
>> This was fixed here:
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=97b697a11b07e2ebfa69c488132596cc5eb24119 
>>
> 
> I'm still having trouble after applying the same patch to 2.6.24.3 
> (applying it three times in order to build Slax).  But now I wonder if 
> it's no longer the fault of drivers.
> 
> Does hdparm construct its own taskfiles for ATA and SATA in order to 
> produce an error trying to read sector number 0x0fffffff even after I 
> patched the kernel?
..

What, *exactly*, do you mean there.
Yes, hdparm constructs its own taskfiles for the --read-sector subcommand.
Are you hitting these errors with the latest hdparm (9.12)?

???
