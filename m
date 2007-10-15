Return-Path: <linux-kernel-owner+w=401wt.eu-S1759648AbXJOV6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759648AbXJOV6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 17:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755629AbXJOV57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 17:57:59 -0400
Received: from as3.cineca.com ([130.186.84.211]:47839 "EHLO as3.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755363AbXJOV56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 17:57:58 -0400
Message-ID: <4713E25D.6090302@users.sourceforge.net>
From: Andrea Righi <righiandr@users.sourceforge.net>
Reply-To: righiandr@users.sourceforge.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.12) Gecko/20070604 Thunderbird/1.5.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, nfs@lists.sourceforge.net
Subject: Re: [NFS] nfsd closes port 2049
References: <47139C02.9020009@cineca.it> <18195.52347.544844.155538@notabene.brown>
In-Reply-To: <18195.52347.544844.155538@notabene.brown>
X-Enigmail-Version: 0.95.0
OpenPGP: id=77CEF397;
	url=keyserver.veridis.com
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Date: Mon, 15 Oct 2007 23:57:47 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown wrote:
> On Monday October 15, a.righi@cineca.it wrote:
>> Hi all,
>>
>> I'm trying to debug a weird problem with nfsd on a 2.6.16.27-0.6-smp
>> kernel.
>>
>> 1 server: SuSE SLES 10 x86_64, config attached
>> 256 clients: RHEL4 Update 4 2.6.9-42.ELsmp x86_64
>>
>> Using nfs v3.
>>
>> The clients have been happily talking to the server for several days
>> without incident.
>>
>> The weird thing is that at a certain point the socket opened on port
>> 2049 on the NFS server is being closed for unknown reasons (or better
>> for unknown reasons for me!).
> 
> This is fixed in any release based on 2.6.16.31 or later.
> The relevant mainline patch is 
>     1a047060a99f274a7c52cfea8159e4142a14b8a7
> as below.
> So update your kernel package.

Thanks Neil, looking at the source and in my logs this seems to explain
perfectly my problem. I'll try the patch ASAP.

-Andrea
