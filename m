Return-Path: <linux-kernel-owner+w=401wt.eu-S1761679AbXIXSWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761679AbXIXSWP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 14:22:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758518AbXIXSWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 14:22:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754502AbXIXSV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 14:21:59 -0400
Date: Mon, 24 Sep 2007 14:21:26 -0400
From: Dave Jones <davej@redhat.com>
To: David Newall <david@davidnewall.com>
Cc: Antoine Martin <antoine@nagafix.co.uk>, tytso@thunk.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: bug in fsck or ext2/ext3?
Message-ID: <20070924182125.GN11455@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	David Newall <david@davidnewall.com>,
	Antoine Martin <antoine@nagafix.co.uk>, tytso@thunk.org,
	Linux Kernel Development <linux-kernel@vger.kernel.org>
References: <46F7EC47.9010803@nagafix.co.uk> <20070924170439.GF8127@redhat.com> <46F7FEF9.2070702@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F7FEF9.2070702@davidnewall.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2007 at 03:46:25AM +0930, David Newall wrote:
 > Dave Jones wrote:
 > > On Mon, Sep 24, 2007 at 05:56:39PM +0100, Antoine Martin wrote:
 > >
 > >  > # rm -fr tmp/chroot.broken
 > >  > rm: cannot remove directory (...)
 > >  > Same result when trying to do anything to those files chown/chmod/touch:
 > >  > "Operation not permitted"
 > >
 > > Various files in the directories it complains about have their 'i'
 > > bit set.  lsattr will show you.   chattr -i those files, and the
 > > directory is removable again.
 > 
 > Additionally, this is a classic symptom of malware.  A directory  named 
 > "..." is a big hint.

That was "..." as in "more stuff follows" rather than the actual name
being reported.

	Dave

-- 
http://www.codemonkey.org.uk
