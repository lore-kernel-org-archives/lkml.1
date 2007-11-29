Return-Path: <linux-kernel-owner+w=401wt.eu-S934377AbXK2Xff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934377AbXK2Xff (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 18:35:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762220AbXK2XfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 18:35:20 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:50838 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761190AbXK2XfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 18:35:19 -0500
Subject: Re: Out of tree module using LSM
From: Jon Masters <jonathan@jonmasters.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ray Lee <ray-lk@madrabbit.org>, tvrtko.ursulin@sophos.com,
       Al Viro <viro@ftp.linux.org.uk>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Valdis.Kletnieks@vt.edu
In-Reply-To: <20071129214527.1d62056c@the-village.bc.nu>
References: <20071128183040.GW8181@ftp.linux.org.uk>
	 <OF699E23DA.E36E712D-ON802573A2.00591FA8-802573A2.005A44A2@sophos.com>
	 <20071129173601.34273083@the-village.bc.nu>
	 <2c0942db0711291040j4ce48acagb753b64c4b8c1357@mail.gmail.com>
	 <1196362612.6473.98.camel@perihelion>
	 <2c0942db0711291111t16a4eb49h6b1e83ddf7bb4cf9@mail.gmail.com>
	 <1196365551.6473.103.camel@perihelion>
	 <20071129214527.1d62056c@the-village.bc.nu>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Thu, 29 Nov 2007 18:34:33 -0500
Message-Id: <1196379273.6473.121.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-11-29 at 21:45 +0000, Alan Cox wrote:
> > Jargon File in all its glory. And if you still think you could look for
> > patterns, how about executable code that self-modifies in random ways
> > but when executed as a whole actually has the functionality of fetchmail
> > embedded within it? How would you guard against that?
> 
> Thats a problem for whoever writes the ESR detection tool and to what
> level it works. The question for the kernel is how do we provide a
> mechanism to allow (to some extent at least) this kind of tool to run.

Right. I'm just saying reading a single page out of context (no pun
intended) is not going to be very useful. They need to scan the entire
file, which means that there are limited ways this is practical - it's
not practical to do that on every write into a shared mapping, hence a
solution that scans on open, etc. is probably the best there is.

(I know you know this)

Jon.


