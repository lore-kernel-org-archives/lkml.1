Return-Path: <linux-kernel-owner+w=401wt.eu-S1757355AbXFTXJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355AbXFTXJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 19:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757220AbXFTXJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 19:09:46 -0400
Received: from mx.treblig.org ([80.68.94.177]:4490 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756881AbXFTXJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 19:09:44 -0400
X-Greylist: delayed 1683 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Jun 2007 19:09:44 EDT
Date: Wed, 20 Jun 2007 23:41:35 +0100
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Karel Zak <kzak@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
Subject: Re: Adding subroot information to /proc/mounts, or obtaining that through other means
Message-ID: <20070620224135.GC6258@gallifrey>
References: <467994BD.6000403@zytor.com> <20070620220551.GX7226@petra.dvoda.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070620220551.GX7226@petra.dvoda.cz>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.20.3-bytemark-uml-2 (i686)
X-Uptime: 23:38:12 up 47 days, 16:21,  1 user,  load average: 0.37, 0.43, 0.44
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Karel Zak (kzak@redhat.com) wrote:
> On Wed, Jun 20, 2007 at 01:57:33PM -0700, H. Peter Anvin wrote:
> > 

<snip>

> > ... or, alternatively, add a subfield to the first field (which would
> > entail escaping whatever separator we choose):
> > 
> > /dev/md6 /export ext3 rw,data=ordered 0 0
> > /dev/md6:/users/foo /home/foo ext3 rw,data=ordered 0 0
> > /dev/md6:/users/bar /home/bar ext3 rw,data=ordered 0 0
> 
>  We needn't a new separator (':') there already is one (' ').

What happens with the (sick) case of spaces in directory names?
Also is it really nicely defined that there is no way to put a space
in an option in any of the filesystems?   I suppose someone
particularly sick could have a device node in a directory with a space
in it.  It would be nice if new formats for this are being defined
to make it cover everything.

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
