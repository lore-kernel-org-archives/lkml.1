Return-Path: <linux-kernel-owner+w=401wt.eu-S1760626AbYENWav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760626AbYENWav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 18:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753541AbYENWah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 18:30:37 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:50042 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752453AbYENWag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 18:30:36 -0400
Date: Wed, 14 May 2008 18:30:03 -0400
From: Theodore Tso <tytso@mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, Andreas Gruenbacher <agruen@suse.de>,
       Tiger Yang <tiger.yang@oracle.com>, linux-fsdevel@vger.kernel.org,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable] [PATCH] ext3/4: fix uninitialized bs in
	ext3/4_xattr_set_handle()
Message-ID: <20080514223003.GJ7054@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
	Andreas Gruenbacher <agruen@suse.de>,
	Tiger Yang <tiger.yang@oracle.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@kernel.org
References: <4827B878.50903@oracle.com> <20080512170254.f79fe869.akpm@linux-foundation.org> <4828FD68.40608@oracle.com> <200805141256.43272.agruen@suse.de> <20080514160035.GD28594@kroah.com> <20080514102809.3fc190f0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080514102809.3fc190f0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 10:28:09AM -0700, Andrew Morton wrote:
> 
> It's in -mm and I just added the "Cc:stable" tag to it.

This patch has both ext3 and ext4 changes in it, so Andrew, I'm
assuming that you'll push it directly to Linus in the near future?
That's why I didn't suck it into the ext4 tree....

       	     	    	    	     - Ted
