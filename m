Return-Path: <linux-kernel-owner+w=401wt.eu-S1759024AbXEXMxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759024AbXEXMxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 08:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756528AbXEXMxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 08:53:33 -0400
Received: from il.qumranet.com ([82.166.9.18]:45076 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756420AbXEXMxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 08:53:32 -0400
Message-ID: <46558ACB.1080000@qumranet.com>
Date: Thu, 24 May 2007 15:53:31 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: kvm-devel@lists.sourceforge.net
CC: linux-kernel@vger.kernel.org, lhcs-devel@lists.sourceforge.net
Subject: Re: [kvm-devel] [PATCH 0/7] KVM: Suspend and cpu hotplug fixes
References: <1180008615579-git-send-email-avi@qumranet.com>
In-Reply-To: <1180008615579-git-send-email-avi@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> The following patchset makes kvm more robust wrt cpu hotunplug, and
> makes suspend-to-ram actually work.  Suspend-to-disk benefits from
> the cpu hotunplug improvements as well.
>
>   

Here's the patchset diffstat in case anyone's interested:

 arch/i386/kernel/cpu/mcheck/therm_throt.c |    6 ++-
 drivers/kvm/kvm_main.c                    |   51 
+++++++++++++++++++++--------
 include/linux/notifier.h                  |    3 ++
 include/linux/smp.h                       |   15 ++++++++
 kernel/cpu.c                              |   16 ++++++++-
 kernel/cpuset.c                           |    3 ++
 kernel/softirq.c                          |   24 +++++++++++++
 7 files changed, 100 insertions(+), 18 deletions(-)


-- 
error compiling committee.c: too many arguments to function

