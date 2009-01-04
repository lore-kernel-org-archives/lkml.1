Return-Path: <linux-kernel-owner+w=401wt.eu-S1757622AbZADM5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622AbZADM5j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 07:57:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750803AbZADM5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 07:57:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44500 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795AbZADM5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 07:57:30 -0500
Date: Sun, 4 Jan 2009 13:57:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Baodong Chen <chenbdchenbd@gmail.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Subject: [PATCH] Documentation/x86/boot.txt:payload length was
	changed to payload_length
Message-ID: <20090104125713.GD15472@elte.hu>
References: <d204e3110901020024n7d0c1a6dt919f76283d9a8663@mail.gmail.com> <20090102092659.GC1975@elte.hu> <d204e3110901022044l2cf57f54yd52a2d331d69deef@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d204e3110901022044l2cf57f54yd52a2d331d69deef@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Baodong Chen <chenbdchenbd@gmail.com> wrote:

> On Fri, Jan 2, 2009 at 5:26 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Baodong Chen <chenbdchenbd@gmail.com> wrote:
> >
> >>  Documentation/x86/boot.txt:payload length was changed to payload_length
> >>
> >> Signed-off-by: Baodong Chen <[email]chenbdchenbd@gmail.com[email]>
> >>
> >> ---
> >>  Documentation/x86/boot.txt |    2 +-
> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > looks good but the patch was whitespace damaged (all tabs were spaces and
> > there were linewraps as well), please check
> > Documentation/email-clients.txt and resend the patch. Thanks,
> >
> >        Ingo
> 
> I referred to Documentation/email-clients.txt:Gmail and resent the 
> patch. I am a newbie,if i made any mistake,please do me a favor and help 
> me.Thanks!

it's OK, and your resubmission was better - but it still had a linewrap 
problem (i was able to fix that up manually).

this bit:

@@ -44,7 +44,7 @@ Protocol 2.07:        (Kernel 2.6.24) Added paravirtualised
boot protocol.
                and KEEP_SEGMENTS flag in load_flags.

[3 lines]

should have been:

@@ -44,7 +44,7 @@ Protocol 2.07:        (Kernel 2.6.24) Added paravirtualised boot protocol.
                and KEEP_SEGMENTS flag in load_flags.

[2 lines]

If you post from gmail it might make sense to send patches as MIME 
attachments, we can process them just fine. (as long as you send patches 
that go via -tip - other maintainers have different policies regarding 
MIME attachments)

	Ingo
