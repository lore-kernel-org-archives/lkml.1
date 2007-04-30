Return-Path: <linux-kernel-owner+w=401wt.eu-S1946155AbXD3Xuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946155AbXD3Xuu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 19:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946162AbXD3Xuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 19:50:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946155AbXD3XuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 19:50:13 -0400
Date: Mon, 30 Apr 2007 19:50:06 -0400
From: Dave Jones <davej@redhat.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Greg KH <greg@kroah.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Thomas Hellstr?m <thomas@tungstengraphics.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>
Subject: Re: [RFC] [PATCH] DRM TTM Memory Manager patch
Message-ID: <20070430235006.GG26601@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Dave Airlie <airlied@gmail.com>, Greg KH <greg@kroah.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Thomas Hellstr?m <thomas@tungstengraphics.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Eric Anholt <eric@anholt.net>
References: <21d7e9970704252355m4765b65fyb547b9ba2763b103@mail.gmail.com> <20070427163951.GA12216@kroah.com> <21d7e9970704301610u5d5132uc282ac697c9df2be@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d7e9970704301610u5d5132uc282ac697c9df2be@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 09:10:00AM +1000, Dave Airlie wrote:
 
 > Okay this needs fixing, we do check most ioctls args, the main thing
 > passed in are handles and these are all looked up in the hash table,
 > it may not be so obvious, also most of the ioctls are probably going
 > to end up root or DRM master only, I'd like do an ioctl fuzzer at some
 > stage, I'd suspect a lot more then the dri would be oopsable with
 > permissions...

http://www.digitaldwarf.be/products/ioctlfuzz.tar.gz
Not had chance to play with it, but I'd not be surprised if
there's any fallout.

	Dave

-- 
http://www.codemonkey.org.uk
