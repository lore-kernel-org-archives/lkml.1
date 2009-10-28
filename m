Return-Path: <linux-kernel-owner+w=401wt.eu-S1753819AbZJ1WOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbZJ1WOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 18:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753103AbZJ1WOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 18:14:33 -0400
Received: from kroah.org ([198.145.64.141]:59019 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977AbZJ1WOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 18:14:33 -0400
Date: Wed, 28 Oct 2009 15:11:55 -0700
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>
Subject: Re: staging/dream: add gpio and pmem support
Message-ID: <20091028221155.GA25429@kroah.com>
References: <20091026234332.GB26583@kroah.com> <20091027001702.GA5019@elf.ucw.cz> <20091027030039.GA6195@kroah.com> <20091027081921.GG5019@elf.ucw.cz> <20091027165750.GA24477@kroah.com> <20091027193330.GB19379@elf.ucw.cz> <20091027204445.GA28878@kroah.com> <20091027232521.GA16782@elf.ucw.cz> <20091028155116.GA1434@kroah.com> <20091028215612.GB8053@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091028215612.GB8053@elf.ucw.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 28, 2009 at 10:56:12PM +0100, Pavel Machek wrote:
> 
> > > > With this patch, will it build properly?
> > > 
> > > Its certainly way closer to building... it builds for me, with
> > > something like below; platform devices really are initialized from
> > > board-* files and get passed parameters.
> > 
> > Ick.  This isn't ok, we can't take patches for staging stuff in files
> > outside of drivers/staging/
> 
> I know, I was trying to show that ammount of required changes is very small.
> 
> > So for now, I've deleted the drivers/staging/dream/ directory from my
> > tree, which will get pushed for 2.6.33.  Please clean the code up and
> > get it into buildable shape and I will be glad to add the drivers back
> > into the staging directory at that time.
> 
> Ok, I got something that builds; verifying it on device is hard, as
> last kernel that boots there is 2.6.29...
> 
> Should I turn it into series and submit?

Yes please.

thanks,

greg k-h
