Return-Path: <linux-kernel-owner+w=401wt.eu-S1755375AbZD2Evb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375AbZD2Evb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 00:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbZD2EvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 00:51:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37832 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbZD2EvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 00:51:20 -0400
Date: Wed, 29 Apr 2009 05:51:18 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Beregalov <a.beregalov@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Jeff Mahoney <jeffm@suse.com>, David <david@unsolicited.net>
Subject: Re: 2.6.30-rc3: reiserfs: WARNING: at fs/namei.c:1251
	lookup_one_len
Message-ID: <20090429045118.GG8633@ZenIV.linux.org.uk>
References: <a4423d670904261715q4510bdd3u2eb1ac3b90566fbc@mail.gmail.com> <20090428201310.fd2c6c96.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090428201310.fd2c6c96.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 08:13:10PM -0700, Andrew Morton wrote:
> : Yeah, the sanity check had caught another place misusing lookup_one_len().
> : I'd keep the warning in place for now; I think I know how to deal with
> : reiserfs side of things, but if it turns out too invasive for post-rc3,
> : we can always turn the check off just for -final.  For now I'd keep the
> : check in place, just to see if anything else runs into it.
> 
> It would be nice to plug this sooner rather than later please, to save
> a bit of bug-reporting bandwidth.

Post-rc4; I've a preliminary for that one, but it'll need to be untangled
to go in at that phase.  I think I know how to make it reasonably non-invasive,
but that's still not finished.
