Return-Path: <linux-kernel-owner+w=401wt.eu-S1760753AbYBHWoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760753AbYBHWoA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761011AbYBHWfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:35:23 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:55929 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763736AbYBHWfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:35:19 -0500
Message-ID: <47ACD922.9040101@codemonkey.ws>
Date: Fri, 08 Feb 2008 16:35:14 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.9 (X11/20071229)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Christoph Hellwig <hch@lst.de>, bzolnier@gmail.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: current mainline ide doesn't like qemu/kvm (or vice versa)
References: <20080208152508.GA16290@lst.de> <20080208155350.733d2399@core>
In-Reply-To: <20080208155350.733d2399@core>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Fri, 8 Feb 2008 16:25:08 +0100
> Christoph Hellwig <hch@lst.de> wrote:
> 
>> When trying to put some stress on qemu by running the xfs testsuite
>> I get the following:
>>
>> debian:~/xfs-cmds/xfstests# sh check 
>> [  438.166822] SGI XFS with ACLs, security attributes, realtime, large block numbers, no debug enabled
>> [  438.185557] SGI XFS Quota Management subsystem
>> [  438.193150] hdb: task_no_data_intr: status=0x41 { DriveReady Error }
>> [  438.194018] hdb: task_no_data_intr: error=0x04 { DriveStatusError }
>> [  438.194195] ide: failed opcode was: 0x9d
> 
> Drive aborted the command. Thats all correct.
>> and after that the kernel seems to hang.  Qemu is emulating a piix3
>> device, and using the piix driver.  This is on a pretty old kvm (version
>> 28) because newer ones don't even compile.

kvm-28 is ancient and there have been IDE emulation fixes since.  I am 
not aware of issues building KVM either.  The problems you reported a 
month ago on kvm-devel have been fixed.

> Old Qemu is not really a credible IDE emulation. The chances are that as
> with all the libata bugs I close for qemu the problem is qemu. Please
> file a bug with the qemu people.

Agreed, this is very likely to be a QEMU issue (that may have already 
been fixed).

Regards,

Anthony Liguori

> -
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

