Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932584Ab0CJRuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 12:50:52 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:37000 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932548Ab0CJRuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 12:50:51 -0500
X-IronPort-AV: E=Sophos;i="4.49,615,1262581200"; 
   d="scan'208";a="87518692"
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
In-Reply-To: <m1iq94gjkf.fsf@fess.ebiederm.org>
References: <1268218524.11737.68547.camel@zakaz.uk.xensource.com>
	 <1268218559-26784-2-git-send-email-ijc@hellion.org.uk>
	 <86802c441003100406t70dd854fx491f0ee9a6fce62b@mail.gmail.com>
	 <1268225473.11737.69196.camel@zakaz.uk.xensource.com>
	 <m1iq94gjkf.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Wed, 10 Mar 2010 17:50:47 +0000
Message-ID: <1268243447.11737.70807.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-10 at 17:42 +0000, Eric W. Biederman wrote:
> 
> 
> Ian Xen in this sense is simply not x86.  irq_cfg is not acpi or
> ioapic or anything but x86 specific.  It has everything to do with
> having a per cpu vector table of 256 entries and architecturally
> receiving a vector number when an interrupt is fired.
> 
> It totally makes sense for Xen to do something different because
> architecturally it has a completely different irq subsystem.

OK, so that sounds like you would like the same patchset but without the
irq_cfg renaming? or potentially with renaming to x86_blah instead (I'll
rework to your preference).

Ian.


