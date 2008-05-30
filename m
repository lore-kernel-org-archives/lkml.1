Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbYE3UbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbYE3UbF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 16:31:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbYE3Uax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 16:30:53 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2716 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753092AbYE3Uaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 16:30:52 -0400
Date: Fri, 30 May 2008 22:30:39 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Dave Jones <davej@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [X86] Fix up silly i1586 boot message.
Message-ID: <20080530203039.GA5119@ucw.cz>
References: <20080528165713.GA412@redhat.com> <alpine.LNX.1.10.0805281943330.19264@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.55.0805281850540.29522@cliff.in.clinika.pl> <alpine.LNX.1.10.0805282001180.19264@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.55.0805281916480.29522@cliff.in.clinika.pl> <483DB2D5.8050502@zytor.com> <Pine.LNX.4.55.0805290102340.29522@cliff.in.clinika.pl> <483DF520.6010602@zytor.com> <alpine.LNX.1.10.0805291131450.19264@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0805291131450.19264@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-05-29 11:35:08, Jan Engelhardt wrote:
> 
> On Thursday 2008-05-29 02:13, H. Peter Anvin wrote:
> 
> > Maciej W. Rozycki wrote:
> >> > uname reports i686 on these chips.  The rest is ridiculous.
> >> 
> >> Intel started it first with picking up a ridiculous number for the family
> >> ID for the P4 line.  There is no technical justification for not keeping
> >> these numbers consecutive.  Or keeping it at 6 actually if the P4 is meant
> >> to be seen by software as the Pentium Pro and the rest of the P6 gang.
> >
> > Yes, this is what we eventually ended up doing as causing fewest compatibility
> > problems.  For the message in question, it's better to be consistent with
> > uname.
> 
> Then again, should not all of the i?86 names be collapsed,
> much like there is only "sparc" and "sparc64" for
> the actual sparcv7, sparcv8, sparcv9, sparcv9a pseudo-arches
> used in, for example rpm, etc.

They should, but it is too late for that now.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
