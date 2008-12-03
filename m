Return-Path: <linux-kernel-owner+w=401wt.eu-S1753562AbYLCRn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbYLCRn3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 12:43:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbYLCRnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 12:43:20 -0500
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:47422 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbYLCRnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 12:43:19 -0500
Date: Wed, 3 Dec 2008 18:43:18 +0100 (CET)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Theodore Tso <tytso@mit.edu>
cc: Pavel Machek <pavel@suse.cz>, Chris Friesen <cfriesen@nortel.com>,
       kernel list <linux-kernel@vger.kernel.org>, aviro@redhat.com
Subject: Re: writing file to disk: not as easy as it looks
In-Reply-To: <20081203164240.GA30610@mit.edu>
Message-ID: <Pine.LNX.4.64.0812031840420.25439@artax.karlin.mff.cuni.cz>
References: <20081202094059.GA2585@elf.ucw.cz> <20081202140439.GF16172@mit.edu>
 <20081202152618.GA1646@ucw.cz> <20081202163720.GB18162@mit.edu>
 <49356EF2.7060806@nortel.com> <20081202205558.GD20858@mit.edu>
 <20081202224403.GA8277@elf.ucw.cz> <20081203050709.GL20858@mit.edu>
 <20081203084639.GB1944@ucw.cz> <20081203164240.GA30610@mit.edu>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Dec 03, 2008 at 09:46:40AM +0100, Pavel Machek wrote:
> > Yes. fsync() seeems surprisingly high on Rusty's list of broken
> > interfaces classification ('impossible to use correctly').

BTW where is that list.

> To be fair, fsync() was primarily intended for making sure that the
> data had been written to disk, and not necessarily as a way of making
> sure that write errors would be properly reflected back to the
> application.  As you've pointed out, it's not really adequate for that
> purpose.
> 
> 						- Ted

Well, what else do you want to use for databases? (where crashing the 
whole computer makes less damage than pretending that transaction was 
committed while it wasn't).

Mikulas
