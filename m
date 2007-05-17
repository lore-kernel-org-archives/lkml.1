Return-Path: <linux-kernel-owner+w=401wt.eu-S1758250AbXEQOsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250AbXEQOsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 10:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755019AbXEQOsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 10:48:12 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:39318 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378AbXEQOsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 10:48:10 -0400
Subject: Re: Apparent Deadlock with nfsd/jfs on 2.6.21.1 under bonnie.
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Roger Heflin <rheflin@atipa.com>
Cc: linux-kernel@vger.kernel.org, nfs@lists.sourceforge.net
In-Reply-To: <464C68A0.2050003@atipa.com>
References: <4649BED9.6090207@atipa.com>
	 <pan.2007.05.15.22.03.07.359081@linux.vnet.ibm.com>
	 <464C68A0.2050003@atipa.com>
Content-Type: text/plain
Date: Thu, 17 May 2007 09:48:07 -0500
Message-Id: <1179413287.13965.24.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-17 at 09:37 -0500, Roger Heflin wrote:
> Dave Kleikamp wrote:
> 
> > 
> > I don't have an answer to an ext3 deadlock, but this looks like a jfs
> > problem that was recently fixed in linux-2.6.22-rc1.  I had intended to
> > send it to the stable kernel after it was picked up in mainline, but
> > hadn't gotten to it yet.
> > 
> > The patch is here:
> > http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=05ec9e26be1f668ccba4ca54d9a4966c6208c611
> > 
> 
> Dave,
> 
> That appears to have fixed the JFS hangup.
> 
> MTBF before was about 1 hour, under the same test I am over 20 hours
> and things appear to still be holding together.

Great.  The patch is queued for the 2.6.21 stable tree now.

Thanks,
Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

