Return-Path: <linux-kernel-owner+w=401wt.eu-S1753307Ab0ADDK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab0ADDK4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 22:10:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038Ab0ADDKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 22:10:37 -0500
Received: from THUNK.ORG ([69.25.196.29]:57897 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166Ab0ADDKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 22:10:24 -0500
Date: Sun, 3 Jan 2010 20:08:36 -0500
From: tytso@mit.edu
To: Tvrtko Ursulin <tvrtko@ursulin.net>
Cc: linux-ext4@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.33-rc2] kernel BUG at fs/ext4/inode.c:1063!
Message-ID: <20100104010836.GA4527@thunk.org>
Mail-Followup-To: tytso@mit.edu, Tvrtko Ursulin <tvrtko@ursulin.net>,
	linux-ext4@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <201001031638.57331.tvrtko@ursulin.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001031638.57331.tvrtko@ursulin.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 03, 2010 at 04:38:57PM +0000, Tvrtko Ursulin wrote:
> 
> As much as it was visible, all writeout stopped after this happened so I could 
> only capture it with the camera. Please see the attachment.

This is a known bug.  The the latest mainline version of Linux (I
think 2.6.33-rc2-git4 includes the necessary patch) will no longer
BUG.  There are two more patches which I'm about to push to Linus that
are necessary to fix up a typo and some potential undesirable side
effects of the initial fix of the problem.  If you want to get all of
the fixes, pull in the changes from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

Regards,

						- Ted

