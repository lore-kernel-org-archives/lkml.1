Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707Ab0CKKAU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 05:00:20 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:33604 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756635Ab0CKKAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 05:00:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=o57TeXSAVIUx+QNJhtScKH93Vmw038Va4qAuxLA4X0dZj/HbXDTlXUzBM8zXpCIvSa
         hzrR0YoxgbucPQMQvkDSDcPEYi0tHFcsqUAYSCRNApzMbYMPB25KAgfECAXuD98yChuA
         Rp2y8reUjQK/57kDIl7912Bi9AidgCfxQF/M8=
Date: Thu, 11 Mar 2010 12:59:40 +0300
From: Dan Carpenter <error27@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Julia Lawall <julia@diku.dk>, linux-kernel@vger.kernel.org, gregkh@suse.de,
       kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: smatch_scripts/whitespace_only.sh
Message-ID: <20100311095940.GK6321@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Joe Perches <joe@perches.com>, Julia Lawall <julia@diku.dk>,
	linux-kernel@vger.kernel.org, gregkh@suse.de,
	kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org
References: <20100310101224.GC6321@bicker> <Pine.LNX.4.64.1003101113330.24684@ask.diku.dk> <20100310142759.GG6321@bicker> <Pine.LNX.4.64.1003101537040.27249@ask.diku.dk> <1268244709.1545.392.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268244709.1545.392.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 10:11:49AM -0800, Joe Perches wrote:
> On Wed, 2010-03-10 at 15:38 +0100, Julia Lawall wrote:
> > > > On Wed, 10 Mar 2010, Dan Carpenter wrote:
> > > > > I wrote a script to check that a patch only changes white space.
> 
> Perhaps you could use #define __LINE__ 0 to avoid
> any vertical line position comparison checks?
> 

I tried something similar to that at first but I found that line 
numbers were used in other ways.  In the end, I added a -no-lineno to
sparse so it thinks everything is on line 123456.

It might be better to just right a perl script that strips out all the
whitespace and compares the result blobs before and after the patch.  
That would handle the #if 0 code as well.

regards,
dan carpenter

> > Maybe checkpatch could be changed to not complain about > 80 characters 
> > when the line contains a string?
> 
> That's been at least partially done in commit
> 691e669ba8c64d31ac08d87b1751e6acfa3ff65e
