Return-Path: <linux-kernel-owner+w=401wt.eu-S1756597AbZAAX6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbZAAX6i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 18:58:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755411AbZAAX62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 18:58:28 -0500
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:23813 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754755AbZAAX61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 18:58:27 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqUCAKbkXEl5LB1fgWdsb2JhbACTewEBFiK2NYVy
X-IronPort-AV: E=Sophos;i="4.36,315,1228051800"; 
   d="scan'208";a="285411271"
Date: Fri, 2 Jan 2009 10:58:21 +1100
From: Dave Chinner <david@fromorbit.com>
To: sniper <s3c24xx@gmail.com>
Cc: Daniel Phillips <phillips@phunq.net>, tux3@tux3.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jeff Dike <jdike@addtoit.com>
Subject: Re: [Tux3] Tux3 report: A Golden Copy
Message-ID: <20090101235821.GI10725@disturbed>
Mail-Followup-To: sniper <s3c24xx@gmail.com>,
	Daniel Phillips <phillips@phunq.net>, tux3@tux3.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jeff Dike <jdike@addtoit.com>
References: <200812301935.49303.phillips@phunq.net> <200812310000.55256.phillips@phunq.net> <20081231083123.GF10725@disturbed> <200812310140.49503.phillips@phunq.net> <9bd6b5360812311014l4b36ddcfj45f1b3e6103ca793@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9bd6b5360812311014l4b36ddcfj45f1b3e6103ca793@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 01, 2009 at 02:14:35AM +0800, sniper wrote:
> Sorry I meet another problem. After the system was completely setupped,
> the gdb interface will be covered with that system interaction interface.
> So, I can't stop the system's running and add some new break point etc.
> But I can do those operations in remote kgdb debugging.
> 
> Any method to fix this problem?

Start up the uml console and send an "int" to the UML process.
That should drop it into the debugger. If that doesn't work,
pick the UML process that is burning CPU and send it a SIGTRAP ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
