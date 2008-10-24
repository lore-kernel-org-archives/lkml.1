Return-Path: <linux-kernel-owner+w=401wt.eu-S1757881AbYJXS5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881AbYJXS5X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 14:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753816AbYJXS5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 14:57:10 -0400
Received: from mx1.moondrake.net ([212.85.150.166]:43649 "EHLO
	mx1.mandriva.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752565AbYJXS5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 14:57:08 -0400
X-Greylist: delayed 1838 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Oct 2008 14:57:08 EDT
X-Spam-Virus: No
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Pascal Terjan <pterjan@mandriva.com>
Subject: Re: [git pull] fastboot tree for v2.6.28
References: <20081010003241.GA23940@elte.hu>
	<alpine.LFD.2.00.0810101254240.3503@nehalem.linux-foundation.org>
	<20081010154929.6ec201fe@infradead.org>
	<20081011064712.GA25451@elte.hu>
	<20081011004840.5ad62ce0.akpm@linux-foundation.org>
	<20081011082845.GA28715@elte.hu> <48F0B40A.8080007@zytor.com>
From: Olivier Blin <blino@mandriva.com>
Organization: Mandriva
Date: Fri, 24 Oct 2008 20:26:26 +0200
In-Reply-To: <48F0B40A.8080007@zytor.com> (H. Peter Anvin's message of "\(unknown date\)")
Message-ID: <m363nhsvcd.fsf@dynamo.mandriva.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Ingo Molnar wrote:
>>
>> a config option is definitely useful for users and distros. Having
>> the boot option is a good idea. Arjan, i thought we had a
>> fastboot=0/1 boot option but i cannot find it - could you please add
>> it?
>
> In general, boolean options should be fastboot/nofastboot.  We have
> plenty of inconsistency in that area, but we really don't need to add
> more.

Actually, the fastboot boot option is already used in RedHat's
rc.sysinit (to skip fsck). Can't we have async_init/sync_init boot
options to control this feature?

BTW, is there already some patch available for this option?

-- 
Olivier Blin (blino) - Mandriva
