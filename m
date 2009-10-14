Return-Path: <linux-kernel-owner+w=401wt.eu-S932530AbZJNWLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530AbZJNWLn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 18:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760908AbZJNWLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 18:11:42 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47134
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762022AbZJNWLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 18:11:41 -0400
Date: Wed, 14 Oct 2009 15:11:37 -0700 (PDT)
Message-Id: <20091014.151137.30359959.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, acme@redhat.com
Subject: Re: linux-next: net tree build warnings
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091014153450.3110e34c.sfr@canb.auug.org.au>
References: <20091014152000.15312908.sfr@canb.auug.org.au>
	<20091014153450.3110e34c.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 14 Oct 2009 15:34:50 +1100

> On Wed, 14 Oct 2009 15:20:00 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>
>> Today's linux-next build (powerpc ppc44x_defconfig) produced these
>> warnings:
>> 
>> In file included from net/socket.c:94:
>> include/net/compat.h:45: warning: 'struct compat_mmsghdr' declared inside parameter list
>> 
>> CONFIG_COMPAT is not set.
>> 
>> Caused by commit a2e2725541fad72416326798c2d7fa4dafb7d337 ("net:
>> Introduce recvmmsg socket syscall").
 ...
> 
> I also get these for i386 and sparc32 defconfig builds.

I've asked Arnaldo to work on fixing this.

Thanks!
