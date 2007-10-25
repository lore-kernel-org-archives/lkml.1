Return-Path: <linux-kernel-owner+w=401wt.eu-S1760034AbXJYRJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760034AbXJYRJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 13:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753769AbXJYRJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 13:09:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41459 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448AbXJYRJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 13:09:15 -0400
Message-ID: <4720CCBC.1050700@zytor.com>
Date: Thu, 25 Oct 2007 10:05:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@suse.de>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, pjones@redhat.com
Subject: Re: [PATCH 1/3 -v4] x86_64 EFI runtime service support: EFI basic
 runtime service support
References: <1193295473.23935.202.camel@caritas-dev.intel.com>	<alpine.LFD.0.9999.0710251800250.3186@localhost.localdomain>	<m1r6jj5e27.fsf@ebiederm.dsl.xmission.com> <20071025095639.22f6cad0@laptopd505.fenrus.org>
In-Reply-To: <20071025095639.22f6cad0@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
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
> 

Well, the original motivation for all of this was to enable 
implementation of a EFI framebuffer (UGA/GOP).  Now, you can say what 
you want about EFI (and I definitely have my opinion on it), but that 
seems legitimate to me.

	-hpa
