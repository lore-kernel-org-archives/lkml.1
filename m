Return-Path: <linux-kernel-owner+w=401wt.eu-S1758439AbZC0GVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758439AbZC0GVc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 02:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbZC0GVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 02:21:23 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:45336 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbZC0GVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 02:21:23 -0400
Date: Fri, 27 Mar 2009 06:21:14 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090327062114.GA18290@srcf.ucam.org>
References: <20090325220530.GR32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090327032301.GN6239@mit.edu> <20090327034705.GA16888@srcf.ucam.org> <20090327051338.GP6239@mit.edu> <20090327055750.GA18065@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090327055750.GA18065@srcf.ucam.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 27, 2009 at 05:57:50AM +0000, Matthew Garrett wrote:

> Well, no. fsync() didn't appear in early Unix, so what people were 
> actually willing to live with was restoring from backups if the system 
> crashed. I'd argue that things are somewhat better these days, 
> especially now that we're used to filesystems that don't require us to 
> fsync(), close(), fsync the directory and possibly jump through even 
> more hoops if faced with a pathological interpretation of POSIX. 
> Progress is a good thing. The initial behaviour of ext4 in this respect 
> wasn't progress.

And, hey, fsync didn't make POSIX proper until 1996. It's not like 
authors were able to depend on it for a significant period of time 
before ext3 hit the scene.

(It could be argued that most relevant Unices implemented fsync() even 
before then, so its status in POSIX was broadly irrelevant. The obvious 
counterargument is that most relevant Unix filesystems ensure that data 
is written before a clobbering rename() is carried out, so POSIX is 
again not especially releant)
-- 
Matthew Garrett | mjg59@srcf.ucam.org
