Return-Path: <linux-kernel-owner+w=401wt.eu-S1761427AbYDPINq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761427AbYDPINq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 04:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752708AbYDPINc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 04:13:32 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:51332 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbYDPIN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 04:13:29 -0400
Date: Wed, 16 Apr 2008 10:14:18 +0200
From: Pavel Machek <pavel@ucw.cz>
To: SL Baur <steve@xemacs.org>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: gart: factor out common code
Message-ID: <20080416081418.GA5105@elf.ucw.cz>
References: <20080415104357.GA13441@elf.ucw.cz> <ed10ee420804151625i1e30abb7r98ddda53ec6e8da6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed10ee420804151625i1e30abb7r98ddda53ec6e8da6@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-04-15 16:25:29, SL Baur wrote:
> On 4/15/08, Pavel Machek <pavel@ucw.cz> wrote:
> > Cleanup gart handling on amd64 a bit: move common code into
> >  enable_gart_translation , and use symbolic register names where
> >  appropriate.
> >
> >  Signed-off-by: Pavel Machek <pavel@suse.cz>
> 
> Which source tree is this patch against?  I'm looking at Linus
> latest and I don't see the AMD64_* constants defined in the
> same place.

x86 tree, hopefully.

> Other reviewer comments:
> The casting between struct pci_dev * and u64 is kind of ugly,
> I presume the reason for the narrowing casts in the block of
> code you moved is documented somewhere.

Where am I doing that?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
