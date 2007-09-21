Return-Path: <linux-kernel-owner+w=401wt.eu-S1755547AbXIUB3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbXIUB3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 21:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbXIUB30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 21:29:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:41303 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbXIUB3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 21:29:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,280,1186383600"; 
   d="scan'208";a="316023302"
Date: Fri, 21 Sep 2007 09:27:51 +0800
From: Zhenyu Wang <zhenyu.z.wang@intel.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Dave Airlie <airlied@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: X-freeze after clflush changes [Was: 2.6.23-rc6-mm1]
Message-ID: <20070921012751.GA3171@zhen-devel.sh.intel.com>
Mail-Followup-To: Jiri Slaby <jirislaby@gmail.com>,
	Dave Airlie <airlied@gmail.com>, Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20070919121017.0cbcbc30.akpm@linux-foundation.org> <20070919192453.GB18707@one.firstfloor.org> <46F17CA1.5080205@gmail.com> <20070919195425.GF18707@one.firstfloor.org> <46F17F27.5080000@gmail.com> <21d7e9970709191851s1b3f35c1j42faae3ce6cd0b24@mail.gmail.com> <46F22048.8050401@gmail.com> <21d7e9970709200033k3f0f46feq7dae4e0a106f0372@mail.gmail.com> <20070920092441.GA1972@zhen-devel.sh.intel.com> <46F2EFD2.2090907@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F2EFD2.2090907@gmail.com>
User-Agent: Mutt/1.4.2.1i
X-Mailer: mutt
X-Operating-System: Linux 2.6.22-rc6 i686
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.09.21 00:10:26 +0000, Jiri Slaby wrote:
> > Could you try current xf86-video-intel driver? just do
> > git clone git://anongit.freedesktop.org/git/xorg/driver/xf86-video-intel
> 
> It works! 

yep, I also pushed a fix for G33 in xf86-video-intel when fixing the intel agp.
So for G33 user, you should upgrade both to be able to work correctly.

> 3d problem, but it has maybe nothing to do with kernel:
> $ glxinfo
> name of display: :0.0
> Unrecognized deviceID 29c2
> X Error of failed request:  GLXBadContext
> ...

It looks you have an old version of mesa, that i915 dri driver doesn't know
your chipset. Try mesa-7.X.

I have also seen X exit broken with 2.6.23-rc6-mm1, will follow this thread
and try Dave's patch.

Thanks for testing!
