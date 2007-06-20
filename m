Return-Path: <linux-kernel-owner+w=401wt.eu-S1753497AbXFTNx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbXFTNx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 09:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbXFTNxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 09:53:20 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:13027 "EHLO
	viefep34-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750758AbXFTNxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 09:53:19 -0400
Date: Wed, 20 Jun 2007 15:22:33 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Wang Zhenyu <zhenyu.z.wang@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       eric@anholt.net, lethal@linux-sh.org, y-goto@jp.fujitsu.com
Subject: Re: 2.6.22-rc5 regression
Message-ID: <20070620132233.GA19640@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Wang Zhenyu <zhenyu.z.wang@intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
	eric@anholt.net, lethal@linux-sh.org, y-goto@jp.fujitsu.com
References: <20070617214905.GA6207@alinoe.com> <alpine.LFD.0.98.0706180950130.14121@woody.linux-foundation.org> <20070618181225.GB8054@alinoe.com> <alpine.LFD.0.98.0706181127380.14121@woody.linux-foundation.org> <20070618195415.GA7481@alinoe.com> <alpine.LFD.0.98.0706181332400.3593@woody.linux-foundation.org> <20070618225009.GE13538@alinoe.com> <alpine.LFD.0.98.0706181553450.3593@woody.linux-foundation.org> <20070619233716.GA5779@alinoe.com> <20070620011521.GB2856@zhen-devel.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070620011521.GB2856@zhen-devel.sh.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 09:15:21AM +0800, Wang Zhenyu wrote:
> Yep, the device table patch doesn't change any function, so your problem
> started from when 965G support patch has been in kernel. 

Yup

> Carlo, pls try a kernel param of "pci=nommconf" to see if that could
> fix your hang. There might be a BIOS bug, as similar issue also happen
> like https://bugzilla.novell.com/show_bug.cgi?id=228683

That bugreport looks EXACTLY like the problem that I ran into.
Note that they have the same motherboard as me: ASUS P5B Deluxe

I will try pci=nommconf in a moment. It isn't the best workaround
however as it should reduce the available RAM from 4GB to 3GB.
agp=off would be a better workaround.

Carlo Wood <carlo@alinoe.com>
