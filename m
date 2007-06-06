Return-Path: <linux-kernel-owner+w=401wt.eu-S1760843AbXFFQlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760843AbXFFQlO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 12:41:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754912AbXFFQlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 12:41:00 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:2400 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbXFFQk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 12:40:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=OLqBNiSZL0Clayu0/XIyuSRjJX7fClPUf0ZHFDdTycfaTXA0g0awIpR8tkOp5gilWOQ2jT+VkOr2Irxa8c5SKtAOb5RWT5/F9ZUuf0EgB3NQt3uZf0Jh6GaQh+Ya/xV42FzL9jTe7L8UD+1JPY05bAXasl/iTNvGDPCrxAnr67I=
Message-ID: <4104961b0706060940y6b43c496n6eca7099499fff58@mail.gmail.com>
Date: Thu, 7 Jun 2007 00:40:58 +0800
From: "jidong xiao" <jidong.xiao@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Question about spinlock in linux kernel
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I found there is such a kernel symbol ".text.lock.spinlock",
for example,
# cat /proc/kallsyms | grep spinlock
ffffffff8011e440 T bust_spinlocks
ffffffff802d00fc t .text.lock.spinlock
ffffffff8832ae20 d state_spinlock       [nfs]
but I can not find that who exported such a symbol?I am wondering
where is this kernel originated from? I mean, if I faced any oops,
which shows RIP is for example:
RIP: 0010:[<ffffffff8031a4d9>] <ffffffff8031a4d9>{.text.lock.spinlock+0}
then how can i locate the oops?it seems that .text.lock.spinlock is
neither a function name, nor a variable name, so i am confused, who
can help me out of here? Any advises is really really appreciated!

Regards
Jason Xiao
