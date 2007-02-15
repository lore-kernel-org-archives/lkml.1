Return-Path: <linux-kernel-owner+w=401wt.eu-S1161135AbXBOUNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161135AbXBOUNe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 15:13:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161137AbXBOUNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 15:13:34 -0500
Received: from lazybastard.de ([212.112.238.170]:41147 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161135AbXBOUNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 15:13:32 -0500
Date: Thu, 15 Feb 2007 20:09:22 +0000
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Juan Piernas Canovas <piernas@ditec.um.es>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, sfaibish <sfaibish@emc.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] DualFS: File System with Meta-data and Data Separation
Message-ID: <20070215200922.GB24643@lazybastard.org>
References: <op.tnkdlbgsrwwil4@brcsmondepl2c.corp.emc.com> <op.tnrbrocsunckof@usensfaibisl2e.eng.emc.com> <Pine.LNX.4.61.0702142251460.19368@yvahk01.tjqt.qr> <Pine.LNX.4.61.0702151910370.19998@ditec.inf.um.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.61.0702151910370.19998@ditec.inf.um.es>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 February 2007 19:38:14 +0100, Juan Piernas Canovas wrote:
> 
> The patch for 2.6.11 is not still stable enough to be released. Be patient 
> ;-)

While I don't want to discourage you, this is about the point in
development where most log structured filesystems stopped.  Doing a
little web research, you will notice those todo-lists with "cleaner"
being the top item for...years!

Getting that one to work robustly is _very_ hard work and just today
I've noticed that mine was not as robust as I would have liked to think.
Also, you may note that by updating to newer kernels, the VM writeout
policies can change and impact your cleaner.  To an extent even that you
had a rock-solid filesystem with 2.6.18 and thing crumble between your
fingers in 2.6.19 or later.

If the latter happens, most likely the VM is not to blame, it just
proved that your cleaner is still getting some corner-cases wrong and
needs more work.  There goes another week of debugging. :(

Jörn

-- 
You ain't got no problem, Jules. I'm on the motherfucker. Go back in
there, chill them niggers out and wait for the Wolf, who should be
coming directly.
-- Marsellus Wallace
