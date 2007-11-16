Return-Path: <linux-kernel-owner+w=401wt.eu-S932648AbXKPBiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932648AbXKPBiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 20:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756393AbXKPBiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 20:38:06 -0500
Received: from ns2.suse.de ([195.135.220.15]:55344 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754037AbXKPBiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 20:38:05 -0500
Date: Thu, 15 Nov 2007 17:22:11 -0800
From: Greg KH <gregkh@suse.de>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org
Subject: Re: EIP is at device_shutdown+0x32/0x60
Message-ID: <20071116012211.GA7365@suse.de>
References: <3ae72650711150950k74fdb37eu108bb360a594ffe8@mail.gmail.com> <20071115190124.GA29599@suse.de> <20071116100930.5A78.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071116100930.5A78.Y-GOTO@jp.fujitsu.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2007 at 10:13:42AM +0900, Yasunori Goto wrote:
> > > 
> > > Care to try this:
> > >   +       system_kset = kset_create_and_register("system", NULL,
> > >   +                                              &devices_kset->kobj, NULL);
> > > 
> > > We should not join the kset, only use it as a parent.
> > 
> > Yes, that fixes the problem for me!
> > 
> > Can anyone else verify this?
> 
> I confirmed it fixed the problem. :-)

Thanks for testing, the next -mm should have this fix.

greg k-h
