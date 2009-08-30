Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbZH3WbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbZH3WbB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 18:31:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754189AbZH3WbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 18:31:00 -0400
Received: from eazy.amigager.de ([213.239.192.238]:36152 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbZH3WbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 18:31:00 -0400
X-Greylist: delayed 1734 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Aug 2009 18:31:00 EDT
Date: Mon, 31 Aug 2009 00:01:35 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mailing54 <mailing54@plzk.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>, Eric Anholt <eric@anholt.net>,
       dri-devel@lists.sourceforge.net, Ma Ling <ling.ma@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Zhenyu Wang <zhenyuw@linux.intel.com>
Subject: Re: Linux 2.6.31-rc7
Message-ID: <20090830220135.GA24722@mac.home>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	mailing54 <mailing54@plzk.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Dave Airlie <airlied@redhat.com>, Eric Anholt <eric@anholt.net>,
	dri-devel@lists.sourceforge.net, Ma Ling <ling.ma@intel.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Zhenyu Wang <zhenyuw@linux.intel.com>
References: <alpine.LFD.2.01.0908211810390.3158@localhost.localdomain>
 <4A941E8B.8080902@plzk.org>
 <alpine.LFD.2.01.0908251057260.3218@localhost.localdomain>
 <4A94599F.9020508@plzk.org>
 <alpine.LFD.2.01.0908251456530.3218@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0908251456530.3218@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 15:07:55 -0700, Linus Torvalds wrote:

[...]

> However, the problem remains that KMS gets the output wrong, in ways that 
> clearly X does not. Eric - it's clearly not just Mac Mini and my 
> experimental machine that have problems, but also a Macbook 2.1.

Hi Linus,

for the Mac mini case, I need at least this patch to get the DVI output
working:

http://bugs.freedesktop.org/show_bug.cgi?id=23350

Without the patch, the KMS code won't detect any modes because it gets
no EDID via DDC.

Regards,
Tino
