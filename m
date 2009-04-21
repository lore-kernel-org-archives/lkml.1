Return-Path: <linux-kernel-owner+w=401wt.eu-S1754234AbZDUUIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbZDUUIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 16:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbZDUUIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 16:08:39 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:3180 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbZDUUIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 16:08:38 -0400
Message-ID: <49EE27C2.3060505@codemonkey.ws>
Date: Tue, 21 Apr 2009 15:08:34 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Huang Ying <ying.huang@intel.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2] Add MCE support to KVM
References: <1239953345.6842.3.camel@yhuang-dev.sh.intel.com> <49E9F7BE.4090904@codemonkey.ws> <49EAE334.9020803@redhat.com> <49EDF057.9060501@codemonkey.ws> <49EDF287.9020908@redhat.com> <49EE2497.3060009@codemonkey.ws> <49EE25CB.6070709@redhat.com>
In-Reply-To: <49EE25CB.6070709@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> No argument.  But some kernel features will require major rework in 
> qemu before we can support them properly.  We'll still want to bring 
> them to users quickly so users can enjoy them (and we can enjoy users 
> testing them).  Waiting for a qemu rework may take a while, and we'll 
> lose valuable feedback.

Then we're failing.  If a particular implementation of a feature is 
acceptable for kvm-userspace users, and we don't take it in QEMU without 
requiring a huge amount of different work, then it suggests something is 
broken about the QEMU process.

> For this kind of work, we can provide kvm-userspace.git as a kind of 
> playground where these experiments may be made.  kvm-userspace.git 
> exists to support kvm.git; while qemu.git has a life of its own and 
> more stringent barriers to acceptance.

As long as people are using kvm-userspace.git instead of qemu.git, we're 
failing IMHO.  If kvm-userspace.git is basically the equivalent of the 
x86 git kernel tree, linux-next, or something like that, then that's a 
good thing.

Regards,

Anthony Liguori

