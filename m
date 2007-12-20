Return-Path: <linux-kernel-owner+w=401wt.eu-S1762001AbXLTVny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762001AbXLTVny (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 16:43:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543AbXLTVnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 16:43:46 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:1857 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbXLTVnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 16:43:45 -0500
Subject: Re: Trailing periods in kernel messages
From: Joe Perches <joe@perches.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andy Whitcroft <apw@shadowen.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, trivial@kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>
In-Reply-To: <20071220210741.6dc3caf5@the-village.bc.nu>
References: <474E6BD0.20103@cn.fujitsu.com>
	 <E1IxfE8-0000Sr-9w@faramir.fjphome.nl> <474E8669.6060409@cn.fujitsu.com>
	 <200711291120.19595.elendil@planet.nl>
	 <20071129032036.4c021617.akpm@linux-foundation.org>
	 <474F6372.70705@cn.fujitsu.com> <1196386259.22120.101.camel@localhost>
	 <474F6D4D.9010006@cn.fujitsu.com> <1196390128.22120.118.camel@localhost>
	 <20071220162923.GB27885@shadowen.org>
	 <20071220210741.6dc3caf5@the-village.bc.nu>
Content-Type: text/plain
Date: Thu, 20 Dec 2007 13:43:04 -0800
Message-Id: <1198186984.6183.72.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-12-20 at 21:07 +0000, Alan Cox wrote:
> > I missed the context on this one.  So this is checking for periods at
> > the end of messages for printk's.  We would need something a little
> > cleverer to ensure we are only checking the contents of the string.  But
> > eminently doable.
> > 
> > /me plays
> > 
> > Ok, yes this seems ok.  Have added it for 0.13.
> 
> Please remove it.
> 
> The kernel printk messages are sentences. English language sentences end
> with a full stop. They are messages printed up for normal human beings to
> read and they should therefore be properly written.

Documentation/Coding Style

		Chapter 13: Printing kernel messages

Kernel messages do not have to be terminated with a period.


