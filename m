Return-Path: <linux-kernel-owner+w=401wt.eu-S1759476AbZLJCKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759476AbZLJCKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 21:10:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759460AbZLJCKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 21:10:37 -0500
Received: from thunk.org ([69.25.196.29]:42818 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759447AbZLJCKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 21:10:36 -0500
Date: Wed, 9 Dec 2009 21:10:40 -0500
From: tytso@mit.edu
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jan Kara <jack@suse.cz>
Subject: Re: linux-next: ext4 tree build failure
Message-ID: <20091210021040.GB4735@thunk.org>
Mail-Followup-To: tytso@mit.edu, Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jan Kara <jack@suse.cz>
References: <20091210113812.9d1e4bb4.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091210113812.9d1e4bb4.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 11:38:12AM +1100, Stephen Rothwell wrote:
> Hi Ted,
> 
> Today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> ERROR: "jbd2_log_start_commit" [fs/ext4/ext4.ko] undefined!
> 
> Caused by commit b436b9bef84de6893e86346d8fbf7104bc520645 ("ext4: Wait
> for proper transaction commit on fsync") which I have reverted for today.

Thanks for pointing this out.  I've fixed this for tomorrow's build.

       	   	    	       	    	       - Ted
