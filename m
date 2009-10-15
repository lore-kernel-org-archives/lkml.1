Return-Path: <linux-kernel-owner+w=401wt.eu-S935329AbZJOSpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935329AbZJOSpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 14:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935320AbZJOSpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 14:45:44 -0400
Received: from kroah.org ([198.145.64.141]:60261 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935282AbZJOSpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 14:45:14 -0400
Date: Thu, 15 Oct 2009 11:31:54 -0700
From: Greg KH <greg@kroah.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: =?iso-8859-1?B?RnLpZOlyaWMgTC4gVy4=?= Meunier <fredlwm@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, edt@aei.ca,
       hirofumi@mail.parknet.co.jp, alan@linux.intel.com,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: keyboard under X with 2.6.31
Message-ID: <20091015183154.GC3921@kroah.com>
References: <4AD17C6A.4030902@yahoo.co.uk>
 <alpine.LNX.2.01.0910111735140.19647@dyndns.pervalidus.net>
 <4AD37E05.5010504@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4AD37E05.5010504@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 09:05:41PM +0200, Marcin Slusarz wrote:
> Frédéric L. W. Meunier wrote:
> > On Sun, 11 Oct 2009, Boyan wrote:
> > 
> >> (sending again, sorry about last reply, wrong subject...)
> >> On Sat, 10 Oct 2009 21:00:05 -0400, Ed Tomlinson wrote:
> >>> You are not alone with keyboard problems in 31 in X.  In my case I
> >>> blamed a  new wireless setup.
> >>> I am building with the the above commit reverted.
> >>
> >> Not sure why, but after reverting
> >> e043e42bdb66885b3ac10d27a01ccb9972e2b0a3 (pty: avoid forcing
> >> 'low_latency' tty flag) my analog tv tuner stopped working after booting
> >> for the first time. It has TV and FM radio, but only radio worked when
> >> reverted this patch. I saw some EIO errors with strace. Then added again
> >> the patch and on top of it I've added commit:
> >>
> >> 3a54297478e6578f96fd54bf4daa1751130aca86
> >> pty: quickfix for the pty ENXIO timing problems
> >>
> >> Everything was ok.
> >> Today I've tried to reproduce this and reverted both patches. Recompiled
> >> and everything is ok. Not sure what happened yesterday.
> >> So to summarize 2.6.31.3 with reverted commit
> >> e043e42bdb66885b3ac10d27a01ccb9972e2b0a3 (pty: avoid forcing
> >> 'low_latency' tty flag) works for me.
> > 
> > Reverting the commit also works for me. Thanks.
> > 
> > The direct link, for those not using git:
> > 
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e043e42bdb66885b3ac10d27a01ccb9972e2b0a3
>  
> CC'ing Greg K-H

I've now queued up 3a54297478e6578f96fd54bf4daa1751130aca86 for the next
.31-stable release.

thanks for letting me know.

greg k-h
