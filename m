Return-Path: <linux-kernel-owner+w=401wt.eu-S1758547AbZAMSXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758547AbZAMSXV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 13:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbZAMSXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 13:23:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:57010 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754199AbZAMSXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 13:23:04 -0500
Date: Tue, 13 Jan 2009 19:22:59 +0100
From: Olaf Dabrunz <od@suse.de>
To: Stefan Assmann <sassmann@suse.de>
Cc: Jon Masters <jcm@redhat.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Olaf Dabrunz <od@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Sven Dietrich <sdietrich@novell.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: PCI, ACPI, IRQ, IOAPIC: reroute PCI interrupt to legacy boot
	interrupt equivalent
Message-ID: <20090113182259.GN25512@suse.de>
Mail-Followup-To: Stefan Assmann <sassmann@suse.de>,
	Jon Masters <jcm@redhat.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
	Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-acpi@vger.kernel.org, Sven Dietrich <sdietrich@novell.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	"Maciej W. Rozycki" <macro@linux-mips.org>
References: <alpine.LFD.2.00.0901091743310.20020@localhost.localdomain> <496B24E5.1070804@suse.de> <200901121151.53195.bjorn.helgaas@hp.com> <1231788349.4094.21.camel@perihelion.bos.jonmasters.org> <496C9807.1010109@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <496C9807.1010109@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-Jan-09, Stefan Assmann wrote:
> Hi Jon,
> 
> Jon Masters wrote:
> > On Mon, 2009-01-12 at 11:51 -0700, Bjorn Helgaas wrote:
> >> (I added Eric, Maciej, and Jon because they participated in
> >> previous discussion here: http://lkml.org/lkml/2008/6/2/269)
> > 
> > Thanks. You know what I'd really like even more than being on the CC?
> > I'd *love* someone to post a link to documentation on how this actually
> > is supposed to work. We had to guess last time because none of the
> > public documentation actually explains this. The guys at SuSE likely
> > received some docs, but I'm not sure where from or the title thereof.
> 
> Actually, most of the Boot Interrupt patches resulted from reading the
> intel specs and observing the behavior of failing machines. We're trying
> to wrap up all the information gathered in a paper, which is pretty time
> consuming and a few steps away from being ready to publish.

We read the specs of the chips, analyzed code, put up hypotheses and
tested them. Then read the specs again, finding new hypotheses and
tested again. Also reading what you guys sent out to lkml and reading
through the public discussions for *BSD, Darwin, XEN etc. helped.
And some colleagues discussed hypotheses and solution attempts with us.

We summarized many of our end results in a presentation that we gave
internally, and I am working on making this available online (in
addition to the paper/slides that Stefan mentions below).

The "real" paper still needs much work.

> > If we all knew how this was supposed to work then we might have a much
> > better likelihood of fixing this behavior. It's only going to get worse
> > over time - we want to get threaded IRQs upstream (I'm about to be
> > poking at that again over here) and that'll mean mainline has to learn
> > to deal with these boot interrupts just as much as RT does today.
> 
> At the moment I'm uploading the slides we showed at the 10th
> Real-Time Linux Workshop, which are a small, stripped down excerpt of
> our upcoming paper.
> 
> It should be available soon at:
> ftp://ftp.suse.com/pub/people/sassmann/publication/boot_irq_quirks_rtlws10.pdf
> 
> Meanwhile I'd suggest to have a look at United States Patent 6466998.
> That is intels patent for this interrupt routing mechanism.
> 
> Hope this is helpful, we'll try to make more information available asap.
> 
> > 
> > Jon.
> > 
> 
>   Stefan
> 
> -- 
> Stefan Assmann          | SUSE LINUX Products GmbH
> Software Engineer       | Maxfeldstr. 5, D-90409 Nuernberg
> Mail: sassmann@suse.de  | GF: Markus Rex, HRB 16746 (AG Nuernberg)

-- 
Olaf Dabrunz (od/odabrunz), SUSE Linux Products GmbH, Nürnberg

