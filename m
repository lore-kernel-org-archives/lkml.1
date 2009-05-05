Return-Path: <linux-kernel-owner+w=401wt.eu-S1754460AbZEEOu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460AbZEEOu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 10:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbZEEOuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 10:50:13 -0400
Received: from daemo06.udag.de ([62.146.33.130]:52271 "EHLO mail.udag.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751424AbZEEOuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 10:50:12 -0400
X-Greylist: delayed 2019 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 May 2009 10:50:12 EDT
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
From: "" <spam@nico22.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Re: CFS not suitable for desktop computers
Message-Id: <20090505141633.0D90ED040@mail.udag.de>
Date: Tue,  5 May 2009 16:16:32 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-04 at 15:01 -0600, Chris Friesen wrote:
> I wonder if this could be related to I/O rather than the task scheduler
> proper.
> That's something I was wondering as well, particularly when I noticed
> he's using data=journal and anticipatory io-scheduler.

I will try with different schedulers tonight.

On Tue, 2009-05-05 at 07:42 +0200, Mike Galbraith wrote:
> I have an old P4 lying about (has X candy). I'll update it and try some
> UP testing. Can't test Thunderbird though.

It is not only Thunderbird, which does not have much cpu usage for itself. This laggy behaviour is also noticible by just switching some terminal windows (I use gnome-terminal, again, it for itself does not cause much cpu usage nor disk i/o), minimizing them and so on.

If I set the priority of make -j3 to -n19, the problem vanishes, so I expected the scheduler to be to blame.

Again, thank you all for your efforts :-)

Nico
