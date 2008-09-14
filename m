Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbYINQZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbYINQZh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 12:25:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbYINQZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 12:25:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43601 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280AbYINQZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 12:25:27 -0400
Date: Sun, 14 Sep 2008 18:25:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jordan Crouse <jordan.crouse@amd.com>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Rufus & Azrael <rufus-azrael@numericable.fr>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Witbrodt <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user
	with the same regression
Message-ID: <20080914162514.GD22385@elte.hu>
References: <86802c440808231310hdafc30aw6931b77ea926338e@mail.gmail.com> <48B06FF9.1030404@numericable.fr> <86802c440808231328w5c6a3fa3s9be9d90ec1f30aa1@mail.gmail.com> <48B07409.60905@numericable.fr> <86802c440808231335n9214e38q5141a3560c698f76@mail.gmail.com> <48B074E1.9020106@numericable.fr> <86802c440808231345u7c4f7710k5878928239507b10@mail.gmail.com> <86802c440808231405u42fa8024r89eccc907f36d99e@mail.gmail.com> <20080912173933.GF6743@alberich.amd.com> <20080912174522.GB8042@cosmic.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080912174522.GB8042@cosmic.amd.com>
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


* Jordan Crouse <jordan.crouse@amd.com> wrote:

> On 12/09/08 19:39 +0200, Andreas Herrmann wrote:
> > On Sat, Aug 23, 2008 at 02:05:19PM -0700, Yinghai Lu wrote:
> > > Jordan, or others for AMD could access SB600
> > > can you check ATI SB600 doc to produce one quirks patch to set the
> > > magic bit to hide 00:14.0 BAR1 to OS ?
> > 
> > I know this is a very late reply, but
> > is there still a quirk desired to hide BAR1 of SB600 SMBus device?
> > 
> > If yes, I'll provide a patch asap.
> 
> I sent one up last week, but it was overshadowed by the much
> more serious R790 problem that Linus and Rafael was looking
> at.  I have re-attached the patch for posterity.

i think that quirk still makes sense (even with a perfect PCI resources 
engine it gets rid of a debug warning), i've applied it to 
tip/timers/hpet. Thanks Jordan,

	Ingo
