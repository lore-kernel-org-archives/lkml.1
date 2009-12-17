Return-Path: <linux-kernel-owner+w=401wt.eu-S936274AbZLQPQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936274AbZLQPQz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 10:16:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936193AbZLQPQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 10:16:53 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:41395 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936178AbZLQPQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 10:16:52 -0500
From: Roger Oksanen <roger.oksanen@cs.helsinki.fi>
To: Greg KH <gregkh@suse.de>
Subject: Re: [50/90] e100: Use pci pool to work around GFP_ATOMIC order 5 memory allocation failure
Date: Thu, 17 Dec 2009 17:16:24 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.32-ironman-1; KDE/4.3.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
References: <20091217011604.483828174@mini.kroah.org> <200912171703.02902.roger.oksanen@cs.helsinki.fi> <20091217150933.GA2829@suse.de>
In-Reply-To: <20091217150933.GA2829@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912171716.24254.roger.oksanen@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 December 2009 17:09:33 Greg KH wrote:
> On Thu, Dec 17, 2009 at 05:03:02PM +0200, Roger Oksanen wrote:
> > On Thursday 17 December 2009 03:15:01 Greg KH wrote:
> > > 2.6.31-stable review patch.  If anyone has any objections, please let us know.
> > 
> > This commit has a problem, found in 
> > http://lkml.indiana.edu/hypermail/linux/kernel/0912.1/03887.html
> > and while a fix is available at
> > http://lkml.indiana.edu/hypermail/linux/kernel/0912.2/01012.html
> > it should probably be merged into this patch when pushing it to 31.x?
> > Obviously the fix should first be reviewed and pushed to Linus' tree...
> 
> Thanks for letting me know.  I'll drop this patch for now, until the fix
> goes into Linus's tree, and then put both of them back in for a future
> stable release.
> 
> Sound good?

Yup, sounds like a plan.

-- 
Roger Oksanen <roger.oksanen@cs.helsinki.fi>
http://www.cs.helsinki.fi/u/raoksane
+358 50 355 1990
