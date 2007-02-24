Return-Path: <linux-kernel-owner+w=401wt.eu-S1750928AbXBXLJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750928AbXBXLJw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 06:09:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750922AbXBXLJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 06:09:52 -0500
Received: from smtp.osdl.org ([65.172.181.24]:57668 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbXBXLJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 06:09:52 -0500
Date: Sat, 24 Feb 2007 03:09:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Gray <mvg001@markvgray.com>
Cc: linux-kernel@vger.kernel.org, Sam Hokin <sam@ims.net>,
       Chuck Ebbert <cebbert@redhat.com>,
       Markus Lidel <Markus.Lidel@shadowconnect.com>
Subject: Re: I2O block driver broken in kernel 2.6.19?
Message-Id: <20070224030924.e2b0fcce.akpm@linux-foundation.org>
In-Reply-To: <loom.20070223T235432-923@post.gmane.org>
References: <45D8E102.6090004@redhat.com>
	<loom.20070223T235432-923@post.gmane.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


(cc's restored.  Please, always do reply-to-all)

> On Fri, 23 Feb 2007 22:57:27 +0000 (UTC) Mark Gray <mvg001@markvgray.com> wrote:
> >  i2o/hda:<3>Buffer I/O error on device i2o/hda, logical block 0
> > Buffer I/O error on device i2o/hda, logical block 0
> 
> Same error here. Both 2.6.19 and 2.6.20 kernels, using Adaptec 2400A RAID.

Is Adaptec 2400 controlled by drivers/message/i2o? I assume so...

If so, thats's at least three people reporting breakage in 2.6.19 and later.

Is anyone able perform a git-bisect to identify the offending commit?  It
would really help.

Thanks.

