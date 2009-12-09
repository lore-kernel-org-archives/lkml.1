Return-Path: <linux-kernel-owner+w=401wt.eu-S1757749AbZLIUei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749AbZLIUei (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 15:34:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757712AbZLIUee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 15:34:34 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:65109 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757688AbZLIUe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 15:34:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=NIUSjOsqt4vw6FjShNye0KzGfMQqUYvwJSg/Pb/S8kiLb32urUc9TM8chQLZ1lZf5+
         su0HYvN0bsRz7FH6hLpeDo33hvXTqcTsoR5k8gYEfLaMIYPTxFeDNJMkPHHJ3VM49HfT
         2d4tMkAsCgGAiJePcl53zpifo8ZRuFbM7NFSM=
MIME-Version: 1.0
Date: Wed, 9 Dec 2009 12:34:36 -0800
Message-ID: <86802c440912091234t74fd2311t33c85379c06dd55c@mail.gmail.com>
Subject: Re: nfs broken in net-next? -- now in mainline
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Suresh Jayaraman <sjayaraman@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 29, 2009 at 2:03 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Thu, Oct 29, 2009 at 12:23 AM, Suresh Jayaraman <sjayaraman@suse.de> wrote:
>> On 10/29/2009 01:43 AM, Yinghai Lu wrote:
>>> pk12-3214-189-102:~ # mount -t nfs 10.6.75.100:/data/shared/pxeboot /x
>>> mount.nfs: rpc.statd is not running but is required for remote locking.
>>> mount.nfs: Either use '-o nolock' to keep locks local, or start statd.
>>
>> rpc.statd on client should have be started by mount.nfs when a nfs
>> filesystem is mounted. Is this not happening for some reason or do you
>> see any errors in syslog?
>>
>>>
>>> using opensuse11.1
>>>
>>
>> Are you using 11.1 betas? I know of a problem where non-root user mounts
>> fail to start rpc.statd in betas that got fixed later:
>>
>> http://marc.info/?l=linux-nfs&m=122748525624094&w=2
>>
>> Is the problem seen only recently (after updating to net-next)?
>>
>
> only happen with net-next.
>
> linus tree and tip tree are ok.
>

Finally it reached linus tree and tip.

YH
