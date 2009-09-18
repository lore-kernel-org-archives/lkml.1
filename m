Return-Path: <linux-kernel-owner+w=401wt.eu-S1752604AbZIRO0C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604AbZIRO0C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 10:26:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbZIRO0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 10:26:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:35011 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbZIROZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 10:25:59 -0400
Date: Fri, 18 Sep 2009 16:25:54 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Badari Pulavarty <pbadari@us.ibm.com>, Jan Kara <jack@suse.cz>,
       linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Is nobh code still useful?
Message-ID: <20090918162554.13a72664@infradead.org>
In-Reply-To: <20090918141226.GB26991@mit.edu>
References: <20090917135627.GB13660@duck.suse.cz>
	<4AB30AD1.7010400@us.ibm.com>
	<20090918141226.GB26991@mit.edu>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Sep 2009 10:12:26 -0400
Theodore Tso <tytso@mit.edu> wrote:

> On Thu, Sep 17, 2009 at 09:21:37PM -0700, Badari Pulavarty wrote:
> >
> > Originally it was supported on ext2. I added support nobh support
> > for ext3. At that time, the main
> > issue/complaint was that, these bufferheads consume memory from  
> > ZONE_NORMAL causing
> > memory pressure on 32-bit (i386) configurations.
> 
> Specifically, it matters on very large configuration systems (i.e.,
> 32GB-64GB using PAE-36) that today we'd probably just say, "use
> x86_64, you moron".  It would probably matter if someone were to want
> to upgrade a non-64-bit capable machine to a newer kernel.  
> 
> Dropping nobh from ext3 at this point might prevent some of these
> older systems from upgrading, I'm not sure how much we would care; on
> the one hand, these machines tended to be pretty expensive, so people
> would probably want to use them for a while.  On the other hand, it
> has been over five years now since x86_64 machines have been
> available, and many of these customers are highly unlikely to want to
> upgrade anyway.

isn't the converse to just make nobh the default but not an option a
better approach then?
I forgot why this was a good idea to be an option again ;-)



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
