Return-Path: <linux-kernel-owner+w=401wt.eu-S1751119AbZLOFOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751119AbZLOFOM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 00:14:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750872AbZLOFOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 00:14:11 -0500
Received: from ozlabs.org ([203.10.76.45]:47646 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819AbZLOFOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 00:14:10 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Segher Boessenkool" <segher@kernel.crashing.org>
Subject: Re: [PATCH] modpost: fix segfault with short symbol names
Date: Tue, 15 Dec 2009 15:44:04 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-16-generic; KDE/4.3.2; i686; ; )
Cc: "Michal Marek" <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <1260615744-23165-1-git-send-email-mmarek@suse.cz> <20091214100613.GA21769@sepie.suse.cz> <51737.84.105.60.153.1260797592.squirrel@gate.crashing.org>
In-Reply-To: <51737.84.105.60.153.1260797592.squirrel@gate.crashing.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912151544.04714.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Dec 2009 12:03:12 am Segher Boessenkool wrote:
> > On Sat, Dec 12, 2009 at 04:26:20PM +0100, Segher Boessenkool wrote:
> >> >-		if (memcmp(symname, CRC_PFX, strlen(CRC_PFX)) == 0) {
> >> >+		if (strncmp(symname, CRC_PFX, strlen(CRC_PFX)) == 0) {
> >>
> >> This doesn't change anything.  In both cases the function will return 0
> >> only if all strlen(CRC_PFX) chars match, and in both cases it can access
> >> strlen(CRC_PFX) chars (strncmp() is allowed to access characters after
> >> the first \0 just fine).
> >
> > str(n)cmp is not allowed to access characters past the NUL byte.
> 
> Let me apologise for the confusion.

Mea culpas must be short, to avoid wasting even more time.  And they must be
at least as absolute as the incorrect assertion was.  This helps us lurkers
and archive readers flush the crap from their brains.

Your mails used _ for emphasis and "You are wrong.".  Ouch.  I suggest:

	"I am *wrong*.  Sorry Michal for the brain fart."

Also, please stop channeling Richard B. Johnson.
Rusty.
