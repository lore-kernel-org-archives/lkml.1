Return-Path: <linux-kernel-owner+w=401wt.eu-S1758295AbYFWJZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758295AbYFWJZx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 05:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754058AbYFWJZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 05:25:44 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43459 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717AbYFWJZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 05:25:43 -0400
Date: Mon, 23 Jun 2008 11:26:38 +0200
From: Pavel Machek <pavel@suse.cz>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Tejun Heo <tj@kernel.org>, Andreas Schwab <schwab@suse.de>,
       kernel list <linux-kernel@vger.kernel.org>, jgarzik@pobox.com,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Trivial patch monkey <trivial@kernel.org>
Subject: Re: sata_svw data corruption, strange problems
Message-ID: <20080623092638.GH1850@elf.ucw.cz>
References: <20080617093602.GA28140@elf.ucw.cz> <485EF061.3010601@kernel.org> <20080623082055.GB1850@elf.ucw.cz> <je63s0sfxv.fsf@sykes.suse.de> <20080623085338.GE1850@elf.ucw.cz> <485F6540.6000907@kernel.org> <20080623090130.GF1850@elf.ucw.cz> <1214211859.8011.250.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214211859.8011.250.camel@pasglop>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-06-23 19:04:19, Benjamin Herrenschmidt wrote:
> On Mon, 2008-06-23 at 11:01 +0200, Pavel Machek wrote:
> > On Mon 2008-06-23 17:56:32, Tejun Heo wrote:
> > > Pavel Machek wrote:
> > > > On Mon 2008-06-23 10:39:40, Andreas Schwab wrote:
> > > >> Pavel Machek <pavel@suse.cz> writes:
> > > >>
> > > >>> +	   controller, the controller could hang. In other cases it
> > > >>> +	   could return partial data returning in data
> > > >>> +	   corruption. This problem has been seen in PPC systems and
> > > >> s/returning/resulting/ ?
> > > > 
> > > > Fix thinko in sata_svw comment.
> > > > 
> > > > Signed-off-by: Pavel Machek <pavel@suse.cz>
> > > 
> > > Please collapse into one patch.  Thanks.
> 
> Am I the only one to find Pavel variant almost as obscure as
> the original one ? :-)

At least it makes it clear that the bug should not bite in new
releases.

I'm neither native english speaker nor author of this driver, so if
you'd like to improve the comment, please do so. (I spent quite long
time wondering if we do workaround that hw problem or not, that's why
I'm trying to clarify the comment).
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
