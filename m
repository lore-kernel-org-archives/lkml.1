Return-Path: <linux-kernel-owner+w=401wt.eu-S935984AbXGMHQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935984AbXGMHQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 03:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbXGMHQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 03:16:33 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:22110 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbXGMHQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 03:16:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=paSCnLhYSk74TJrOOG+8tkohiqBAtQAqCQq48+zPTrDCkR2Yl6rE2X4hsLXIxKn4gCDQcG9ejspvsjj4imhli9+YZDnTpkN8vUETNAq5JUHs5lsLNGlooJLVwM1oFwyltAxIznF47D35hXaz/jCVuaGh5RDnoax7Cx8U/Hk3N4s=
Message-ID: <3ae72650707130016k3721e9ddube218a998a0db828@mail.gmail.com>
Date: Fri, 13 Jul 2007 09:16:31 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
Subject: Re: [2.6.23 PATCH 13/18] dm: netlink
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Mackall" <mpm@selenic.com>, "Alasdair G Kergon" <agk@redhat.com>,
       dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       "Mike Anderson" <andmike@us.ibm.com>, netdev@vger.kernel.org
In-Reply-To: <20070713070321.GA10361@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070711210137.GE24114@agk.fab.redhat.com>
	 <20070711142712.e646995b.akpm@linux-foundation.org>
	 <20070712231920.GZ11166@waste.org>
	 <20070712163115.ee686f8d.akpm@linux-foundation.org>
	 <20070713070321.GA10361@2ka.mipt.ru>
X-Google-Sender-Auth: ab9c5bd76963b66d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/13/07, Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> On Thu, Jul 12, 2007 at 04:31:15PM -0700, Andrew Morton (akpm@linux-foundation.org) wrote:
> > > > Need a dependency on NET there?
> > >
> > > It's really sad to make DM dependent on the network layer.
> > >
> >
> > Yes, it would be somewhat sad.  However one can presumably continue to use
> > DM, just without "DM netlink events".
>
> On my machine device mapper (lvm, raid) does not work without sockets,
> (maybe not dm, but hotplug, which creates nodes, or configuration)
> so it already depends on it. Hotplug depends on networking.
>
> You missed the day when everyone started to depend on networking :)

Right, uevents (udev) depend on networking. One could still use the
/sbin/hotplug fork-bomb, but boxes that don't want networking are
often that small, that the amount of events the kernel creates today,
leads immediately to OOM, because of too many event processes forked
at the same time.

Kay
