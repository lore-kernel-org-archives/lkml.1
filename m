Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940Ab0CJSP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 13:15:26 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:40244 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab0CJSPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 13:15:25 -0500
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, "x86\@kernel.org" <x86@kernel.org>,
       "linuxppc-dev\@ozlabs.org" <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH] irq: move some interrupt arch_* functions into struct irq_chip.
References: <1268218524.11737.68547.camel@zakaz.uk.xensource.com>
	<1268218559-26784-2-git-send-email-ijc@hellion.org.uk>
	<86802c441003100406t70dd854fx491f0ee9a6fce62b@mail.gmail.com>
	<1268225473.11737.69196.camel@zakaz.uk.xensource.com>
	<m1iq94gjkf.fsf@fess.ebiederm.org>
	<1268243447.11737.70807.camel@zakaz.uk.xensource.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 10 Mar 2010 10:15:20 -0800
In-Reply-To: <1268243447.11737.70807.camel@zakaz.uk.xensource.com> (Ian Campbell's message of "Wed\, 10 Mar 2010 17\:50\:47 +0000")
Message-ID: <m11vfsgi13.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: Ian.Campbell@citrix.com, linuxppc-dev@ozlabs.org, x86@kernel.org, paulus@samba.org, benh@kernel.crashing.org, jeremy@goop.org, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org, yinghai@kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell <Ian.Campbell@citrix.com> writes:

> On Wed, 2010-03-10 at 17:42 +0000, Eric W. Biederman wrote:
>> 
>> 
>> Ian Xen in this sense is simply not x86.  irq_cfg is not acpi or
>> ioapic or anything but x86 specific.  It has everything to do with
>> having a per cpu vector table of 256 entries and architecturally
>> receiving a vector number when an interrupt is fired.
>> 
>> It totally makes sense for Xen to do something different because
>> architecturally it has a completely different irq subsystem.
>
> OK, so that sounds like you would like the same patchset but without the
> irq_cfg renaming? or potentially with renaming to x86_blah instead (I'll
> rework to your preference).

Currently the renaming really makes it unclear what you are doing and for
some reason the description of the renaming rubbed me the wrong way.

Eric
