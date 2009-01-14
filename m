Return-Path: <linux-kernel-owner+w=401wt.eu-S1757203AbZANKhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203AbZANKhq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 05:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753868AbZANKhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 05:37:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53579 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854AbZANKhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 05:37:34 -0500
Date: Wed, 14 Jan 2009 11:37:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alain Knaff <alain@knaff.lu>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@ftp.linux.org.uk>
Subject: Re: The policy on initramfs decompression failure
Message-ID: <20090114103727.GA2913@elte.hu>
References: <496D17F9.8080605@zytor.com> <496D20FB.5010307@knaff.lu> <20090114054022.GA11153@elte.hu> <496D8E0D.5090401@knaff.lu> <20090114074852.GB16274@elte.hu> <496DA0FF.2060206@knaff.lu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496DA0FF.2060206@knaff.lu>
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


* Alain Knaff <alain@knaff.lu> wrote:

> Ingo Molnar wrote:
> > * Alain Knaff <alain@knaff.lu> wrote:
> > 
> >> Ingo Molnar wrote:
> >>> And your argument makes little sense: if there is something wrong then one 
> >>> looks at the logs _anyway_.
> >> Unfortunately, not everybody has the knowledge or equipment ready to set
> >> up a serial console... [...]
> > 
> > By your argument the ton of warnings we emit in various situations are 
> > wrong too and all should be panic()s.
> 
> That is not my argument. I never said something like that.

I did not say that it is your argument, i said it is _by_ your argument: 
i.e. it is a logical extension of your argument.

Exactly how is such a warning different from other warnings that the 
kernel already emits? For which people supposedly have to set up a serial 
console? (which they dont have to)

Answer: it is not different, and it is exactly as hard or easy to find as 
the other ones. I.e. why should this warning get a special treatment? I 
already told the kernel that i dont want a gzip ramfs image decompressor 
by turning off the (otherwise default-enabled) option. panic()ing on that 
decision, overriding my decision and escallating it into a non-working 
system is silly and a bug.

	Ingo
