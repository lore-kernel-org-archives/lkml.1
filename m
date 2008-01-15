Return-Path: <linux-kernel-owner+w=401wt.eu-S1755876AbYAOI6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbYAOI6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 03:58:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbYAOI6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 03:58:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44632 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190AbYAOI6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 03:58:11 -0500
Date: Tue, 15 Jan 2008 09:57:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: sam@ravnborg.org, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: Latest git-x86 doesn't build on 32bit
Message-ID: <20080115085757.GA18591@elte.hu>
References: <20080114221608.GA11732@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114221608.GA11732@basil.nowhere.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> On a fresh object dir I get for a 32bit build:

you seem to have a modified git repository.

> KBUILD_IMAGE := arch/x86/boot/bzImage
> make[2]: KBUILD_IMAGE: Command not found
> make[2]: *** [all] Error 127
> make[1]: *** [sub-make] Error 2
> make: *** [all] Error 2
> 
> I think it worked on older object dirs where not everything was rebuild.

have you changed your git setup recently? In particular, do you have any 
spaces-to-tabs conversion features enabled? That could perhaps have 
caused this problems.

	Ingo
