Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbZDMVaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbZDMVaX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 17:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbZDMVaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 17:30:04 -0400
Received: from gw.goop.org ([64.81.55.164]:42225 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166AbZDMVaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 17:30:03 -0400
Message-ID: <49E3AEDA.1090901@goop.org>
Date: Mon, 13 Apr 2009 14:30:02 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Xen bugfixes for -rc1
References: <49E385FE.8050902@goop.org> <20090413203518.GC19972@elte.hu>
In-Reply-To: <20090413203518.GC19972@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Hi Linus,
>>
>> Please pull this set of Xen bugfixes/cleanups for -rc[12].
>>
>> Thanks,
>>    J
>>
>> The following changes since commit 577c9c456f0e1371cbade38eaf91ae8e8a308555:
>>  Linus Torvalds (1):
>>        Linux 2.6.30-rc1
>>
>> are available in the git repository at:
>>
>>  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git for-rc1/xen/core
>>     
>
> I've pulled it into x86/urgent as well, thanks.
>
> This is a strict subset of the Xen tree i sent to Linus to earlier, 
> right?

Though it looks like d6382bf7 ("xen: disable preempt for 
leave_lazy_mmu") should have been dropped as part of the rebase.  It 
lost all its functional parts and has been reduced to removing a single 
blank line.

    J
