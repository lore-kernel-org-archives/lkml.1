Return-Path: <linux-kernel-owner+w=401wt.eu-S1758219AbYGQHTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219AbYGQHTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754851AbYGQHTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:19:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:49299 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541AbYGQHTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:19:11 -0400
Date: Thu, 17 Jul 2008 00:07:59 -0700
From: Greg KH <greg@kroah.com>
To: Milton Miller <miltonm@bga.com>
Cc: Greg KH <gregkh@suse.de>, Michael Ellerman <michael@ellerman.id.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH/RFC] pci: dynids.use_driver_data considered harmful
Message-ID: <20080717070759.GE22090@kroah.com>
References: <for-27-patch1-0@bga.com> <for-27-patch9@bga.com> <20080712041137.GA5933@kroah.com> <e6b3109a0ab047bea58ceecb8734761d@bga.com> <0a67ecbf69649dce778db1b463e59c3a@bga.com> <ad61f8387a737bc410e9d6dc3a8a5b63@bga.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad61f8387a737bc410e9d6dc3a8a5b63@bga.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 05:18:18AM -0500, Milton Miller wrote:
>
> Greg,
>
> Please respond to this email and explain why the patch
>
> pci: dynids.use_driver_data considered harmful
>
> http://www.ussg.iu.edu/hypermail/linux/kernel/0807.1/index.html#2188
>
> should not be applied.   I am not arguing the correctness of
> the removed code, rather its utility and benefit to the linux
> community.
>
> As far as I can tell, the code only succeeds in limiting the
> usefulness of the pci dynamic id addition mechanism.  We chose
> not to limit which drivers can have a table entry added, now
> let us not limit telling the driver which previous entry is
> most similar to our new entry.
>
> If a driver doesn't set this bit, and only 3 out of 419 do,
> then the facility can only be used if the driver can function
> correctly with the data zero.  In some drivers (radeonfb) a
> nonzero flag is always set, in some a list of boards or
> chipsets is listed in an arbitrary order (e1000e), and in yet
> others the field is used as a pointer without checking for NULL
> (DAC960, iwl3945).
>
>
>
> You sent your request for others to withdraw the patch
> from consideration when I resent the patch without seeing your
> comments that were less than 12 hours old, but have been silent
> for the last 60 hours since I responded to them over the next
> several hours.   If I do not hear from you with technical
> arguments for keeping the code, I will resend the patch for
> consideration.

Sorry, I'm on the road right now and will not get back until Friday.
Then I have the big merges with Linus to get through.  I'll try to get
to this by Monday, but my original point still stands, this was
implemented for a reason, saying that not enough drivers use it properly
does not make the need for it to go away.  It is required for them, so
perhaps the other 419 drivers also need to have the flag set.  That's
pretty trivial to do, right?

thanks,

greg k-h
