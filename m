Return-Path: <linux-kernel-owner+w=401wt.eu-S1760178AbZAMJtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760178AbZAMJtv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 04:49:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbZAMJtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 04:49:42 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:57486 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007AbZAMJtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 04:49:41 -0500
Date: Tue, 13 Jan 2009 10:49:32 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Message-ID: <20090113094932.GH31787@enneenne.com>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org> <20090106225744.GA10553@infradead.org> <20090106151915.df138883.akpm@linux-foundation.org> <20090108191152.GU15123@enneenne.com> <20090112202336.GB27636@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112202336.GB27636@infradead.org>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: 2.6.29 -mm merge plans
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 03:23:36PM -0500, Christoph Hellwig wrote:
> On Thu, Jan 08, 2009 at 08:11:53PM +0100, Rodolfo Giometti wrote:
> > With "kernel-doc" do you mean what explained into
> > Documentation/kernel-doc-nano-HOWTO.txt file?
> 
> Yes.

Ok, I'll fix it ASAP.

> > > > pps.h shoulkd be split into one header only defining the
> > > > kernel<->userspace ABI, and a kernel-internal one.  That way
> > > > also the conditional includes can go away.
> > 
> > I don't understand well what I should do here... I supposed __KERNEL__
> > define was defined to allow mixing kernel and userland code.
> 
> Yes, __KERNEL__ works, but it's still better to just keep things
> entirely separate.

Ok, I'll see what I can do considering the userland interface we
decide to use. I'll ask also to Alan about this topic.

Thanks for your suggestions,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
