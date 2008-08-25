Return-Path: <linux-kernel-owner+w=401wt.eu-S1756048AbYHYTbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048AbYHYTbV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 15:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754487AbYHYTbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 15:31:12 -0400
Received: from mail.atheros.com ([12.36.123.2]:39740 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375AbYHYTbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 15:31:11 -0400
Date: Mon, 25 Aug 2008 12:31:09 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Tomas Winkler <tomasw@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>, Mirco Tischler <mt-ml@gmx.de>,
       Leonid Podolny <leonidp.lists@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "yi.zhu@intel.com" <yi.zhu@intel.com>,
       "reinette.chatre@intel.com" <reinette.chatre@intel.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "IvDoorn@gmail.com" <IvDoorn@gmail.com>
Subject: Re: CPU load after killing iwlagn with RF kill switch
Message-ID: <20080825193109.GE6007@tesla>
References: <48A5EC02.4070303@gmail.com> <20080817035921.4d35ae0e@mtlp.12thdimension> <1ba2fa240808170004p63b76db1l1fdfb1cf1cb41636@mail.gmail.com> <20080817150242.GA23926@tuxdriver.com> <1ba2fa240808170920r67e11567h2da8b396b18729dd@mail.gmail.com> <20080817170714.GA29938@tuxdriver.com> <1ba2fa240808171101j8a7a94dn6be58fe1a8f46dbd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1ba2fa240808171101j8a7a94dn6be58fe1a8f46dbd@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 17, 2008 at 11:01:26AM -0700, Tomas Winkler wrote:
> On Sun, Aug 17, 2008 at 8:07 PM, John W. Linville
> <linville@tuxdriver.com> wrote:
> > On Sun, Aug 17, 2008 at 07:20:54PM +0300, Tomas Winkler wrote:
> >> On Sun, Aug 17, 2008 at 6:02 PM, John W. Linville
> >> <linville@tuxdriver.com> wrote:
> >> > On Sun, Aug 17, 2008 at 10:04:12AM +0300, Tomas Winkler wrote:
> >> >
> >> >> There is gap in current rfkill implementation that we didn't close
> >> >> yet.  There were also few patches that were not signed by Intel and
> >> >> are apparently wrong.
> >> >
> >> > Can you be more specific?  Do you know which patches are wrong (even
> >> > if you don't know how to fix them)?
> >> >
> >>
> >> 80fcc9e28cf3a209fbfb39a7bbddc313c59c7424
> >> This one  is wrong and there are more then are not acked even though
> >> they cause no problem. In general I would prefer that patches will be
> >> acked by Yi or me.
> >
> > And in general, they are.  In general I would prefer if you would
> > work upstream instead of working in iwlwifi-2.6 and periodically
> > dumping a dozen or more patches on me all at once.  C'est la vie...
> 
> We cannot because no OSV or OEM ships latest kernel and mac80211 is
> periodically broken.  There is a reason why compat-wireless was
> brought to life. The  innovation to stabilization and testing ratio is
> not good. This is of course more complex than that and I didn't find
> the golden way yet.

compat-wireless came to life to prevent alternative tree solutions, to
prevent patch hogging in separate trees and to try to help with backward
compatibility. That was my main motivation. If mac80211 is broken I see
no one but ourselves to blame.

OEMs should rely on stock kernels distributions pick. If patches are needed
on top of that then patch *fixes* should be supplied on top of the stable
kernel. Development work (cleanups, etc) can go onto wireless-testing
then.

  Luis
