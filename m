Return-Path: <linux-kernel-owner+w=401wt.eu-S1752005AbZIVTai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbZIVTai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 15:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbZIVTai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 15:30:38 -0400
Received: from claw.goop.org ([74.207.240.146]:44951 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbZIVTah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 15:30:37 -0400
Message-ID: <4AB925DB.1070906@goop.org>
Date: Tue, 22 Sep 2009 12:30:35 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Avi Kivity <avi@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
       Alok Kataria <akataria@vmware.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
       Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       George Dunlap <George.Dunlap@eu.citrix.com>
Subject: Re: Paravirtualization on VMware's Platform [VMI].
References: <20090919224430.GB9567@kroah.com> <1253419185.3253.21.camel@ank32.eng.vmware.com> <20090920074247.GA5733@elte.hu> <20090920095239.456ad6f2@infradead.org> <4AB5EF25.9070502@redhat.com> <4AB64EFC.10707@goop.org> <20090922080913.GB1475@elte.hu> <4AB900CC.7090409@goop.org> <20090922180216.GA16789@elte.hu> <4AB91478.2050508@goop.org> <20090922190419.GA24542@elte.hu>
In-Reply-To: <20090922190419.GA24542@elte.hu>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/09 12:04, Ingo Molnar wrote:
> Sorry for being dense, but what does that mean precisely? No available 
> hardware? Xen doesnt run?

Nobody has implemented hybrid PV mode yet, so we haven't got anything to
measure.

Also, I don't think there have been very many measurements of Linux HVM
(full virtualization) Xen guests, because Linux is typically run
paravirtualized and HVM support is primarily tuned for Windows guests.

    J

