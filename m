Return-Path: <linux-kernel-owner+w=401wt.eu-S932669AbZDIVER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669AbZDIVER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 17:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760656AbZDIVD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 17:03:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44568 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757157AbZDIVDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 17:03:55 -0400
Date: Thu, 9 Apr 2009 22:03:50 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] fs: register_filesystem: Don't allow '\t' and '\n'.
Message-ID: <20090409210350.GI26366@ZenIV.linux.org.uk>
References: <200904092018.GGD57377.FHJOLSMOFQOFVt@I-love.SAKURA.ne.jp> <20090409150843.GA3111@cmpxchg.org> <20090409154726.GA24959@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090409154726.GA24959@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 09, 2009 at 11:47:26AM -0400, Christoph Hellwig wrote:
> On Thu, Apr 09, 2009 at 05:08:43PM +0200, Johannes Weiner wrote:
> > Which filesystem does that?  Shouldn't the filesystem get changed
> > instead?
> 
> Yeah, if at all we should reject a name with those characters.  But I
> feel that's a little over-engineering and we should just make sure no
> in-tree fs does stupid things like that by review.

Yes.
