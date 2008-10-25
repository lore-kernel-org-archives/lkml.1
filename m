Return-Path: <linux-kernel-owner+w=401wt.eu-S1753366AbYJYPoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbYJYPoP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 11:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbYJYPn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 11:43:59 -0400
Received: from smtp-out.google.com ([216.239.33.17]:31131 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbYJYPn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 11:43:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=t2Bfa6MTjaA2HPLeJZOomTzDUgvJ6eFXn3qvW06m6lh/PRhTYw3N5XyK4CXfj6yBb
	TDeO5LUyOx9yNZ/q1TAzg==
Message-ID: <6599ad830810250843u10f65917x3388276211e90316@mail.gmail.com>
Date: Sat, 25 Oct 2008 08:43:53 -0700
From: "Paul Menage" <menage@google.com>
To: "Dong-Jae Kang" <baramsori72@gmail.com>
Subject: Re: [Question] power management related with cgroup based resource management
Cc: "Matthew Garrett" <mjg@redhat.com>, balbir@linux.vnet.ibm.com,
       xen-devel@lists.xensource.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       dm-devel@redhat.com, corsetproject@googlegroups.com,
       "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>
In-Reply-To: <2891419e0810250105j3e210df0pa3ba9665bd35313a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2891419e0810201954q57087fc8ufcaa0e42f3ca99e2@mail.gmail.com>
	 <4901B5C2.9070108@linux.vnet.ibm.com>
	 <2891419e0810240524u746b731cjcbd127fa4204bd4d@mail.gmail.com>
	 <20081024232503.GA20140@srcf.ucam.org>
	 <2891419e0810250105j3e210df0pa3ba9665bd35313a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2008 at 1:05 AM, Dong-Jae Kang <baramsori72@gmail.com> wrote:
> Thank you for your positive opinion about my question
>
> I also hope cgroup framework has good point related with power management
> I think I need more re-consideration for it. ^^
>
> How do you think about cgroup based management of new HW devices, for
> example, SSD, NVRAM and so on.
> Is there any requirement for it ?
> and is there any required work for it?
> I didn't seriously consider  about that until now.^^ so I don't have cool idea
> but, I think it is worthy to find new domain to be applied by existing
> technology

Control Groups is just a framework for associating state with
(user-created) groups of processes. So if you have a problem to solve
that involves tracking state for different processes, or applying
different behaviour to groups of processes based on that group's
state, then cgroups may well be an appropriate tool.

In the case you mention (management of new devices) that's already
somewhat covered by the existing device isolation subsystem - you can
create a cgroup that has (or doesn't have) access to particular HW
devices.

Paul
