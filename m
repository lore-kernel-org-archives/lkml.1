Return-Path: <linux-kernel-owner+w=401wt.eu-S1758790AbYAOWOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758790AbYAOWOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 17:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758603AbYAOWOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 17:14:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37265 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758644AbYAOWO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 17:14:29 -0500
Date: Tue, 15 Jan 2008 23:14:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Andi Kleen <andi@firstfloor.org>,
       rjw@sisk.pl, pavel@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86] [15/16] Force __cpuinit on for CONFIG_PM without
	HOTPLUG_CPU
Message-ID: <20080115221409.GF2665@elte.hu>
References: <20080110150911.GG28740@does.not.exist> <20080114135240.GA15357@elte.hu> <20080114140910.GA8507@uranus.ravnborg.org> <20080114145854.GA31695@elte.hu> <20080114150103.GA2700@elte.hu> <20080114182052.GB9847@does.not.exist> <20080114191009.GB2288@elte.hu> <20080114195258.GC9847@does.not.exist> <20080114200126.GB9257@uranus.ravnborg.org> <20080114201826.GD9847@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114201826.GD9847@does.not.exist>
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


* Adrian Bunk <bunk@kernel.org> wrote:

> > make ARCH=x86_64 allyesconfig
> > will set CONFIG_64BIT for you - no?
> 
> Yes.
> 
> But this still leaves the fact that when someone says 'allyesconfig' 
> it's no longer clear which configuration he has. And no, I do not 
> consider it funny that this now implies two hours of compilation twice 
> just for seeing one bug.

sorry - i should have mentioned that it's 64-bit. (and i even 
mis-remembered having seen it on 32-bit as well)

	Ingo
