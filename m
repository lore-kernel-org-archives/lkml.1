Return-Path: <linux-kernel-owner+w=401wt.eu-S1756774AbXKARLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774AbXKARLa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 13:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753136AbXKARLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 13:11:23 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:4122 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbXKARLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 13:11:22 -0400
Date: Thu, 1 Nov 2007 17:10:58 +0000
From: Andy Whitcroft <andyw@uk.ibm.com>
To: Jan Kara <jack@suse.cz>
Cc: Andy Whitcroft <andyw@uk.ibm.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: 2.6.23-git18: ext2_check_page: bad entry in directory
Message-ID: <20071101171058.GA26622@shadowen.org>
References: <20071024131540.GV32058@shadowen.org> <20071024135900.GC2652@duck.suse.cz> <20071024143308.GA23139@shadowen.org> <20071024150302.GD2652@duck.suse.cz> <20071024170729.GC23139@shadowen.org> <20071031153043.GA25466@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071031153043.GA25466@duck.suse.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2007 at 04:30:43PM +0100, Jan Kara wrote:
> On Wed 24-10-07 18:07:29, Andy Whitcroft wrote:
> > On Wed, Oct 24, 2007 at 05:03:03PM +0200, Jan Kara wrote:
> > 
> > > e2image -r /dev/sda1 - | gzip -dc root-image.gz
> > 
> > This thing is 27MB, I'll try and find some space to hold it and
> > let you know where it is offlist.
>   The filesystem mounts just fine on my test machine under latest
> kernel tree from git. So, do you still see the problem? What is your
> hardware setup? Anything unusual I should be aware of?
>   It seems (from the error message) as if we simply read a page full
> of zeros from the root directory so it may be also a problem somewhere
> else...

Yes this works with the latest git tree.  This problem only was visible
with 2.6.24-rc1, -git1 onwards was ok.

-apw
