Return-Path: <linux-kernel-owner+w=401wt.eu-S933865AbXDASoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933865AbXDASoA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 14:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933860AbXDASoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 14:44:00 -0400
Received: from smtpout.mac.com ([17.250.248.184]:64321 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933865AbXDASn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 14:43:58 -0400
In-Reply-To: <1714123823@web.de>
References: <1714123823@web.de>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <6BD015BC-3F6A-4839-9A66-DB2E322F5B74@mac.com>
Cc: Ken Chen <kenchen@google.com>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [patch] remove artificial software max_loop limit
Date: Sun, 1 Apr 2007 14:43:52 -0400
To: devzero@web.de
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 01, 2007, at 14:36:11, devzero@web.de wrote:
>> Blame on the dual meaning of max_loop that it uses currently: to
>> initialize a set of loop devices and as a side effect, it also sets
>> the upper limit.  People are complaining about the former constrain,
>> isn't it?  Does anyone uses the 2nd meaning of upper limit?
>>
>> - Ken
>
> what sense would it make to set an upper limit at all?
>
> we`re so happy to have none anymore :)

Well, the point of an upper limit might be to keep loop devices from  
chewing up too much memory on a system.  IE: To fail allocating more  
loopdevs before you run OOM and start killing random userspace  
processes.

Cheers,
Kyle Moffett

