Return-Path: <linux-kernel-owner+w=401wt.eu-S932181AbYBGGZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181AbYBGGZa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 01:25:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760099AbYBGGV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 01:21:56 -0500
Received: from outbound-mail-07.bluehost.com ([69.89.17.207]:38625 "HELO
	outbound-mail-07.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761713AbYBGGVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 01:21:54 -0500
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Dave Airlie <airlied@linux.ie>
Subject: Re: [git pull] drm patches for 2.6.25
Date: Wed, 6 Feb 2008 22:21:45 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <alpine.DEB.0.82.0802070534290.26136@skynet.skynet.ie>
In-Reply-To: <alpine.DEB.0.82.0802070534290.26136@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802062221.46268.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 06, 2008 9:37 pm Dave Airlie wrote:
> Hi Linus,
>
> Please pull the 'drm-patches' branch from
> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git
> drm-patches
>
> Sorry this is so late, after much talking at LCA we decided to pull TTM
> from this round and I had to re-order a lot of things, so highlights of
> this bunch are
>
> intel driver suspend/resume support - can bring back text mode now.

Just FYI, given some of the weirdness we've seen in 8xx chipsets in the 2D 
driver, this new suspend/resume code may still need a few tweaks.  Please 
test it out and report any bugs you find asap (preferably w/o X running as 
that makes things easier to debug).

Also, if you find that your outputs don't come back, I've got an experimental 
patch at https://bugs.freedesktop.org/show_bug.cgi?id=14249 that may work for 
you (this one in particular is the one I'm worried may break 855).

Thanks,
Jesse
