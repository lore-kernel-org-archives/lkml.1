Return-Path: <linux-kernel-owner+w=401wt.eu-S1752451AbZBZCvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451AbZBZCvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 21:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbZBZCu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 21:50:58 -0500
Received: from THUNK.ORG ([69.25.196.29]:41077 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754763AbZBZCu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 21:50:57 -0500
Date: Wed, 25 Feb 2009 21:50:43 -0500
From: Theodore Tso <tytso@mit.edu>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <matthew@wil.cx>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       sandeen@redhat.com
Subject: Re: ATA support for 4k sector size
Message-ID: <20090226025043.GJ1363@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <matthew@wil.cx>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
	sandeen@redhat.com
References: <1235600698-6446-1-git-send-email-matthew@wil.cx> <49A5CBF7.9000501@zytor.com> <yq1hc2iumg9.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1hc2iumg9.fsf@sermon.lab.mkp.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 06:27:18PM -0500, Martin K. Petersen wrote:
> 
> Because of 63-sector legacy problems a bunch of ATA vendors will
> initially ship 512/4096 drives that are not naturally aligned.
> I.e. logical sector 63 will be aligned on a 4KB hardware sector
> boundary to overcome the misaligned default partitioning.
> 

Are we *sure* that this is what they plan to be doing?  Is there a way
we can query the hardware to find out for sure what drives are doing
what?

I'll note that Vista starts all new partitions at the 1MB boundary, so
its filesystems will be naturally aligned.  As I mentioned in a recent blog
entry:

http://thunk.org/tytso/blog/2009/02/20/aligning-filesystems-to-an-ssds-erase-block-size/

... this is one place Vista is ahead of Linux.  So while Microsoft's
market share has slipped, 85% of all new x86 machines still have some
variant of Redmond-spawn installed on them, and with the advent of
Windows 7 coming soon, and Microsoft making it harder and harder for
vendors to ship machines upgraded to Windows XP, it
seems... surprising... that new disks meant for Windows Vista or
Windows 7 systems would be misaligned to start at logical sector 63.

						- Ted

