Return-Path: <linux-kernel-owner+w=401wt.eu-S932363AbXIKTlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363AbXIKTlE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 15:41:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763605AbXIKTkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 15:40:51 -0400
Received: from adelie.ubuntu.com ([82.211.81.139]:55426 "EHLO
	adelie.ubuntu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763590AbXIKTku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 15:40:50 -0400
X-Greylist: delayed 1930 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Sep 2007 15:40:50 EDT
Subject: Re: regression: fireware causes oops during system
From: Ben Collins <ben.collins@ubuntu.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, stefanr@s5r6.in-berlin.de,
       linux1394-devel@lists.sourceforge.net
In-Reply-To: <20070911190043.GA1577@elf.ucw.cz>
References: <20070911190043.GA1577@elf.ucw.cz>
Content-Type: text/plain
Organization: Canonical
Date: Tue, 11 Sep 2007 15:08:36 -0400
Message-Id: <1189537716.7620.192.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-09-11 at 21:00 +0200, Pavel Machek wrote:
> Hi!
> 
> I noticed empty suspend stopped working around 2.6.23-rc4, and it is
> still present in 2.6.23-rc6. To reproduce
> 
> swapoff -a 
> echo disk > /sys/power/state
> echo disk > /sys/power/state
> 
> Unsetting
> 
> CONFIG_IEEE1394=y
> 
> solves the problem.

Since this is easy to reproduce, can you bisect it down?

-- 
Ubuntu   : http://www.ubuntu.com/
Linux1394: http://wiki.linux1394.org/
SwissDisk: http://www.swissdisk.com/

