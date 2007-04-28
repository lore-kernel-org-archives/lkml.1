Return-Path: <linux-kernel-owner+w=401wt.eu-S1030963AbXD1DIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030963AbXD1DIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 23:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030968AbXD1DIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 23:08:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030963AbXD1DIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 23:08:16 -0400
Date: Fri, 27 Apr 2007 23:08:05 -0400
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: checkpatch, a patch checking script.
Message-ID: <20070428030805.GA13331@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	linux-kernel@vger.kernel.org
References: <20070423141123.GA21174@skybase> <20070423104534.51bac974.akpm@linux-foundation.org> <20070425112133.4ae86399.randy.dunlap@oracle.com> <20070425143011.57247c1d.akpm@linux-foundation.org> <20070425172447.1576c399.akpm@linux-foundation.org> <20070426003911.GA19383@redhat.com> <4630109F.6090002@oracle.com> <20070425200207.77a2721a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425200207.77a2721a.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 08:02:07PM -0700, Andrew Morton wrote:

 > > Yep, I was going to mention your scripts but you beat me to it.
 > > 
 > > I'll be glad to help maintain such animals if wanted.
 > > 
 > wanted ;)
 > 
 > At least, it would be interesting to investigate the usefulness.  I suspect
 > it will prove to be very useful for the little things.

Randy and I got together and hashed out a first cut at this.
(Randy actually gutted quite a lot of what I originally wrote, so deserves
 much kudos for improving this beyond my initial crappy version).
You can find the script at http://www.codemonkey.org.uk/projects/checkpatch/
There's also a git clonable tree there (only http right now).

http://www.codemonkey.org.uk/projects/checkpatch/example.log shows
what fell out of running it on my mbox of lkml from the past month.
Some of them are kinda noisy, and perhaps should be moved under --pedantic

I'm all ears for additional regexps, bug reports or other suggestions.

Before wiring this up to a procmail rule to scan every patch, I think it's
probably a better idea to flesh it out a bit more.

	Dave

-- 
http://www.codemonkey.org.uk
