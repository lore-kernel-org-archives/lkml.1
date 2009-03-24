Return-Path: <linux-kernel-owner+w=401wt.eu-S1757685AbZCXP5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685AbZCXP5p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 11:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758905AbZCXP5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 11:57:20 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:36920 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbZCXP5T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 11:57:19 -0400
MIME-Version: 1.0
In-Reply-To: <20090324153329.GA13705@kroah.com>
References: <20090320004539.GF18781@kroah.com>
	 <20090320024249.GA19989@kroah.com> <4443.1237517709@jrobl>
	 <20090320030608.GA2638@kroah.com> <5142.1237521581@jrobl>
	 <20090320041811.GA3352@kroah.com> <6218.1237526149@jrobl>
	 <20090320054437.GC3993@kroah.com> <2778.1237882600@jrobl>
	 <20090324153329.GA13705@kroah.com>
Date: Tue, 24 Mar 2009 16:57:16 +0100
Message-ID: <ac3eb2510903240857l2b072ffay7c3e2e5683527a4f@mail.gmail.com>
Subject: Re: Q. DEBUG_FS and SYSFS config (Re: [RFC Aufs2 #3 2/2] split 'xino' 
	entry under sysfs)
From: Kay Sievers <kay.sievers@vrfy.org>
To: Greg KH <greg@kroah.com>
Cc: hooanon05@yahoo.co.jp, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 16:33, Greg KH <greg@kroah.com> wrote:

>> First, configure "normaly".
>> General setup
>>   [ ] Configure standard kernel features (for small systems)  --->
>>
>> $ egrep -i '(sysfs|debug_fs)' .config
>> CONFIG_SYSFS_DEPRECATED=y
>> CONFIG_SYSFS_DEPRECATED_V2=y
>
> You should disable those two options, no modern distro needs them
> anymore.

In fact, all recent distros will no longer work correctly, because
DEPRECATED disables features which are expected to be there today. I
guess it's time to remove the *_V2 hack to reset the default value,
and set the default of CONFIG_SYSFS_DEPRECATED=n?

Thanks,
Kay
