Return-Path: <linux-kernel-owner+w=401wt.eu-S1753124AbZKKJby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbZKKJby (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 04:31:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752983AbZKKJby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 04:31:54 -0500
Received: from mga06.intel.com ([134.134.136.21]:39942 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752904AbZKKJbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 04:31:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,722,1249282800"; 
   d="scan'208";a="466285485"
Subject: Re: [patch] added brightness feature to lcd class.
From: Richard Purdie <rpurdie@linux.intel.com>
To: InKi Dae <daeinki@gmail.com>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Kyungmin Park <kmpark@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>
In-Reply-To: <90b950fc0911102217o41aea871u3a5d9e44c947fe3c@mail.gmail.com>
References: <90b950fc0911020050q3bc3fae8j954ec6ed73d79b5@mail.gmail.com>
	 <1257809705.29038.82.camel@dax.rpnet.com>
	 <90b950fc0911091926v32dc1c44n1018322390282bc0@mail.gmail.com>
	 <1257842597.29038.162.camel@dax.rpnet.com>
	 <90b950fc0911102217o41aea871u3a5d9e44c947fe3c@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 11 Nov 2009 09:28:37 +0000
Message-Id: <1257931717.29038.298.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-11 at 15:17 +0900, InKi Dae wrote:
> 2009/11/10 Richard Purdie <rpurdie@linux.intel.com>:
> > So you've tried this, what was the problem? Perhaps post this driver
> > code to illustrate your problem?
> 
> all the cases worked fine.
> it's not whether lcd driver has a problem or not.
> I mean it's design issue of lcd class. AMOLED LCD Panel DOESN'T NEED
> backlight device.
> and I should have added brightness control feature to AMOLED LCD Panel
> driver not using backlight class
> because they have no BACKLIGHT DEVICE.
> 
> in point of view AMOLED LCD Panel, brightness control is perfomed by
> gamma setting, not backlight power controlling.

The question is whether this gamma control does the same thing as what
we've traditionally used the backlight brightness control for. As I
understand it, the answer is yes and to userspace making it appear as a
backlight brightness control makes sense. 

The userspace view of the world is key and the fact there is not a
traditional physical backlight in the hardware isn't really an issue.

Why would we want to create two userspace interfaces doing the same
thing which would mean we just have to complicate userspace drivers? 
Symlinking just makes things confusing.

Cheers,

Richard


