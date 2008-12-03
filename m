Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbYLCQm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbYLCQm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 11:42:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbYLCQmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 11:42:49 -0500
Received: from www.church-of-our-saviour.org ([69.25.196.31]:44574 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751195AbYLCQms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 11:42:48 -0500
Date: Wed, 3 Dec 2008 11:42:40 -0500
From: Theodore Tso <tytso@mit.edu>
To: Pavel Machek <pavel@suse.cz>
Cc: Chris Friesen <cfriesen@nortel.com>, mikulas@artax.karlin.mff.cuni.cz,
       clock@atrey.karlin.mff.cuni.cz,
       kernel list <linux-kernel@vger.kernel.org>, aviro@redhat.com
Subject: Re: writing file to disk: not as easy as it looks
Message-ID: <20081203164240.GA30610@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Pavel Machek <pavel@suse.cz>, Chris Friesen <cfriesen@nortel.com>,
	mikulas@artax.karlin.mff.cuni.cz, clock@atrey.karlin.mff.cuni.cz,
	kernel list <linux-kernel@vger.kernel.org>, aviro@redhat.com
References: <20081202094059.GA2585@elf.ucw.cz> <20081202140439.GF16172@mit.edu> <20081202152618.GA1646@ucw.cz> <20081202163720.GB18162@mit.edu> <49356EF2.7060806@nortel.com> <20081202205558.GD20858@mit.edu> <20081202224403.GA8277@elf.ucw.cz> <20081203050709.GL20858@mit.edu> <20081203084639.GB1944@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081203084639.GB1944@ucw.cz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2008 at 09:46:40AM +0100, Pavel Machek wrote:
> Yes. fsync() seeems surprisingly high on Rusty's list of broken
> interfaces classification ('impossible to use correctly').

To be fair, fsync() was primarily intended for making sure that the
data had been written to disk, and not necessarily as a way of making
sure that write errors would be properly reflected back to the
application.  As you've pointed out, it's not really adequate for that
purpose.

						- Ted
