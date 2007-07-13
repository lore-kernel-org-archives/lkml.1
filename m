Return-Path: <linux-kernel-owner+w=401wt.eu-S934904AbXGMGVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934904AbXGMGVE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 02:21:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbXGMGUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 02:20:55 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:2922 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbXGMGUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 02:20:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=hDLCMoZgAoKcw/RaRtWKDXLayeA44BWz1zNv96EE6snkYuSAfoyQGb9fDxH/AD6gqjcnUTXFNMQmL7VuJUvBD960WGh3klEKc2Y9qHLwHQc5DVaDl+36xC0c/84yC/Rma9aQo2VxzwBz67ydqK30YjTshSaSnoQt3u4tsXykvuE=
Date: Fri, 13 Jul 2007 02:20:39 -0400
To: david@lang.hm
Cc: Joseph Fannin <jfannin@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: Hibernating To Swap Considered Harmful
Message-ID: <20070713062039.GA29055@nineveh.local>
Mail-Followup-To: david@lang.hm, Joseph Fannin <jfannin@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	"Huang, Ying" <ying.huang@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
	Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
	linux-pm@lists.linux-foundation.org
References: <1184167831.12556.13.camel@caritas-dev.intel.com> <200707121453.49616.rjw@sisk.pl> <Pine.LNX.4.64.0707121150460.25614@asgard.lang.hm> <200707122134.29991.rjw@sisk.pl> <Pine.LNX.4.64.0707121953440.25614@asgard.lang.hm> <20070713054244.GA20082@nineveh.local> <Pine.LNX.4.64.0707122250170.25614@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707122250170.25614@asgard.lang.hm>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: jfannin@gmail.com (Joseph Fannin)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2007 at 10:57:04PM -0700, david@lang.hm wrote:
> On Fri, 13 Jul 2007, Joseph Fannin wrote:
>
> the only justification I have heard for why the hibernate image must be
> written to the swap partition is backwards compatibility (i.e., we've
> always done it that way)
>
> if you are going to reserve disk space for hibernation, what is so bad
> about useing a normal partition?
>
    You have to either repartition when you upgrade your memory, or
waste a bunch of disk space with a partition as large as you think
your RAM might ever expand to.

    Swap/hibernate files can be created, deleted, and resized without
partitioning.

    Also: not all platforms support a large number of partitions.
It's not academic -- Intel Macintoshes are limited to four, with two
taken by Mac OS.  Add Windows and a Linux /, and you're out --
there's no room for a swap file.

--
Joseph Fannin
jfannin@gmail.com

