Return-Path: <linux-kernel-owner+w=401wt.eu-S1759456AbXJaPb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759456AbXJaPb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 11:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761169AbXJaPap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 11:30:45 -0400
Received: from styx.suse.cz ([82.119.242.94]:55921 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761161AbXJaPao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 11:30:44 -0400
Date: Wed, 31 Oct 2007 16:30:43 +0100
From: Jan Kara <jack@suse.cz>
To: Andy Whitcroft <andyw@uk.ibm.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: 2.6.23-git18: ext2_check_page: bad entry in directory
Message-ID: <20071031153043.GA25466@duck.suse.cz>
References: <20071024131540.GV32058@shadowen.org> <20071024135900.GC2652@duck.suse.cz> <20071024143308.GA23139@shadowen.org> <20071024150302.GD2652@duck.suse.cz> <20071024170729.GC23139@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024170729.GC23139@shadowen.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 24-10-07 18:07:29, Andy Whitcroft wrote:
> On Wed, Oct 24, 2007 at 05:03:03PM +0200, Jan Kara wrote:
> 
> > e2image -r /dev/sda1 - | gzip -dc root-image.gz
> 
> This thing is 27MB, I'll try and find some space to hold it and
> let you know where it is offlist.
  The filesystem mounts just fine on my test machine under latest
kernel tree from git. So, do you still see the problem? What is your
hardware setup? Anything unusual I should be aware of?
  It seems (from the error message) as if we simply read a page full
of zeros from the root directory so it may be also a problem somewhere
else...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
