Return-Path: <linux-kernel-owner+w=401wt.eu-S937033AbXGQXip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937033AbXGQXip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 19:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934822AbXGQXid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 19:38:33 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:7304 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934302AbXGQXic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 19:38:32 -0400
Message-ID: <469D52F4.8090909@codemonkey.ws>
Date: Tue, 17 Jul 2007 18:38:28 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: caglar@pardus.org.tr
CC: Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [GIT PULL][RESEND #2] KVM Updates for 2.6.23-rc1
References: <11846910642166-git-send-email-avi@qumranet.com> <200707180225.31160.caglar@pardus.org.tr>
In-Reply-To: <200707180225.31160.caglar@pardus.org.tr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

S.Çağlar Onur wrote:
> Hi;
>
> 17 Tem 2007 Sal tarihinde, Avi Kivity şunları yazmıştı: 
>   
>> I fixed the issue with the previous patchset.  Please provide further
>> feedback, or pull from:
>>
>>  git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git for-linus
>>
>> This contains kvm updates for the 2.6.23 merge window, including
>>     
>
> After that commit (+appArmor patchset) any guest image hangs the system 
> completely as soon as started with kvm-29 userspace. Guest images works 
> with "qemu-kvm -hda X.img -m 512 -no-kvm" works as expected
>   

Can you reproduce without the appArmor patchset?

Regards,

Anthony Liguori

> I cannot provide any more information for now causes system freezes at all and 
> netconsole not works with ipw3945 (netconsole: eth1 doesn't support polling, 
> aborting) but tomorrow i'll try with cable.
>
> If needed you can find .config and dmesg from [1], if anything else needed 
> please just say it...
>
> [1] http://cekirdek.pardus.org.tr/~caglar/kvm/
>
> Cheers
>   
> ------------------------------------------------------------------------
>
> -------------------------------------------------------------------------
> This SF.net email is sponsored by DB2 Express
> Download DB2 Express C - the FREE version of DB2 express and take
> control of your XML. No limits. Just data. Click to get it now.
> http://sourceforge.net/powerbar/db2/
> ------------------------------------------------------------------------
>
> _______________________________________________
> kvm-devel mailing list
> kvm-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/kvm-devel
>   

