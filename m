Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab0AOBiY (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 20:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730Ab0AOBiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 20:38:23 -0500
Received: from kroah.org ([198.145.64.141]:50926 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591Ab0AOBiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 20:38:22 -0500
Date: Thu, 14 Jan 2010 17:29:21 -0800
From: Greg KH <greg@kroah.com>
To: John Kacur <jkacur@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 00/15] Staging: Convert the semaphore mess
Message-ID: <20100115012921.GE32278@kroah.com>
References: <1263243114-3942-1-git-send-email-jkacur@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263243114-3942-1-git-send-email-jkacur@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11, 2010 at 09:51:39PM +0100, John Kacur wrote:
> Thomas / Ingo / Greg
> 
> I started with the patch in -rt 041e3130496f31d0cb4887fc6183117e662f5141
> and tried to forward port it to 2.6.33-rc3
> 
> The patch no-longer applied, because some of the changes were already accepted
> upstream, some files had been moved or dropped and so on.
> 
> So, I broke the original patch into one patch per file, and fixed merge errors.
> Then I also went and changed similar problems in new code
> 
> This code should be queued-up for the 2.6.34 merge window, and should also
> be applied to the latests -rt branch.

I can't do that, as it breaks when applying to Linus's latest tree,
right?

If this needs to go through some other tree, no objection from me at
all, feel free to add:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

to them.

thanks,

greg k-h
