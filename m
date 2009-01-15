Return-Path: <linux-kernel-owner+w=401wt.eu-S1757728AbZAOPfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757728AbZAOPfP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 10:35:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754747AbZAOPeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 10:34:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:45259 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545AbZAOPes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 10:34:48 -0500
Date: Thu, 15 Jan 2009 16:34:44 +0100
From: Olaf Dabrunz <od@suse.de>
To: Stefan Assmann <sassmann@suse.de>, Jon Masters <jcm@redhat.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Sven Dietrich <sdietrich@novell.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: PCI, ACPI, IRQ, IOAPIC: reroute PCI interrupt to legacy boot
	interrupt equivalent
Message-ID: <20090115153444.GT25512@suse.de>
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
References: <alpine.LFD.2.00.0901091743310.20020@localhost.localdomain> <496B24E5.1070804@suse.de> <200901121151.53195.bjorn.helgaas@hp.com> <1231788349.4094.21.camel@perihelion.bos.jonmasters.org> <496C9807.1010109@suse.de> <20090113182259.GN25512@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090113182259.GN25512@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-Jan-09, Olaf Dabrunz wrote:
> On 13-Jan-09, Stefan Assmann wrote:
> > Hi Jon,
> > 
> > Jon Masters wrote:
> > > On Mon, 2009-01-12 at 11:51 -0700, Bjorn Helgaas wrote:
> > >> (I added Eric, Maciej, and Jon because they participated in
> > >> previous discussion here: http://lkml.org/lkml/2008/6/2/269)
> > > 
> > > Thanks. You know what I'd really like even more than being on the CC?
> > > I'd *love* someone to post a link to documentation on how this actually
> > > is supposed to work. We had to guess last time because none of the
> > > public documentation actually explains this. The guys at SuSE likely
> > > received some docs, but I'm not sure where from or the title thereof.
> > 
> > Actually, most of the Boot Interrupt patches resulted from reading the
> > intel specs and observing the behavior of failing machines. We're trying
> > to wrap up all the information gathered in a paper, which is pretty time
> > consuming and a few steps away from being ready to publish.
> 
> We read the specs of the chips, analyzed code, put up hypotheses and
> tested them. Then read the specs again, finding new hypotheses and
> tested again. Also reading what you guys sent out to lkml and reading
> through the public discussions for *BSD, Darwin, XEN etc. helped.
> And some colleagues discussed hypotheses and solution attempts with us.
> 
> We summarized many of our end results in a presentation that we gave
> internally, and I am working on making this available online (in
> addition to the paper/slides that Stefan mentions below).

The presentation can be found at

    http://www.suse.de/~odabrunz/Boot_Interrupts_and_IRQ_Threads.pdf

Some parts of it have been corrected and updated.

Please do not miss the "Details" slides after the License and the
Disclaimer. The Details should answer many questions.

Thanks,

-- 
Olaf Dabrunz (od/odabrunz), SUSE Linux Products GmbH, Nürnberg

