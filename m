Return-Path: <linux-kernel-owner+w=401wt.eu-S1756330AbYEDJEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330AbYEDJEw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 05:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753970AbYEDJEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 05:04:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41791 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753271AbYEDJEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 05:04:43 -0400
Date: Sun, 4 May 2008 11:04:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frans Pop <elendil@planet.nl>
Cc: Jesse Barnes <jesse.barnes@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org,
       "Packard, Keith" <keith.packard@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git head] Should X86_PAT really default to yes?
Message-ID: <20080504090429.GC29318@elte.hu>
References: <200805022122.03576.elendil@planet.nl> <924EFEDD5F540B4284297C4DC59F3DEEFB8D3D@orsmsx423.amr.corp.intel.com> <200805021340.24987.jesse.barnes@intel.com> <200805040910.57088.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805040910.57088.elendil@planet.nl>
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


* Frans Pop <elendil@planet.nl> wrote:

> On Friday 02 May 2008, Jesse Barnes wrote:
> > This is just a transient issue during VT switch or server exit though,
> > right? X functionality isn't affected, and your VTs work fine?
> 
> Transient only. I've just tested again and this time the band was 
> visible on top of the text on VT1 for about 2 seconds. Then it 
> disappeared. The artifacts also appear when I log out from KDE (i.e. 
> without exiting the server), and I also get the messages when logging 
> out and logging in again.
> 
> I do not see any performance issues, but I've only used this kernel 
> for a very short time.
> 
> > If so, it might not be a PAT issue but just a different memory 
> > layout or something (and therefore it would really just be a 
> > cosmetic bug in the X driver).
> 
> The artifacts may not be a PAT issue directly, but it is a clear 
> regression for me as I currently have a nice clean screen when X shuts 
> down. I'm also 100% sure that it is caused by enabling PAT. A kernel 
> with same config and only PAT disabled does not show the artifacts.

ok, Cc:-ed more folks - this bug has to be resolved regardless of the 
default selection.

	Ingo
