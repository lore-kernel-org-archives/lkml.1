Return-Path: <linux-kernel-owner+w=401wt.eu-S1761999AbXEONQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761999AbXEONQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 09:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755269AbXEONQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 09:16:39 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:52928 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754758AbXEONQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 09:16:38 -0400
X-Sasl-enc: dxwY22UZyb76ZhqgW74vAxI+BM8UEdd7jfGwBrv6kQr0 1179234998
Date: Tue, 15 May 2007 10:16:33 -0300
From: Henrique de Moraes Holschuh <hmh@debian.org>
To: Francesco Pretto <ceztko@gmail.com>
Cc: Tejun Heo <htejun@gmail.com>, Phillip Susi <psusi@cfl.rr.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       pkg-sysvinit-devel@lists.alioth.debian.org
Subject: Re: Weird hard disk noise on shutdown (bug #7674)
Message-ID: <20070515131632.GC16673@khazad-dum.debian.net>
References: <fa.Ia7dfo7Zd5kB6KhSYisfswa1aj4@ifi.uio.no> <fa.YHt2nIlQmoW5r2enmTSzsaySwH4@ifi.uio.no> <45DD0348.5040005@shaw.ca> <e5ab0f710702231235ucb559eerb3639ec312aa312a@mail.gmail.com> <463B858E.6060002@cfl.rr.com> <463B99EE.2090001@gmail.com> <e5ab0f710705061119k35ba223j2ecca6e0f8495ed5@mail.gmail.com> <46489D3B.8050805@gmail.com> <e5ab0f710705141346o45ac8721jacbcb753f9d45406@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5ab0f710705141346o45ac8721jacbcb753f9d45406@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2007, Francesco Pretto wrote:
> Ubuntu [1] ang Gentoo [2] bugs opened. Sent a mail to Miquel van
> Smoorenburg, dev  of sysvinit.

For all Debian sysvinit issues, please send email to
pkg-sysvinit-devel@lists.alioth.debian.org (added to CC).

For the Debian sysvinit crew: Guys, have a look at
http://linux-ata.org/shutdown.html.  We need to act on it, and also file a
bug on all of our current kernels (poweroff causes minor but accumulating-
over-time damage to all hardware under control of libata).  This is really
something we should be trying to fix on our 2.6.18 kernels and stable
sysvinit.

> [1] https://bugs.launchpad.net/upstart/+bug/114683
> [2] http://bugs.gentoo.org/show_bug.cgi?id=178559

Tejun, am I right to assume that any servers with self-contained SCSI disks
(i.e. that are not plugged into externally powered drive enclosures, etc)
also get the emergency head unloads when they are powered off?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
