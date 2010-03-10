Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672Ab0CJS16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 13:27:58 -0500
Received: from claw.goop.org ([74.207.240.146]:59260 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932639Ab0CJS1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 13:27:55 -0500
Message-ID: <4B97E4A7.6060501@goop.org>
Date: Wed, 10 Mar 2010 10:27:51 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.3
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Ian Campbell <Ian.Campbell@citrix.com>, Yinghai Lu <yinghai@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, "x86@kernel.org" <x86@kernel.org>,
       "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH] irq: move some interrupt arch_* functions into struct
 irq_chip.
References: <1268218524.11737.68547.camel@zakaz.uk.xensource.com>	<1268218559-26784-2-git-send-email-ijc@hellion.org.uk>	<86802c441003100406t70dd854fx491f0ee9a6fce62b@mail.gmail.com>	<1268225473.11737.69196.camel@zakaz.uk.xensource.com> <m1iq94gjkf.fsf@fess.ebiederm.org>
In-Reply-To: <m1iq94gjkf.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2010 09:42 AM, Eric W. Biederman wrote:
> All we need between the Xen and the rest of x86 is a convention
> so that we never manage the same irqs.   At least for domU we are
> in an either/or situation so I don't see even that being a problem.
>    

Dom0 too.  This is part of the work implementing what we discussed a 
while back - Xen now completely owns the local and IO apics, so dom0 
only deals with Xen, not the hardware.  Xen has a completely different 
interrupt setup path, but at least it isn't a mishmash of Xen stuff and 
native APIC stuff.

     J
