Return-Path: <linux-kernel-owner+w=401wt.eu-S1751993AbZEBC3D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbZEBC3D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 22:29:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbZEBC2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 22:28:50 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:38323 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142AbZEBC2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 22:28:49 -0400
MIME-Version: 1.0
In-Reply-To: <a55d774e0905011902y1827322ascd7d2eb42570d1dc@mail.gmail.com>
References: <1241097822.2516.3.camel@poy> <20090430222900.c13b63d5.akpm@linux-foundation.org> 
	<20090501061701.GB19234@kroah.com> <20090430234312.a63fa5cf.akpm@linux-foundation.org> 
	<20090501065527.GA19773@kroah.com> <a55d774e0905011824k11e06f61ibc9937a2b26fd9e0@mail.gmail.com> 
	<ac3eb2510905011848i51aef8e6wbe9506a13e67377d@mail.gmail.com> 
	<a55d774e0905011902y1827322ascd7d2eb42570d1dc@mail.gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sat, 2 May 2009 04:28:33 +0200
Message-ID: <ac3eb2510905011928o26ae45efr2b23deafda76e1fc@mail.gmail.com>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev tmpfs
To: Brian Swetland <swetland@google.com>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jan Blunck <jblunck@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 2, 2009 at 04:02, Brian Swetland <swetland@google.com> wrote:
> On Fri, May 1, 2009 at 6:48 PM, Kay Sievers <kay.sievers@vrfy.org> wrote:

>>> I would love to have a way for the kernel to do something like devfs
>>> (it'd let me kill some ugly userspace code on my side)....
>>
>> How are permissions defined in your environment? What's the set of
>> permissions you need to apply?
>
> In our world we use groups to provide access to specific classes of
> hardware resources (audio, video, display, dsp, etc) and processes
> that have the appropriate permissions are arranged to run with
> necessary additional groups for the hardware they need to access.

These group numbers are always static on your system, and don't get
changed while the system is running? Like you always assign gid X to
all sound devices? Or do you need to manage them dynamically?

Do your device nodes permissions/ownership ever change on the running
system after the device is alive?

Thanks,
Kay
