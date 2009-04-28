Return-Path: <linux-kernel-owner+w=401wt.eu-S1754374AbZD1UqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbZD1UqW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 16:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbZD1UqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 16:46:06 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46431 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbZD1UqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 16:46:05 -0400
Date: Tue, 28 Apr 2009 16:38:05 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
       Andrew Morton <akpm@linux-foundation.org>, "Zhu, Yi" <yi.zhu@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: mmotm 2009-04-27-15-45 uploaded - iwl3945 oops
Message-ID: <20090428203805.GB3321@tuxdriver.com>
References: <200904272305.n3RN51mu031395@imap1.linux-foundation.org> <25818.1240938876@turing-police.cc.vt.edu> <1240951184.1207.11.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240951184.1207.11.camel@rc-desk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 01:39:44PM -0700, reinette chatre wrote:
> On Tue, 2009-04-28 at 10:14 -0700, Valdis.Kletnieks@vt.edu wrote:
> > On Mon, 27 Apr 2009 15:46:07 PDT, akpm@linux-foundation.org said:
> > > The mm-of-the-moment snapshot 2009-04-27-15-45 has been uploaded to
> > > 
> > >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > Saw this while booting at home, out of range of any access points I was
> > configured to associate with (there *are* 4 APs owned by neighbors that I can
> > see via kismet, but wpa_supplicant isn't configured to use them).  Didn't
> > happen this morning at my office, when there's APs in range.
> > 
> > This didn't happen in mmotm-0424, so it's something new in the last few days.
> 
> A recent patch that is related is ...
> 
> commit 4583f7455c6b668a4e9cab154b5a7b6c583b288a
> Author: Johannes Berg <johannes@sipsolutions.net>
> Date:   Thu Apr 23 10:45:04 2009 +0200
> 
>     iwlwifi: notify on scan completion even when shutting down
> 
>     Under certain circumstances iwlwifi can get stuck and will no
>     longer accept scan requests, because the core code (cfg80211)
>     thinks that it's still processing one. This fixes one of the
>     points where it can happen, but I've still seen it (although
>     only with my radio-off-when-idle patch).
>     
>     Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>     Acked-by: Reinette Chatre <reinette.chatre@intel.com>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>
> 
> 
> Could you please revert this and test again?

I doubt if that will help -- I just put it into wireless-2.6 and
wireless-testing today.

> If this does not help, could you please bisect?

Better bet...unless you meant "apply" instead of "revert"...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
