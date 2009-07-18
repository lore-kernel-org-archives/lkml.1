Return-Path: <linux-kernel-owner+w=401wt.eu-S1752501AbZGRQIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbZGRQIv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 12:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbZGRQIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 12:08:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:52854 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbZGRQIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 12:08:49 -0400
Date: Sat, 18 Jul 2009 09:01:01 -0700
From: Greg KH <greg@kroah.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Gerardo Exequiel Pozzi <vmlinuz386@yahoo.com.ar>
Subject: Re: vc: create vcs(a) devices for consoles
Message-ID: <20090718160101.GA13346@kroah.com>
References: <1247931257.29760.1.camel@yio.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247931257.29760.1.camel@yio.site>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 18, 2009 at 05:34:17PM +0200, Kay Sievers wrote:
> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: vc: create vcs(a) devices for consoles
> 
> The buffer for the consoles are unconditionally allocated at
> con_init() time, which miss the creation of the vcs(a) devices.
> 
> Since 2.6.30, these devices are no longer created at open()
> and removed on close(), but controlled by the lifetime of the
> buffers.

Is this a bug in .31-rc right now?  Should this make it into the final
.31 release?

And what caused this change, tty changes?  If so, it should go through
Alan Cox's tree.

thanks,

greg k-h
