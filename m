Return-Path: <linux-kernel-owner+w=401wt.eu-S1762699AbXJZB0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762699AbXJZB0a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 21:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757372AbXJZB0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 21:26:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:33351 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753840AbXJZB0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 21:26:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,330,1188802800"; 
   d="scan'208";a="255851649"
Subject: Re: [PATCH 1/3 -v4] x86_64 EFI runtime service support: EFI basic
	runtime service support
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, Chandramouli Narayanan <mouli@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, pjones@redhat.com
In-Reply-To: <m1ir4v5dk3.fsf@ebiederm.dsl.xmission.com>
References: <1193295473.23935.202.camel@caritas-dev.intel.com>
	 <alpine.LFD.0.9999.0710251800250.3186@localhost.localdomain>
	 <m1r6jj5e27.fsf@ebiederm.dsl.xmission.com>
	 <20071025095639.22f6cad0@laptopd505.fenrus.org>
	 <m1ir4v5dk3.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 26 Oct 2007 09:28:47 +0800
Message-Id: <1193362127.23935.233.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 26 Oct 2007 01:25:58.0725 (UTC) FILETIME=[29A07750:01C8176F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-10-25 at 11:06 -0600, Eric W. Biederman wrote:
> Arjan van de Ven <arjan@infradead.org> writes:
> 
> > On Thu, 25 Oct 2007 10:55:44 -0600
> > ebiederm@xmission.com (Eric W. Biederman) wrote:
> >
> >> I don't think there is a compelling case for us to use any efi
> >> services at this time
> >
> > I would almost agree with this if it wasn't for the 1 call that OS
> > installers need to tell EFI about bootloader stuff; I've cc'd Peter
> > Jones since he'll know better what OS installers need; if they don't
> > need it after all...
> 
> Yes.  I think that is usage of the variable service.  Although
> I don't know if that is actually needed.
> 
> Support for the variable service is not implemented in this
> patchset.

Support for the variable service has been implemented in this patchset.
The interfaces are:

efi.get_variable
efi.get_next_variable
efi.set_variable

And a sysfs interface (/sys/firmware/efi/vars) is provided in
drivers/firmware/efivars.c, which depends on this patchset to work.

Best Regards,
Huang Ying
