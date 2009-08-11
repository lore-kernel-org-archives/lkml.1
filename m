Return-Path: <linux-kernel-owner+w=401wt.eu-S1754811AbZHKS5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbZHKS5P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 14:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367AbZHKS5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 14:57:14 -0400
Received: from thunk.org ([69.25.196.29]:44596 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbZHKS5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 14:57:13 -0400
Date: Tue, 11 Aug 2009 14:57:03 -0400
From: Theodore Tso <tytso@mit.edu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Frans Pop <elendil@planet.nl>, Chris Mason <chris.mason@oracle.com>,
       jack@suse.cz, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: What happened to data=guarded?
Message-ID: <20090811185703.GQ1756@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andi Kleen <andi@firstfloor.org>, Frans Pop <elendil@planet.nl>,
	Chris Mason <chris.mason@oracle.com>, jack@suse.cz,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
References: <1249934623-15939-1-git-send-email-tytso@mit.edu> <200908111535.37927.elendil@planet.nl> <20090811133721.GD29224@think> <200908111654.38217.elendil@planet.nl> <878whqgyid.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878whqgyid.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 11, 2009 at 05:29:14PM +0200, Andi Kleen wrote:
> > Good to hear. I've so far stayed with data=ordered as I think I'd prefer 
> > data=guarded over data=writeback. I'll certainly give it a try when it's 
> > available.
> 
> Same here. data=writeback already cost me a few files after crashes here :/

What sort of files were you losing?  I don't know if we can improve
the implied flush hueristics, but we should at least try to see if we
do something about it.

						- Ted
