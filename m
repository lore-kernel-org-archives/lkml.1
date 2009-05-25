Return-Path: <linux-kernel-owner+w=401wt.eu-S1753966AbZEYJJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbZEYJJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 05:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbZEYJJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 05:09:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48004 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbZEYJJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 05:09:08 -0400
Date: Mon, 25 May 2009 11:15:30 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Alan <alan@lxorguk.ukuu.org.uk>, Gerd Hoffmann <kraxel@redhat.com>,
       jeremy@goop.org, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>, JBeulich@novell.com,
       jbarnes@virtuousgeek.org
Subject: Re: [Xen-devel] Re: [GIT PULL] xen /proc/mtrr implementation
Message-ID: <20090525091530.GW846@one.firstfloor.org>
References: <4A1A59DD.7030101@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1A59DD.7030101@wpkg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Are these ones (below) good CPU to worry about? That's slightly 
> off-topic as they are KVM guests, but still, the guest kernel seems to 
> disable PAT (unless I'm mistaken).

To my knowledge the only CPUs with broken PAT are some very old Pentium
Pros dating from back the time when PAT was new and noone used it.
On those it should be disabled or the high bits not used.

The kernel is overall too conservative with its white list.

Today a lot of other common operating systems use PAT extensively,
so in general it works on the hardware level.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
