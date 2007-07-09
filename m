Return-Path: <linux-kernel-owner+w=401wt.eu-S1754597AbXGIMfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbXGIMfT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 08:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751905AbXGIMfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 08:35:07 -0400
Received: from main.gmane.org ([80.91.229.2]:47867 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbXGIMfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 08:35:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Matthieu CASTET <matthieu.castet@parrot.com>
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
Date: Mon, 9 Jul 2007 12:31:00 +0000 (UTC)
Message-ID: <loom.20070709T142907-124@post.gmane.org>
References: <20070708034952.022985379@sgi.com> <20070708035018.074510057@sgi.com> <20070708075119.GA16631@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 88.138.57.125 (Mozilla/5.0 (X11; U; Linux i686; fr; rv:1.8.1.4) Gecko/20070508 Iceweasel/2.0.0.4 (Debian-2.0.0.4-1))
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo <at> elte.hu> writes:


> A year ago the -rt kernel defaulted to the SLOB for a few releases, and 
> barring some initial scalability issues (which were solved in -rt) it 
> worked pretty well on generic PCs, so i dont buy the 'it doesnt work' 
> argument either.
> 
Last time I tried it, I cannot mount (or mount very slowly) jffs2 flash with 
slob.
Changing slob to slab fix the issue.


Matthieu

