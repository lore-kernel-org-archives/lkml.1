Return-Path: <linux-kernel-owner+w=401wt.eu-S1752684AbXJ1Fam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbXJ1Fam (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 01:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751174AbXJ1FaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 01:30:23 -0400
Received: from ro-out-1112.google.com ([72.14.202.178]:1840 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbXJ1FaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 01:30:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=YKDMtN5zTXwIlo/AnIJVhlCJREXrG71PggALo2Cjv+AI4gtkMv3KAXAQm+M0JJcjVU0Nte99cn4LbXT16pGBgXCGV4RfhUGsOjD3KAcyx9YLF/1ohdBvgoS095w61b/r8ZjPoq8PIxk7TBxuIYju2YmPa7HKsd7jVPb5vib04Qk=
Date: Sun, 28 Oct 2007 13:25:19 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       jdike@karaya.com, user-mode-linux-devel@lists.sourceforge.net,
       sam@ravnborg.org
Subject: Re: UML building failed in current Linus-tree
Message-ID: <20071028052518.GC2502@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20071028032441.GB2502@hacking> <20071028034343.GV8181@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071028034343.GV8181@ftp.linux.org.uk>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2007 at 03:43:43AM +0000, Al Viro wrote:
>On Sun, Oct 28, 2007 at 11:24:41AM +0800, WANG Cong wrote:
>> 
>> Hi, Jeff, Sam!
>> 
>> I just pulled from Linus-tree, and got the following error when building uml.
>> 
>> $ make defconfig ARCH=um
>> /home/wangcong/projects/linux-2.6/arch/um/Makefile-i386:32: /home/wangcong/projects/linux-2.6/arch/i386/Makefile.cpu: No such file or directory
>> make: *** No rule to make target `/home/wangcong/projects/linux-2.6/arch/i386/Makefile.cpu'.  Stop.
>> 
>> Is this a known problem? Yesterday's Linus-tree was fine.
>
>diff --git a/arch/um/Kconfig.i386 b/arch/um/Kconfig.i386
>index 9876d80..e0ac74e 100644
>--- a/arch/um/Kconfig.i386
>+++ b/arch/um/Kconfig.i386

Thanks, Al.

With your patch, it works fine.

Jeff, could you please consider pushing this and Al's another patch[1] into
Linus-tree? UML in Linus-tree can't work for a long time. ;(

[1] http://lkml.org/lkml/2007/10/21/118

Regards.

WANG Cong

