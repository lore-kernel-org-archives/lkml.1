Return-Path: <linux-kernel-owner+w=401wt.eu-S1759494AbXJYRGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759494AbXJYRGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 13:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbXJYRGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 13:06:16 -0400
Received: from mx1.suse.de ([195.135.220.2]:58551 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753827AbXJYRGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 13:06:15 -0400
From: Andi Kleen <ak@novell.com>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 1/3 -v4] x86_64 EFI runtime service support: EFI basic runtime service support
Date: Thu, 25 Oct 2007 19:06:09 +0200
User-Agent: KMail/1.9.6
Cc: Thomas Gleixner <tglx@linutronix.de>, "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
References: <1193295473.23935.202.camel@caritas-dev.intel.com> <alpine.LFD.0.9999.0710251800250.3186@localhost.localdomain> <m1r6jj5e27.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1r6jj5e27.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710251906.10210.ak@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Especially for accessing the real time clock that has a well
> defined hardware interface going through efi an additional
> software emulation layer looks like asking for trouble.

I agree it's pointless for the hardware clock, but EFI 
also offers services to write some data to the CMOS RAM
which could be very useful to save oops data over reboot.
I don't think this can be done safely otherwise 
without BIOS cooperation.

-Andi
