Return-Path: <linux-kernel-owner+w=401wt.eu-S1753475AbYJZHy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbYJZHy5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 03:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbYJZHyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 03:54:49 -0400
Received: from ti-out-0910.google.com ([209.85.142.185]:50795 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbYJZHys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 03:54:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IV1d2OiswkQdcgdtCPQD/x2AJc4uXt8HFjziXtEPB4gd4sf45HOTkLeQNQWVuAYzL2
         jjsGrnjyyckZLJdksXzuQS9+E2qUgrKGjyByjMVIZyb83hhfrWlUqvSGboGEMbSGnXYF
         738Wx6ssETCtu71K1ts4EOtL6zRc1V/2dCHUk=
Message-ID: <2891419e0810260054p777a0602ndb4242628a7503d2@mail.gmail.com>
Date: Sun, 26 Oct 2008 16:54:45 +0900
From: "Dong-Jae Kang" <baramsori72@gmail.com>
To: "Paul Menage" <menage@google.com>
Subject: Re: [Question] power management related with cgroup based resource management
Cc: "Matthew Garrett" <mjg@redhat.com>, balbir@linux.vnet.ibm.com,
       xen-devel@lists.xensource.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       dm-devel@redhat.com, corsetproject@googlegroups.com,
       "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>
In-Reply-To: <6599ad830810250843u10f65917x3388276211e90316@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2891419e0810201954q57087fc8ufcaa0e42f3ca99e2@mail.gmail.com>
	 <4901B5C2.9070108@linux.vnet.ibm.com>
	 <2891419e0810240524u746b731cjcbd127fa4204bd4d@mail.gmail.com>
	 <20081024232503.GA20140@srcf.ucam.org>
	 <2891419e0810250105j3e210df0pa3ba9665bd35313a@mail.gmail.com>
	 <6599ad830810250843u10f65917x3388276211e90316@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Paul Menage

Thank you for your comments

> Control Groups is just a framework for associating state with
> (user-created) groups of processes. So if you have a problem to solve
> that involves tracking state for different processes, or applying
> different behaviour to groups of processes based on that group's
> state, then cgroups may well be an appropriate tool.
>
> In the case you mention (management of new devices) that's already
> somewhat covered by the existing device isolation subsystem - you can
> create a cgroup that has (or doesn't have) access to particular HW
> devices.
>
In some aspect, your opinion is right.
Existing controller(ex. disk IO controllers) can be run on new HW
devices(ex. SSD), existing block layer and so on.

but, what I mean is that such controllers can support more performance
if the controllers are rewrited with reconsideration of the features
of new HW devices. in other words, what I mean can be optimization of
controllers for new devices
For example,
In case of SSD, current IO scheduler layer is needed ? although i can
not sure about it ^^
or process sleep is needed after throwing the IO requests to storage ?
the role of page cache in SSD or NVRAM is less important than in
normal HDD and ....

I heard that many research centers in comanies and universities have
studied about smiliar research
of course, it can be OS itself, device drivers, block layer, file
systems and memory management

Under this trend,
I just wonder whether the trend can be reflected to cgroup  based
controllers or not.
and whether it is meaningful or not?
How do you think about this?
My opinion may be some humble ^^

Thank you
-- 
Best Regards,
Dong-Jae Kang
