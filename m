Return-Path: <linux-kernel-owner+w=401wt.eu-S1754447AbZALR4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447AbZALR4c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 12:56:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbZALR4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 12:56:21 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:51659
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbZALR4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 12:56:20 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Paul Mundt <lethal@linux-sh.org>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
Date: Mon, 12 Jan 2009 11:56:16 -0600
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; x86_64; ; )
Cc: "Mark A. Miller" <mark@mirell.org>, Bernd Petrovitsch <bernd@firmix.at>,
       Leon Woestenberg <leon.woestenberg@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
References: <200901020207.30359.rob@landley.net> <31014a580901120118u55256b51g448f22e9e0ef5d1f@mail.gmail.com> <20090112094121.GD28564@linux-sh.org>
In-Reply-To: <20090112094121.GD28564@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901121156.17377.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 January 2009 03:41:22 Paul Mundt wrote:
> Personally I think perl (and python for that matter) is a terrible
> language and I wouldn't use it for anything of consequence, but again,
> that is my personal opinion and has nothing to do with regards to the
> build system and whether it was the better tool for the job as perceived
> by the people that elected to implemented infrastructure using it. I
> choose not to use it for my own projects, but I have no qualms with those
> that do.

Apparently you have qualms with people who chose to reimplement the perl bits 
in one of the languages kernel developers already needed to know this time 
last year (shell, C, make).

> The kernel does not need to provide justification for every change that
> goes on as long as there is a reasonable attempt not to break things for
> other people.

I submitted a change, you insisted that I justify it to your satisfaction.  
That pretty much summarizes your participation in this thread.

> The onus is (and always has been) on you to demonstrate why
> perl is an unreasonable dependency to push on embedded developers, and
> you have failed utterly at demonstrating this in any sort of coherent
> fashion.

Large additional dependencies without benefit are unreasonable.  My primary 
objection to perl is that it happens to be an additional large dependency 
without a correspondingly large benefit.

Your position is not internally consistent.  There was no need to scrutinize 
it when it went in, but there is a need to scrutinize patches reimplementing 
those bits without it.  You don't need the word "perl" in that sentence for 
your position to be a touch unbalanced.

> I will repeat, there has not been a single coherent argument against what
> makes perl inherently incapable of being supported.

I didn't say it was incapable of being supported.  We're _capable_ of 
reimplementing the entire kernel in perl except for a microkernel interpreter 
running on the bare metal.  Or cobol.  Sun spent some time trying to do one in 
Java a few years back.

"It can be done" and "It's a good idea" are two completely different criteria.

> Every single thing
> you have presented as a rebuttal has been your personal preference, which
> in this case is simply irrelevant.

Stop getting so hung up on the word "perl".  Did you ever notice the _shipped 
files in the kernel so you don't have to have lex or yacc installed?  That's 
been kernel policy for how many years now?  The arguments about "dash vs bash" 
when reviewing the shell versions of these scripts are a similar impulse: 
trying to reduce unnecessary dependencies.

My first version of the timeconst patch didn't remove the perl script that 
generated the file, it simply shipped the pregenerated .h file so it was 
possible to _build_ without perl.  That was not sufficient for technical 
reasons (due to the two architectures that allow you to enter arbitrary 
values), so I redid the patch.

Rob
