Return-Path: <linux-kernel-owner+w=401wt.eu-S1754030AbXEXXAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbXEXXAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 19:00:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750768AbXEXW75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 18:59:57 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:52442 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750751AbXEXW75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 18:59:57 -0400
X-Sasl-enc: Pz6ZzF8lub4+kKF3294lzA6P9M0jFlB9efow+AJBx22K 1180047595
Date: Thu, 24 May 2007 19:59:52 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Damien Wyart <damien.wyart@free.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc2 and libata/shutdown
Message-ID: <20070524225952.GB29678@khazad-dum.debian.net>
References: <20070524102122.GA8652@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070524102122.GA8652@localhost.localdomain>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007, Damien Wyart wrote:
> After trying 2.6.22-rc2, I noticed the warning message from libata about
> upgrading shutdown(8). First, I have two SATA disks, and get the warning for
> only one of them. Second, I double-checked the source of shutdown for my
> distro (Debian unstable), and do not see anything related to issueing
> STANDBYNOW.

It is done inside the halt binary.  You can disable that STANDBYNOW by
editing /etc/init.d/halt and removing the -h the initscript passes to halt.
Look for a line that has something like hddown="-h".

But if you do, make sure the kernel is configured to shutdown all SCSI and
SATA disks first!

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
