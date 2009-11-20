Return-Path: <linux-kernel-owner+w=401wt.eu-S1753804AbZKTOnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbZKTOnj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 09:43:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbZKTOni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 09:43:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:34219 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbZKTOnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 09:43:37 -0500
Date: Fri, 20 Nov 2009 06:45:11 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Kok, Auke" <auke-jan.h.kok@intel.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       "Wu, Fengguang" <fengguang.wu@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] vfs: Add a trace point in the mark_inode_dirty function
Message-ID: <20091120064511.268cc8fd@infradead.org>
In-Reply-To: <20091120104335.GB29143@infradead.org>
References: <20091025225342.007138f5@infradead.org>
	<20091111020108.GA11423@localhost>
	<20091110223456.01ef355f@infradead.org>
	<4AFA6AEF.5060306@garzik.org>
	<20091111081905.270a4e55@infradead.org>
	<y0m3a4kpsiw.fsf@fche.csb>
	<4AFB4AC7.1090405@intel.com>
	<20091112072217.GA31719@elte.hu>
	<20091120104335.GB29143@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Nov 2009 05:43:35 -0500
Christoph Hellwig <hch@infradead.org> wrote:

> 
> Which btw brings up another good argument - to make the tracing really
> useful we need to have conventions.  While the inode number seems to
> be a realtively easy one printing the device is more difficult.  XFS
> just prints the raw major/minor to stay simple, ext4 has a
> complicated ad-hoc cache of device names, and this one just prints
> the superblock id string.

I was just trying to stay compatible with blockdump, and it even makes
sense ;)

> 
> Of course for a user the name is a lot more meaninful, but also
> relatively expensive to generate.  Then again I'm not even sure how
> the last pathname component only here is all that useful - it can't
> be used to easily find the file.

in my case it's not about finding the file, but finding the place in
the application that is doing the writing. The last pathname component
is more than enough for this....

> 


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
