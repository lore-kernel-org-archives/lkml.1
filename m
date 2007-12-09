Return-Path: <linux-kernel-owner+w=401wt.eu-S1752591AbXLISb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbXLISb6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 13:31:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbXLISbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 13:31:49 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:36717 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbXLISbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 13:31:47 -0500
X-Greylist: delayed 1462 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Dec 2007 13:31:47 EST
Date: Sun, 9 Dec 2007 21:07:29 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Bob Tracy <rct@frus.com>
Cc: Michael Cree <mcree@orcon.net.nz>, Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, rjw@sisk.pl, rth@twiddle.net,
       linux-scsi@vger.kernel.org, greg@kroah.com
Subject: Re: [BUG] 2.6.23-rc3 can't see sd partitions on Alpha
Message-ID: <20071209210729.A20635@jurassic.park.msu.ru>
References: <475B3C23.6010304@orcon.net.nz> <20071209041939.7DE6FDBA2@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
In-Reply-To: <20071209041939.7DE6FDBA2@gherkin.frus.com>; from rct@frus.com on Sat, Dec 08, 2007 at 10:19:39PM -0600
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2007 at 10:19:39PM -0600, Bob Tracy wrote:
> I *do* have CONFIG_MAGIC_SYSRQ set.  Anyone care to bet whether my
> machine starts working again if I disable it?  Sheesh...

Incredible...

Toggling CONFIG_MAGIC_SYSRQ works for me too, so I'm finally able
to reproduce the problem (which is the main positive result so far ;-)

There are lots of possible reasons why this happens, but at the
moment I honestly have no idea.
For now I have reassigned the bug #9457 to myself and will gradually hack
into udev...

Ivan.
