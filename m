Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932685Ab0CJS2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 13:28:18 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:13138 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932655Ab0CJS2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 13:28:17 -0500
X-IronPort-AV: E=Sophos;i="4.49,615,1262581200"; 
   d="scan'208";a="87524920"
Subject: Re: [PATCH] irq: move some interrupt arch_* functions into struct
 irq_chip.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Yinghai Lu <yinghai@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, "x86@kernel.org" <x86@kernel.org>,
       "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>
In-Reply-To: <m11vfsgi13.fsf@fess.ebiederm.org>
References: <1268218524.11737.68547.camel@zakaz.uk.xensource.com>
	 <1268218559-26784-2-git-send-email-ijc@hellion.org.uk>
	 <86802c441003100406t70dd854fx491f0ee9a6fce62b@mail.gmail.com>
	 <1268225473.11737.69196.camel@zakaz.uk.xensource.com>
	 <m1iq94gjkf.fsf@fess.ebiederm.org>
	 <1268243447.11737.70807.camel@zakaz.uk.xensource.com>
	 <m11vfsgi13.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset="ISO-8859-1"
Organization: Citrix Systems, Inc.
Date: Wed, 10 Mar 2010 18:28:11 +0000
Message-ID: <1268245691.11261.38.camel@localhost.localdomain>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-10 at 18:15 +0000, Eric W. Biederman wrote: 
> Ian Campbell <Ian.Campbell@citrix.com> writes:
> 
> > On Wed, 2010-03-10 at 17:42 +0000, Eric W. Biederman wrote:
> >> 
> >> 
> >> Ian Xen in this sense is simply not x86.  irq_cfg is not acpi or
> >> ioapic or anything but x86 specific.  It has everything to do with
> >> having a per cpu vector table of 256 entries and architecturally
> >> receiving a vector number when an interrupt is fired.
> >> 
> >> It totally makes sense for Xen to do something different because
> >> architecturally it has a completely different irq subsystem.
> >
> > OK, so that sounds like you would like the same patchset but without the
> > irq_cfg renaming? or potentially with renaming to x86_blah instead (I'll
> > rework to your preference).
> 
> Currently the renaming really makes it unclear what you are doing and for
> some reason the description of the renaming rubbed me the wrong way.

Sorry, I started off a bit confused and then totally misunderstood what
related to what and I think that came through in the description.

I'll respin without the first patch.

Ian.

