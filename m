Return-Path: <linux-kernel-owner+w=401wt.eu-S1760625AbZAMNdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760625AbZAMNdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 08:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760439AbZAMNdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 08:33:00 -0500
Received: from cantor.suse.de ([195.135.220.2]:43738 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757605AbZAMNc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 08:32:59 -0500
Message-ID: <496C9807.1010109@suse.de>
Date: Tue, 13 Jan 2009 14:32:55 +0100
From: Stefan Assmann <sassmann@suse.de>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Jon Masters <jcm@redhat.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Olaf Dabrunz <od@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Sven Dietrich <sdietrich@novell.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: PCI, ACPI, IRQ, IOAPIC: reroute PCI interrupt to legacy boot
 interrupt equivalent
References: <alpine.LFD.2.00.0901091743310.20020@localhost.localdomain>	 <496B24E5.1070804@suse.de>  <200901121151.53195.bjorn.helgaas@hp.com> <1231788349.4094.21.camel@perihelion.bos.jonmasters.org>
In-Reply-To: <1231788349.4094.21.camel@perihelion.bos.jonmasters.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jon,

Jon Masters wrote:
> On Mon, 2009-01-12 at 11:51 -0700, Bjorn Helgaas wrote:
>> (I added Eric, Maciej, and Jon because they participated in
>> previous discussion here: http://lkml.org/lkml/2008/6/2/269)
> 
> Thanks. You know what I'd really like even more than being on the CC?
> I'd *love* someone to post a link to documentation on how this actually
> is supposed to work. We had to guess last time because none of the
> public documentation actually explains this. The guys at SuSE likely
> received some docs, but I'm not sure where from or the title thereof.

Actually, most of the Boot Interrupt patches resulted from reading the
intel specs and observing the behavior of failing machines. We're trying
to wrap up all the information gathered in a paper, which is pretty time
consuming and a few steps away from being ready to publish.

> If we all knew how this was supposed to work then we might have a much
> better likelihood of fixing this behavior. It's only going to get worse
> over time - we want to get threaded IRQs upstream (I'm about to be
> poking at that again over here) and that'll mean mainline has to learn
> to deal with these boot interrupts just as much as RT does today.

At the moment I'm uploading the slides we showed at the 10th
Real-Time Linux Workshop, which are a small, stripped down excerpt of
our upcoming paper.

It should be available soon at:
ftp://ftp.suse.com/pub/people/sassmann/publication/boot_irq_quirks_rtlws10.pdf

Meanwhile I'd suggest to have a look at United States Patent 6466998.
That is intels patent for this interrupt routing mechanism.

Hope this is helpful, we'll try to make more information available asap.

> 
> Jon.
> 

  Stefan

-- 
Stefan Assmann          | SUSE LINUX Products GmbH
Software Engineer       | Maxfeldstr. 5, D-90409 Nuernberg
Mail: sassmann@suse.de  | GF: Markus Rex, HRB 16746 (AG Nuernberg)
