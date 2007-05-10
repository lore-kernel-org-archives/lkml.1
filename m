Return-Path: <linux-kernel-owner+w=401wt.eu-S1758773AbXEJRjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773AbXEJRjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 13:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756397AbXEJRjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 13:39:07 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41964 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756492AbXEJRjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 13:39:05 -0400
Date: Thu, 10 May 2007 18:38:50 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net,
       Kristian H?gsberg <krh@redhat.com>,
       Christoph Hellwig <hch@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       John Stoffel <john@stoffel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Olaf Hering <olh@suse.de>, Gene Heskett <gene.heskett@gmail.com>,
       Adrian Bunk <bunk@stusta.de>,
       Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
       Bill Fink <billfink@mindspring.com>
Subject: Re: [git pull] New firewire stack (updated)
Message-ID: <20070510173850.GA31826@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
	Kristian H?gsberg <krh@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
	John Stoffel <john@stoffel.org>,
	Pekka Enberg <penberg@cs.helsinki.fi>, Olaf Hering <olh@suse.de>,
	Gene Heskett <gene.heskett@gmail.com>, Adrian Bunk <bunk@stusta.de>,
	Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
	Bill Fink <billfink@mindspring.com>
References: <4637A29F.6070302@redhat.com> <tkrat.b635518ff171071d@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tkrat.b635518ff171071d@s5r6.in-berlin.de>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 07:26:56PM +0200, Stefan Richter wrote:
> Linus, please pull from the juju branch at
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git juju
> 

ACK from me.  I still have some comments but none of them is a merge
blocker.

> What did _not_ change:
> 
>   - The drivers are still named fw-core, fw-ohci, fw-sbp2 (but they
>     feature conditional aliases sbp2 and ohci1394 now).  Adrian
>     suggested the prefix firewire- instead of fw-.
> 
>   - The drivers still live in drivers/firewire/, i.e. have not been put
>     into mainline's drivers/ieee1394/.

I don't quite like that.  Then again git handles renames pretty nicely
and I hope we'll just shift the new drivers in place when the old code
goes away completely to give people a seamless migration.

