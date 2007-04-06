Return-Path: <linux-kernel-owner+w=401wt.eu-S1752184AbXDFScc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbXDFScc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 14:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751443AbXDFScc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 14:32:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39689
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750740AbXDFScb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 14:32:31 -0400
Date: Fri, 06 Apr 2007 11:32:29 -0700 (PDT)
Message-Id: <20070406.113229.122031524.davem@davemloft.net>
To: James.Bottomley@SteelEye.com
Cc: aab@cichlid.com, cebbert@redhat.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, aradford@gmail.com
Subject: Re: Oops in scsi_send_eh_cmnd 2.6.21-rc5-git6,7,10,13
From: David Miller <davem@davemloft.net>
In-Reply-To: <1175873277.3677.11.camel@mulgrave.il.steeleye.com>
References: <200704061512.l36FCFjl031431@cichlid.com>
	<1175873277.3677.11.camel@mulgrave.il.steeleye.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Bottomley <James.Bottomley@SteelEye.com>
Date: Fri, 06 Apr 2007 10:27:57 -0500

> On Fri, 2007-04-06 at 08:12 -0700, Andrew Burgess wrote:
> > Yes. The 3w-xxxx.c driver changed between 2.6.18 and 2.6.20 but
> > nothing jumps out to my untrained eyes. Here's the diff:
> > Also, I should mention that the working kernel is a fedora
> > rpm (2.6.18-1.2798.fc6) so I don't know what patches are in it.
> > The vmlinuz is dated Oct 6 2006.
> 
> It's actually a long standing bug in the 3w-xxxx driver.  Apparently it
> assumes request sense is always the use_sg == 0 case.  This is what it
> does on a request sense:

Thanks for figuring this out James.  I was very worried there
was some bug in my scsi_send_eh_cmnd() fix :)
