Return-Path: <linux-kernel-owner+w=401wt.eu-S1757056AbXETMVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056AbXETMVR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 08:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755064AbXETMVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 08:21:07 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:14578 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbXETMVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 08:21:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=hlhd50vul2BXJfjPx1U6uf6KbOuOnTG0jhvQdKgmiUv+nWjzcc4E+KBmp+hx1c7HGae+VBIxPvtI9Mf8a/RIm3yc6vkzU3Rkvn7TZjcgwFbsgsrAMIbJycMJOgTnX874p92bOvLKciHvpbDox6G2hSrPmGFXPrFVpFPVpvrxN3M=
Date: Sun, 20 May 2007 16:20:10 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Christoph Hellwig <hch@infradead.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Jan Kara <jack@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>
Subject: Re: [PATCH] UDF: check for allocated memory for inode data
Message-ID: <20070520122010.GA8334@cvg>
References: <20070510154640.c0299a52.akpm@linux-foundation.org> <20070511072939.GA25727@infradead.org> <20070511090127.GD9444@cvg> <20070511103956.GA30896@infradead.org> <20070511110920.GA11898@cvg> <20070513210126.GB14030@infradead.org> <20070516143308.GA8327@cvg> <20070516173852.GC29602@atrey.karlin.mff.cuni.cz> <20070516175257.GA14076@cvg> <20070516175600.GA3261@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070516175600.GA3261@infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Christoph Hellwig - Wed, May 16, 2007 at 06:56:00PM +0100]
| On Wed, May 16, 2007 at 09:52:57PM +0400, Cyrill Gorcunov wrote:
| > I've that documants even printed ;) Actually they are _very-very_ big
| > indeed. I don't know may be just try to bring this code into Linux
| > codying style?
| 
| That's probably a good step.  And while converting things to a proper
| style you'll surely find various bugs and thinkgs you could improve.
| Write them down somewhere and work on fixing them.  And make sure every
| actualy fix or behaviour change is a single patch separated from the
| cleanups.
| 

Hi Christoph,

I almost have completed UDF style conversation (the only thing to do
is to check all I've changed). And I've been striked down by the simple
question: the conversion I've done is over 2.6.22-rc1 but meantime in -mm
tree two my patches already exist so should I take them into account while
converting UDF style?

		Cyrill

