Return-Path: <linux-kernel-owner+w=401wt.eu-S1753378Ab0AHMjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab0AHMjP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 07:39:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285Ab0AHMjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 07:39:14 -0500
Received: from cantor.suse.de ([195.135.220.2]:59614 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226Ab0AHMjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 07:39:13 -0500
Date: Fri, 8 Jan 2010 13:39:15 +0100
From: Jan Kara <jack@suse.cz>
To: Dmitry Monakhov <rjevskiy@gmail.com>
Cc: Greg KH <gregkh@suse.de>, Thomas Voegtle <tv@lio96.de>,
       Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.31.10
Message-ID: <20100108123915.GB3354@quack.suse.cz>
References: <20100106234533.GC1960@kroah.com>
 <alpine.LNX.2.00.1001071522480.5426@er-systems.de>
 <20100107180449.GA17495@suse.de>
 <alpine.LNX.2.00.1001072033301.26784@er-systems.de>
 <20100107194131.GA22983@suse.de>
 <alpine.LNX.2.00.1001072125040.26784@er-systems.de>
 <alpine.LNX.2.00.1001072141340.26784@er-systems.de>
 <20100107220213.GA24882@suse.de>
 <c18d6aa21001071603hbe4935clf78984fc837e4bd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c18d6aa21001071603hbe4935clf78984fc837e4bd@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 08-01-10 03:03:30, Dmitry Monakhov wrote:
> 2010/1/8 Greg KH <gregkh@suse.de>:
> > On Thu, Jan 07, 2010 at 09:42:52PM +0100, Thomas Voegtle wrote:
> >> On Thu, 7 Jan 2010, Thomas Voegtle wrote:
> >>
> >>> Done, between 2.6.31.9 and 2.6.31.11
> >>>
> >>>
> >>> c169e13a6662cbf36fc0098508e7aa31b49cbf23 is first bad commit
> >>> commit c169e13a6662cbf36fc0098508e7aa31b49cbf23
> >>> Author: Dmitry Monakhov <dmonakhov@openvz.org>
> >>> Date:   Mon Dec 14 15:21:13 2009 +0300
> >>>
> >>>    quota: decouple fs reserved space from quota reservation
> >>>
> >>>    commit fd8fbfc1709822bd94247c5b2ab15a5f5041e103 upstream.
> Ohhh No...
> This is totaly my fault. after some cleanups i've forgot to test
> ext3+quota scenario :( . The error is trivial, it is too sad what this
> error
> was found this late.'
> calltrace:
> ->chown
>     ->dquot_transfer
>        ->inode_get_rsv_space
  Yeah, it's also my fault because I've tested your patches only with ext4
so this was not uncovered. I've actually noticed the bug on Wednesday
evening (and fixed it in my tree) but forgot to push it do stable :(

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
