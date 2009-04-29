Return-Path: <linux-kernel-owner+w=401wt.eu-S1754328AbZD2HSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbZD2HSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 03:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbZD2HSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 03:18:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41991 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbZD2HSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 03:18:13 -0400
Date: Wed, 29 Apr 2009 08:18:11 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       David <david@unsolicited.net>
Subject: Re: 2.6.30-rc3: reiserfs: WARNING: at fs/namei.c:1251
	lookup_one_len
Message-ID: <20090429071811.GH8633@ZenIV.linux.org.uk>
References: <a4423d670904261715q4510bdd3u2eb1ac3b90566fbc@mail.gmail.com> <20090428201310.fd2c6c96.akpm@linux-foundation.org> <49F7F8EB.1080907@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F7F8EB.1080907@suse.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 02:51:23AM -0400, Jeff Mahoney wrote:
> > A number of people are reporting this.  Al Viro said
> > 
> > : Yeah, the sanity check had caught another place misusing lookup_one_len().
> > : I'd keep the warning in place for now; I think I know how to deal with
> > : reiserfs side of things, but if it turns out too invasive for post-rc3,
> > : we can always turn the check off just for -final.  For now I'd keep the
> > : check in place, just to see if anything else runs into it.
> > 
> > It would be nice to plug this sooner rather than later please, to save
> > a bit of bug-reporting bandwidth.
> 
> I have a fix for this that I need to test. I've been traveling and
> haven't had a chance to. I'm back in the office and will be able to
> later today.

Could you Cc me on that?
