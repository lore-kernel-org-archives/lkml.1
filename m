Return-Path: <linux-kernel-owner+w=401wt.eu-S1753600AbZIKHo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbZIKHo5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 03:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbZIKHo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 03:44:56 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55774 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbZIKHoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 03:44:55 -0400
Date: Fri, 11 Sep 2009 09:44:55 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Avi Kivity <avi@qumranet.com>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] /dev/mem cleanups and bug fix
Message-ID: <20090911074455.GC32562@basil.fritz.box>
References: <20090911022333.324128054@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090911022333.324128054@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 11, 2009 at 10:23:33AM +0800, Wu Fengguang wrote:
> Hi Andrew,
> 
> Here are three patches for /dev/[k]mem.
> They are mostly code cleanups, plus a minor bug fix:
> if someone read high mem via /dev/kmem starting from
> an unaligned address, it's calculation of 'len' will
> go wrong.
> 
> I would recommend them for .32.

I reviewed the three patches and they all look good to me.

Acked-by: Andi Kleen <ak@linux.intel.com>

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
