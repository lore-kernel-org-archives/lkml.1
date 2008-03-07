Return-Path: <linux-kernel-owner+w=401wt.eu-S1756608AbYCGHcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608AbYCGHcd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 02:32:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbYCGHcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 02:32:23 -0500
Received: from dwdmx4.dwd.de ([141.38.3.230]:35826 "EHLO dwdmx4.dwd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbYCGHcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 02:32:22 -0500
Date: Fri, 7 Mar 2008 07:32:21 +0000 (GMT)
From: Holger Kiehl <Holger.Kiehl@dwd.de>
X-X-Sender: kiehl@diagnostix.dwd.de
To: Greg KH <gregkh@suse.de>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Alexey Dobriyan <adobriyan@sw.ru>,
       linux-kernel <linux-kernel@vger.kernel.org>, vatsa@linux.vnet.ibm.com,
       mingo@elte.hu
Subject: Re: sysfs: duplicate filename '74' can not be created
In-Reply-To: <20080304192435.GA5525@suse.de>
Message-ID: <Pine.LNX.4.64.0803070728290.22139@diagnostix.dwd.de>
References: <20080304160940.GC19059@localhost.sw.ru> <20080304163339.GA11160@linux.vnet.ibm.com>
 <20080304192435.GA5525@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2008, Greg KH wrote:

> On Tue, Mar 04, 2008 at 10:03:39PM +0530, Dhaval Giani wrote:
>> On Tue, Mar 04, 2008 at 07:09:40PM +0300, Alexey Dobriyan wrote:
>>> [Cc'ing /sys/kernel/uids guys]
>>>
>>
>> [Also adding gregkh to the cc :)]
>>
>>>> Mar  3 13:50:01 helena kernel: sysfs: duplicate filename '74' can not be created
>>>> Mar  3 13:50:01 helena kernel: WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
>>>> Mar  3 13:50:01 helena kernel: Pid: 21911, comm: sshd Not tainted 2.6.24.3 #1
>
> What kernel version is this?  2.6.24 had lots of "issues" with the uids
> code, I'm amazed it worked at all :)
>
If that is so, would it not be better to disable this code in the stable
branch, at least don't set it as default? Or maybe mark this as experimental?

Holger

