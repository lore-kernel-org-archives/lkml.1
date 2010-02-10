Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411Ab0BJIwB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 03:52:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763Ab0BJIwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 03:52:00 -0500
Message-ID: <4B72738A.4070300@redhat.com>
Date: Wed, 10 Feb 2010 10:51:22 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: KVM list <kvm@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] KVM fixes for 2.6.33-rc7
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

   git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.33

To receive a suspend/resume kvmclock fix, and a memory corruption fix 
involving the emulated PIT.

Jason Wang (2):
       Export the symbol of getboottime and mmonotonic_to_bootbased
       kvmclock: count total_sleep_time when updating guest clock

Marcelo Tosatti (1):
       KVM: PIT: control word is write-only

  arch/x86/kvm/i8254.c      |    3 +++
  arch/x86/kvm/x86.c        |    7 +++----
  kernel/time/timekeeping.c |    2 ++
  3 files changed, 8 insertions(+), 4 deletions(-)

-- 
error compiling committee.c: too many arguments to function

