Return-Path: <linux-kernel-owner+w=401wt.eu-S1757819AbYHHMUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819AbYHHMUU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 08:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755105AbYHHMUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 08:20:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44257 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbYHHMUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 08:20:08 -0400
Date: Fri, 8 Aug 2008 14:20:52 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Cliff Wickman <cpw@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, Vivek Goyal <vgoyal@redhat.com>,
       Keith Owens <kaos@ocs.com.au>, Jay Lan <jlan@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>, jmerkey@wolfmountaingroup.com,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
       Takenori Nagano <t-nagano@ah.jp.nec.com>,
       Bernhard Walle <bwalle@suse.de>
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
Message-ID: <20080808122052.GA9038@one.firstfloor.org>
References: <20080807200659.GJ24801@one.firstfloor.org> <23175.1218148134@ocs10w> <20080808011500.GA531@redhat.com> <20080808022916.GM24801@one.firstfloor.org> <20080808120813.GA17364@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080808120813.GA17364@sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In a partitioned system [I work for SGI, so I'm talking about an Altix],
> there is memory sharing among multiple single-system images. And if
> one of those partitions were to panic the other partitions need to
> be informed that they cannot address the panic'd partition's memory.
> (Once that partition is rebooted any such access will cause an MCA
> in the accessor.)

There are already existing shutdown hooks. Aren't they good enough
for that?

I would feel uneasy about having arbitary drivers hook into panic().
While I'm sure your code is great there is unfortunately a lot 
of crappy driver code around.

-Andi
