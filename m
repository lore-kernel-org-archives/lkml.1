Return-Path: <linux-kernel-owner+w=401wt.eu-S1759549AbYD3QyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759549AbYD3QyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 12:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757323AbYD3QyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 12:54:03 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33693 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512AbYD3QyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 12:54:02 -0400
Date: Wed, 30 Apr 2008 09:39:51 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>, "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Jeff Garzik <jgarzik@redhat.com>, Dave Jones <davej@redhat.com>,
       akpm@linux-foundation.org, Chuck Wolber <chuckw@quantumlinux.com>,
       stable@kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [stable] [27/37] tehuti: move ioctl perm check closer to
	function start (CVE-2008-1675)
Message-ID: <20080430163951.GD22558@kroah.com>
References: <20080429171222.073929148@mini.kroah.org> <20080429171901.GB14724@suse.de> <20080429191310.203384eb@core> <20080429185543.GA24643@suse.de> <alpine.LFD.1.10.0804291200140.2997@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804291200140.2997@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 12:02:14PM -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 29 Apr 2008, Greg KH wrote:
> >
> > Hm, that's the way it is in Linus's tree, we should change it there
> > first.
> 
> Done. It will be commit 6203554207728f43cfb9fd48585cd6500da73d42 when I 
> push out (but please point to the original commit that actually adds the 
> check: 6203554 just changes from CAP_NET_ADMIN to CAP_SYS_RAWIO and is not 
> as important as adding the check in the first place.

Thanks, I'll add this to the queue for 2.6.25-stable as well.

greg k-h
