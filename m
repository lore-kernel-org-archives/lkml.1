Return-Path: <linux-kernel-owner+w=401wt.eu-S1764513AbXEYRiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764513AbXEYRiA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 13:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbXEYRhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 13:37:54 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:36672 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbXEYRhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 13:37:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=jJ3MdUhDgC/wXIcx3RGJZ6mTVUOSZJ82vYIBpwE+24NjriOfcyJuNsA96e5VAlVWhhoPHlf+e2yPZhdNEojzmph3USc3hkl40h8kYDABH415awg7E1HuKcr25gYdzFvs584Rcf6MOZ6ur8zy5E+bm/CS9kB9bAYKob4mhvV55Rw=
Message-ID: <3ae72650705251037p6b1632a5m45cdd999a294fcbd@mail.gmail.com>
Date: Fri, 25 May 2007 19:37:46 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: 2.6.22-rc2-mm1: NetworkManager fails to find ipw2200 again
Cc: "Matt Mackall" <mpm@selenic.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, yi.zhu@intel.com
In-Reply-To: <20070525164842.GA6220@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070525163621.GE11166@waste.org> <20070525164842.GA6220@suse.de>
X-Google-Sender-Auth: 4056fb76fb61127a
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/25/07, Greg KH <gregkh@suse.de> wrote:
> On Fri, May 25, 2007 at 11:36:22AM -0500, Matt Mackall wrote:
> > 2.6.22-rc2 works. CONFIG_SYSFS_DEPRECATED = y, though that shouldn't
> > matter. Bringing up the interface manually still works, so I suspect
> > this is sysfs or HAL related again. Again, Debian unstable so
> > userspace is quite up-to-date.
>
> I don't have any driver model changes that affect network devices in my
> tree.  Could you go through and bisect the -mm tree to see if you can
> find the patch that causes this?

Does it work, when you unload and load the kernel module?
Does it work when you restart HAL and then NetworkManager?
Can you compare the sections for the wireless card in the output of "lshal"?

Kay
