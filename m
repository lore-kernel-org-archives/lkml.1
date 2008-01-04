Return-Path: <linux-kernel-owner+w=401wt.eu-S1753835AbYADQaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbYADQaU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 11:30:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbYADQaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 11:30:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:53050 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741AbYADQaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 11:30:07 -0500
To: Theodore Tso <tytso@mit.edu>
Cc: Mathieu Segaud <mathieu.segaud@regala.cx>, akpm@linux-foundation.org,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [Coding Style]: misc fixes for fs/ext{3,4}/acl.{c,h} from checkpatch.pl
From: Andi Kleen <andi@firstfloor.org>
References: <1199452896-20145-1-git-send-email-mathieu.segaud@regala.cx>
	<20080104134458.GE17436@mit.edu>
Date: Fri, 04 Jan 2008 17:30:00 +0100
In-Reply-To: <20080104134458.GE17436@mit.edu> (Theodore Tso's message of "Fri\, 4 Jan 2008 08\:44\:58 -0500")
Message-ID: <p73hcht8sfr.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso <tytso@mit.edu> writes:

> Coding-style only changes tends to screw up our ability to merge
> pending patches, but I'll take care of it, thanks.

Exactly. And looking at the patch the old code was already perfectly
readable anyways. Benefit about zero.

I also don't see how you can take care of patch conflicts caused by
this for patches not yet in your tree but still in development somewhere
else.

IMHO any coding style cleanup should only done on code that changes
anyways, but not on other code.

The recent flurry of cleanup code patches on l-k causes far more
problems than it solves. I'm not even sure why people do this? Just
because it is en vogue recently? 

If they want to contribute in simple ways to the Linux kernel I'm sure
actually really useful things can be found that they can change.

-Andi
