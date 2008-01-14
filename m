Return-Path: <linux-kernel-owner+w=401wt.eu-S1752245AbYANPGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbYANPGV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 10:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751019AbYANPGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 10:06:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37310 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbYANPGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 10:06:12 -0500
Date: Mon, 14 Jan 2008 16:05:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Adrian Bunk <bunk@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       rjw@sisk.pl, pavel@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86] [15/16] Force __cpuinit on for CONFIG_PM without
	HOTPLUG_CPU
Message-ID: <20080114150553.GA3524@elte.hu>
References: <20080103442.621670000@suse.de> <20080110111514.GS25945@bingen.suse.de> <20080110112607.GE28740@does.not.exist> <200801101242.53504.ak@suse.de> <20080110124702.GF28740@does.not.exist> <p73fxx5omck.fsf@bingen.suse.de> <20080110150911.GG28740@does.not.exist> <20080114135240.GA15357@elte.hu> <20080114140910.GA8507@uranus.ravnborg.org> <20080114145854.GA31695@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114145854.GA31695@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > Would be great to have them automated - just dunno how to do it. Do 
> > you see a feasible way to do it?
> 
> a good starting point would be to make the warnings a lot more 
> self-explanatory. Right now it's often non-obvious trying to figure 
> out how the dependencies are structured and which one should be 
> changed to get rid of the bug.

also, in theory we've got a pretty reliable set of the following 
information:

  function X references symbol Y

and we know what type of sections they are in, right?

could -ffunction-sections be used to delay the categorization of 
functions to the link stage, and in essence remove the need to mark 
functions via any of the __init markers?

	Ingo
