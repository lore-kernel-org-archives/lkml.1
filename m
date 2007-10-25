Return-Path: <linux-kernel-owner+w=401wt.eu-S1756651AbXJYRIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651AbXJYRIP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 13:08:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750765AbXJYRH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 13:07:59 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:36849 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbXJYRH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 13:07:58 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Arjan van de Ven <arjan@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, Chandramouli Narayanan <mouli@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, pjones@redhat.com
Subject: Re: [PATCH 1/3 -v4] x86_64 EFI runtime service support: EFI basic runtime service support
References: <1193295473.23935.202.camel@caritas-dev.intel.com>
	<alpine.LFD.0.9999.0710251800250.3186@localhost.localdomain>
	<m1r6jj5e27.fsf@ebiederm.dsl.xmission.com>
	<20071025095639.22f6cad0@laptopd505.fenrus.org>
Date: Thu, 25 Oct 2007 11:06:36 -0600
In-Reply-To: <20071025095639.22f6cad0@laptopd505.fenrus.org> (Arjan van de
	Ven's message of "Thu, 25 Oct 2007 09:56:39 -0700")
Message-ID: <m1ir4v5dk3.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:

> On Thu, 25 Oct 2007 10:55:44 -0600
> ebiederm@xmission.com (Eric W. Biederman) wrote:
>
>> I don't think there is a compelling case for us to use any efi
>> services at this time
>
> I would almost agree with this if it wasn't for the 1 call that OS
> installers need to tell EFI about bootloader stuff; I've cc'd Peter
> Jones since he'll know better what OS installers need; if they don't
> need it after all...

Yes.  I think that is usage of the variable service.  Although
I don't know if that is actually needed.

Support for the variable service is not implemented in this
patchset.

Eric
