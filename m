Return-Path: <linux-kernel-owner+w=401wt.eu-S1751951AbZKGNnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbZKGNnS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 08:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbZKGNnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 08:43:17 -0500
Received: from mail.gmx.net ([213.165.64.20]:54119 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751841AbZKGNnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 08:43:16 -0500
Cc: technoboy85@gmail.com, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@canonical.com>
Content-Type: text/plain; charset="iso-8859-1"
Date: Sat, 07 Nov 2009 14:43:18 +0100
From: "Martin Schleier" <drahemmaps@gmx.net>
In-Reply-To: <m3vdhmvcw5.fsf@intrepid.localdomain>
Message-ID: <20091107134318.4690@gmx.net>
MIME-Version: 1.0
References: <20091106154911.29400@gmx.net>
	<20091106155937.11d95279@lxorguk.ukuu.org.uk>	<20091106165731.26800@gmx.net>
	<20091106182218.43940287@lxorguk.ukuu.org.uk>	<20091106200620.179910@gmx.net>
 <m3r5sbcl07.fsf@intrepid.localdomain>	<20091107000559.166710@gmx.net>
 <m3vdhmvcw5.fsf@intrepid.localdomain>
Subject: SubmittingPatches guidelines (was: Re: i686 quirk for AMD Geode)
To: Krzysztof Halasa <khc@pm.waw.pl>
X-Authenticated: #35928486
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX19jHqlMTbBjOtP2nazc934u5/L8vlvQdp/FiKexf8
 Ld3AgSEvV/sTKwHtT8FTnztkO7QtccArHKBA== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: QkvMcuM0YW0tVcJKRWRpGAB8amthc9tt
X-FuHaFi: 0.45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 07 Nov 2009 11:37:46 Krzysztof Halasa 
> "Martin Schleier" <drahemmaps@gmx.net> writes:
> >> Did the patch in question contain such problems?
> > the last point:
> >  - etc... =>
> 
> Yeah.
> 
> > "WARNING: externs should be avoided in .c files
> 
> Ironically, it's the only "WARNING" while the rest are "ERRORS".
> OTOH I personally believe all output from checkpatch should be labeled
> "WARNING"; it's not for checkpatch to decide. It's only a tool.
Ironically, I assumed that these matters are taken somewhat serious
and everything would be fine after the respin...

But instead, all everyone (except the submitter) is barking whenever checkpatch.pl is irrelevant - because apparently it only catches formatting errors -

(BTW: I think this message should be an ERROR, because it
 can really break Randy Dulap's massive kernel compile tests)

> > #56: FILE: arch/x86/kernel/nopl_emu.c:13:
> > +void do_invalid_op(struct pt_regs *regs, long error_code);" ?
> > (or do you think that this is a formatting issue?!)
> 
> Actually, I think it wasn't any issue at all at this point, when it
> wasn't yet established if the patch makes sense at all.

here's the quote from on which the comment was based:
| On Sat, Oct 3, 2009 at 8:21 AM, Ingo Molnar <mingo@elte.hu> wrote:
| 
| Looks good, but your signoff line is missing.
|
|        Ingo

now tell me: What is the word he was using to say that the idea
needs _rethinking_ and that he's declined to merge the patch
in the foreseeable future because of these shortcomings?
I can't see them, but I would be delighted if you can
point them out to me.

The discussion whenever this feature make sense has
taken place _a bit_ earlier in the thread with a _positive_ result.
(if you look at the date: the thread started over a month ago:
 http://lkml.org/lkml/2009/10/2/464 )

so I'm not sure if everyone was aware of this,
since this might explain the _differences_.

> > It is the job of a Submitter
> > (as described in Documentations/SubmittingPatches section 4)
> > to check and test his patches with tools like checkpatch or sparse
> > before posting them.
> 
> You apparently forgot what SubmittingPatches file is all about:
> 
> "This text is a collection of suggestions which can greatly increase the
> chances of your change being accepted."
> You know, we don't have laws for everything here.
> And we're not androids specialized in producing C code.
> We are supposed to use some common sense first.

Ahh common sense, so checking & testing your work
before submitting it not _common sense_ anymore?

Surely it's hard for anyone new to know about this before
hitting "send". But so far everyone has stumbled across this. :\

But back to the topic about laws.
What about: "12) Sign your work" in the same SubmittingPatches file?
Have you noticed that only SubmittingPatches talks about the signed-off-by?
And we all know that every patch has to have one. 
So Clearly SubmittingPatches really contains LAWs for how to do things.

The only question is if "4) Style check your changes." is a
guideline or a _more_... And there's a paragraph in Documentation/SubmitChecklist:"

5: Check your patch for general style as detailed in
   Documentation/CodingStyle.  Check for trivial violations with the
   patch style checker prior to submission (scripts/checkpatch.pl).
   [BOLD] You should be able to justify all violations that remain in
   your patch. [BOLD]"

Andy Whitcroft <apw@shadowen.org> clearly wrote that down.
(And there's no point in arguing about checkpatch.pl when you
 have to JUSTIFY ALL REMAINING VIOLATIONS, or more to the point:
 FIX THEM INSTEAD.)

And now my - head hurts - we need a lawyer to answer if this
IS or IS NOT a law before we can bang on with this.

And yes Documentation/SubmitChecklist also has the same _header_:  
"Here are some basic things that developers should do if they want to see their kernel patch submissions accepted more quickly."

I know about that and I agree: time is always an issue. 
This cycle is already @ -rc6 (rc5) and given that the debating
started over a month ago it's really time to get cracking...
Thankfully v3 is already available, and even better: fixed :-).

> > After all this patch is going into /arch/x86 and not /drivers/staging
> > and this sort of "extern declaration" is prone to break one day when
> > void do_invalid_op(struct pt_regs *, long); declaration is modified.
> 
> That's true, though it's the same for "staging".
AFAIK the only rule for staging is: it must compile (somehow).
but I'm sure we can ask greg here if there are uncertainties.


-- 
DSL-Preisknaller: DSL Komplettpakete von GMX schon für 
16,99 Euro mtl.!* Hier klicken: http://portal.gmx.net/de/go/dsl02
