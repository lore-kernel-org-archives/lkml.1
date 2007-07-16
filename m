Return-Path: <linux-kernel-owner+w=401wt.eu-S1764681AbXGPFih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764681AbXGPFih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 01:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760647AbXGPFiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 01:38:22 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:65267 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759771AbXGPFiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 01:38:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=LfskfyiZ6MQCPH4Ex8Qm3xDm0h/Ru+1Bt0kAV/cqxFZlKCHUcoldqR4U0OgYV7AgEjc2K9u/8A2h5Gq6C9qrkrx0p3zd9msSy4YX/jkbt6lqJ26ga+BPTiv58EWWQONoPqiqpHAps3CjCUBOjTbn6r+q0C/Of/Z9wqZsMkXGTsw=
Date: Mon, 16 Jul 2007 01:37:52 -0400
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Joseph Fannin <jfannin@gmail.com>, david@lang.hm,
       "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: Hibernating To Swap Considered Harmful
Message-ID: <20070716053751.GA13707@nineveh.local>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Joseph Fannin <jfannin@gmail.com>, david@lang.hm,
	"Huang, Ying" <ying.huang@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
	Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
	linux-pm@lists.linux-foundation.org
References: <1184167831.12556.13.camel@caritas-dev.intel.com> <200707131130.51279.rjw@sisk.pl> <20070714004517.GA18336@nineveh.local> <200707141148.18279.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707141148.18279.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: jfannin@gmail.com (Joseph Fannin)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, 2007 at 11:48:17AM +0200, Rafael J. Wysocki wrote:
> On Saturday, 14 July 2007 02:45, Joseph Fannin wrote:
> > On Fri, Jul 13, 2007 at 11:30:50AM +0200, Rafael J. Wysocki wrote:
> > > On Friday, 13 July 2007 07:42, Joseph Fannin wrote:
> > > > On Thu, Jul 12, 2007 at 08:06:43PM -0700, david@lang.hm wrote:
> > >
> > > If you're afraid of that, use a dedicated swap file.
> >
> >     I don't understand what you mean.  A dedicated swap file for what?
>
> Sorry, I should have been more precise.
>
> For hibernation (ie. a swap file that you activate right befor the
> hibernation).
>
> Also tuxonice (formerly known as suspend2) allows you to use regular files
> hibernation.

     How is that different from what I proposed, other than the
requirement to pass the swap data stuctures between the two kernels?

     Even if you only expect hibernation to work only _most of the
time_, suspending to swap means allocating a bunch of swap space that
you intend to never be used as swap.  The two functions don't really
belong together.

--
Joseph Fannin
jfannin@gmail.com

