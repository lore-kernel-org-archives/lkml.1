Return-Path: <linux-kernel-owner+w=401wt.eu-S1756191AbZAGDbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191AbZAGDbI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 22:31:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbZAGDaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 22:30:55 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:31932 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbZAGDaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 22:30:55 -0500
X-IronPort-AV: E=Sophos;i="4.37,223,1231131600"; 
   d="scan'208";a="80730106"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Greg KH" <gregkh@suse.de>
Subject: Re: debugfs & vfs file permission issue?
Date: Tue, 6 Jan 2009 22:30:19 -0500
User-Agent: KMail/1.9.5
Cc: "Mike Frysinger" <vapier.adi@gmail.com>, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
References: <200901052157.07306.rgetz@blackfin.uclinux.org> <200901061012.38888.rgetz@blackfin.uclinux.org> <20090106231158.GA1388@suse.de>
In-Reply-To: <20090106231158.GA1388@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901062230.19713.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 07 Jan 2009 03:30:07.0960 (UTC) FILETIME=[3D0FC580:01C97078]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 6 Jan 2009 18:11, Greg KH pondered:
> On Tue, Jan 06, 2009 at 10:12:38AM -0500, Robin Getz wrote:
> > On Tue 6 Jan 2009 07:05, Robin Getz suggested:
> > >
> > > adding a readonly, and writeonly, and ensuring that when you call 
> > > debugfs_create_*, the mode is checked, and the "correct" fops are
> > > set doesn't seem like it would be a bad idea? This would enforce the
> > > kernel programmer's view on the world, and not allow pesky root
> > > users to override things....
> > > 
> > > Greg - would you take something like that?
> > 
> > How about this?
> 
> I like it, want me to queue it up?

Please & thanks.

-Robin
