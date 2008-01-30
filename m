Return-Path: <linux-kernel-owner+w=401wt.eu-S1759448AbYA3QjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759448AbYA3QjF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 11:39:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754262AbYA3Qiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 11:38:54 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:33440 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753724AbYA3Qix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 11:38:53 -0500
Date: Wed, 30 Jan 2008 17:39:09 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
Subject: Re: sleepy linux self-test
Message-ID: <20080130163909.GA5395@elf.ucw.cz>
References: <20080130131748.GA3796@elf.ucw.cz> <20080130163511.GA30797@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080130163511.GA30797@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-01-30 17:35:11, Ingo Molnar wrote:
> 
> * Pavel Machek <pavel@ucw.cz> wrote:
> 
> > Hi!
> > 
> > This version should work, at least it did not fail in my testing. It 
> > does one test 5 second after bootup, then periodically once per 500 
> > seconds. Different parameters are trivial to tweak.
> 
> nice - is nohz=off still needed? (if not, what was the problem with 
> nohz?)

Not needed, but I do not know where the nohz problem was. Waiting 5
seconds means userspace comes up and problem is somehow worked around.

The nohz problem was of the "you need to press keys to get forward
progress" -- the kind I tried to debug few times already :-(.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
