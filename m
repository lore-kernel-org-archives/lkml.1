Return-Path: <linux-kernel-owner+w=401wt.eu-S1751298AbZC3MbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298AbZC3MbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 08:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750891AbZC3MbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 08:31:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60499 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbZC3MbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 08:31:09 -0400
Date: Mon, 30 Mar 2009 14:31:07 +0200
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 08/14] fs: scale inode alias list
Message-ID: <20090330123107.GH31000@wotan.suse.de>
References: <20090329155539.275927173@nick.local0.net> <20090329155749.455863870@nick.local0.net> <87zlf3mcg0.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zlf3mcg0.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 02:18:07PM +0200, Andi Kleen wrote:
> npiggin@suse.de writes:
> 
> > Add a new lock, dcache_inode_lock, to protect the inode's i_dentry list
> > from concurrent modification. d_alias is also protected by d_lock.
> 
> This would seem to ask for per object lock? Why not put it into the inode?

Yes, this comes later in the last patch, because the first round is just
meant to be as simple as possible, and making it per-inode is non-trivial
(not too difficult, but just not totally trivial) for reasons given in
that patch changelog.
