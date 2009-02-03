Return-Path: <linux-kernel-owner+w=401wt.eu-S1755778AbZBCVVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778AbZBCVVr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 16:21:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbZBCVVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 16:21:36 -0500
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:30066 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751721AbZBCVVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 16:21:35 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAKNCiEl5LJ2q/2dsb2JhbADPa4QUBg
X-IronPort-AV: E=Sophos;i="4.37,374,1231075800"; 
   d="scan'208";a="309596300"
Date: Wed, 4 Feb 2009 08:21:29 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jamie Lokier <jamie@shareable.org>
Cc: Eric Sandeen <sandeen@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       t-sato@yk.jp.nec.com
Subject: Re: [PATCH V4] Allow SysRq emergency thaw to thaw frozen
	filesystems
Message-ID: <20090203212129.GI24173@disturbed>
Mail-Followup-To: Jamie Lokier <jamie@shareable.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	t-sato@yk.jp.nec.com
References: <496EB639.6090800@redhat.com> <4970E087.8020308@redhat.com> <4970E4FB.7040407@redhat.com> <20090130134009.02d4a576.akpm@linux-foundation.org> <498779D6.7010304@redhat.com> <20090203114829.GG11926@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090203114829.GG11926@shareable.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 03, 2009 at 11:48:29AM +0000, Jamie Lokier wrote:
> Eric Sandeen wrote:
> > The timeout thaw originally proposed did not get merged, but
> > perhaps something like this would be useful in emergencies.
> > 
> > For example, freeze /path/to/mountpoint may freeze your
> > root filesystem if you forgot that you had that unmounted.
> 
> If you don't have console access, you're just logged in remotely, is
> there a way to do an emergency unthaw from a shell command?
                                 ^^^^^^
That's a freeze, right? ;)

Anyway, I think you could use /proc/sysrq-trigger in that situation.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
