Return-Path: <linux-kernel-owner+w=401wt.eu-S1753448AbYJ1Ak4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbYJ1Ak4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 20:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbYJ1Akd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 20:40:33 -0400
Received: from kroah.org ([198.145.64.141]:36215 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751932AbYJ1Akb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 20:40:31 -0400
Date: Mon, 27 Oct 2008 17:29:19 -0700
From: Greg KH <greg@kroah.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "otus-devel@lists.madwifi-project.org" 
	<otus-devel@venema.h4ckr.net>,
       Johannes Berg <johannes@sipsolutions.net>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       Joey Krane <linuxbsd2004@gmail.com>
Subject: Re: [otus-devel] Release of Atheros 802.11n USB Linux driver
Message-ID: <20081028002919.GB2992@kroah.com>
References: <43e72e890810211904x7bd243dem68dfcfe7a795ec6f@mail.gmail.com> <20081022065045.GA2400@kroah.com> <20081023062655.GA8039@kroah.com> <20081023111103.GB5979@tesla> <43e72e890810271635i5b6dd6e4ua06b48e624991435@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43e72e890810271635i5b6dd6e4ua06b48e624991435@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2008 at 04:35:11PM -0700, Luis R. Rodriguez wrote:
> On Thu, Oct 23, 2008 at 4:11 AM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
> > On Wed, Oct 22, 2008 at 11:26:55PM -0700, Greg KH wrote:
> >> On Tue, Oct 21, 2008 at 11:50:45PM -0700, Greg KH wrote:
> >> > On Tue, Oct 21, 2008 at 07:04:17PM -0700, Luis R. Rodriguez wrote:
> >> > > We would like to see our Atheros 802.11n USB Linux driver upstream
> >> > > however we need help with this so we are releasing our Atheros 11n USB
> >> > > Otus Linux driver under the ISC to the community. The goal is to work
> >> > > with the community to help move this forward upstream. We are hoping
> >> > > for community help and leadership on this (*cough*).
> >> >
> >> > Yeah!
> >> >
> >> > I'll grab this and put it in drivers/staging/ so it gets some users and
> >> > more developers to help out with it.
> >>
> >> Ok, it seems to need some basic work to merely build properly on
> >> "modern" kernel versions.
> >
> > Yeah, it works up to 2.6.24.
> 
> This is now fixed on the master branch, also the branch "for-upstream"
> does a lot of cleanup I thought you may like before stuffing it into
> staging like removing all KERNEL_VERSION checks, all wireless
> extensions checks, some compile warnings, removal of compat, dos2unix,
> use utf-8, etc. Unfortunately this still requires a specific version
> of wpa_supplicant but it seems it works. Not sure what bars you have
> for staging at this point.

Pretty much the only "bar" is "it compiles" :)

> Will you take this in, and expect patches for fixing it to use
> standard wext and also report standard wireless statistic (yeap, this
> is not there yet either).

Yes, I can do that.

> Joey is one user which reported the driver working now with the
> compile fixes for newer kernels for 2.6.28-rc2 using the specific
> version of wpa_supplicant for it.
> 
> Joey can you test the for-upstream branch on otus git?

If someone can tell me what device this is for, I can try to go buy it
so that I can verify changes I make don't drasticly break things.

I'll go try to get this tree into a buildable state and put it into
staging tonight.

thanks,

greg k-h
