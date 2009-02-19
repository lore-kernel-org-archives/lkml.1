Return-Path: <linux-kernel-owner+w=401wt.eu-S1755551AbZBSQNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbZBSQNx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 11:13:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbZBSQNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 11:13:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42758 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753073AbZBSQNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 11:13:43 -0500
Date: Thu, 19 Feb 2009 17:13:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Jan Beulich <jbeulich@novell.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/6] x86 tip asm ENTRY,ENDPROC cleanup
Message-ID: <20090219161329.GA9556@elte.hu>
References: <20090213215017.959278111@gmail.com> <1234567411.13034.1300286953@webmail.messagingengine.com> <49961178.6040101@zytor.com> <1234611775.19975.1300340003@webmail.messagingengine.com> <49972355.3000707@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49972355.3000707@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> Alexander van Heukelum wrote:
> > 
> > Hi Peter,
> > 
> > I see. But that would be new behaviour. I would propose to use
> > completely separate macro's to handle frame-setup code generation,
> > and keep ENTRY/GLOBAL/END/ENDPROC only for setting metadata and
> > alignment. I think it's worth it to spell out code-generating
> > macro's explicitly: there are not that many asm functions, and
> > quite a few of them would need special handling. I think noone
> > wants to see an ENDPROC_NOFRAMETEARDOWN ;).
> > 
> > The common-case example would look like this.
> > 
> > GLOBAL(c_callable_function)
> >         ENTER
> >         [asm-code]
> >         LEAVE
> >         ret
> > ENDPROC(c_callable_function)
> > 
> 
> I guess I'm a bit concerned about people omitting them, but it's equally
> concerning that people use the wrong macros, so yes, it's probably the
> better thing in the long run.

ok - i've applied Cyrill's patches to tip/x86/asm.

	Ingo
