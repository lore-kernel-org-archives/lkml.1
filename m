Return-Path: <linux-kernel-owner+w=401wt.eu-S1753421AbYADNaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbYADNaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 08:30:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbYADNaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 08:30:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46565 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbYADNaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 08:30:05 -0500
Date: Fri, 4 Jan 2008 14:29:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Dave Young <hidave.darkstar@gmail.com>,
       Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: isofs oops - d_splice_alias+0x1f (2.6.24-rc5-mm1)
Message-ID: <20080104132950.GB27330@elte.hu>
References: <20080104123529.GA27894@ZenIV.linux.org.uk> <20080104112642.GY27894@ZenIV.linux.org.uk> <477CE1E0.4010504@gmail.com> <Pine.LNX.4.64.0801031550160.2076@sbz-30.cs.Helsinki.FI> <477CEE1C.7020005@gmail.com> <20080104104755.GX27894@ZenIV.linux.org.uk> <20080104111357.GA3429@darkstar.te-china.tietoenator.com> <22924.1199449441@redhat.com> <23768.1199450630@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23768.1199450630@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* David Howells <dhowells@redhat.com> wrote:

> > FWIW, this patch pile is getting ridiculous - it's what, original + 
> > 2 fixes in -mm + mine + this one?  Could you post the updated patch 
> > with all fixes and fixes to fixes folded into it?
> 
> I can, though Andrew usually objects to that.

folding often results in commit messages and hence credit lost - and 
thus discourages test/review feedback and bugfixing. It's also easier to 
see the track record/history of a patch if the fixes are in separate 
patches. It's also easier to undo a 'fix' (and track the state/version 
of changes) if it turns out to be a bad fix. If things get spaghetti 
then a new splitup indeed helps (for larger patchsets), and Andrew 
usually asks for a new splitup in that case. Andrew often folds patches 
together right before sending it off to Linus (while constructing 
combined credit - so credit is not lost).

	Ingo
