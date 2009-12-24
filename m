Return-Path: <linux-kernel-owner+w=401wt.eu-S1755953AbZLXEyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953AbZLXEyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 23:54:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbZLXEyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 23:54:14 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40562
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751115AbZLXEyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 23:54:13 -0500
Date: Wed, 23 Dec 2009 20:54:15 -0800 (PST)
Message-Id: <20091223.205415.232734959.davem@davemloft.net>
To: lethal@linux-sh.org
Cc: johnstul@us.ibm.com, linux-kernel@vger.kernel.org, rth@twiddle.net,
       linux-alpha@vger.kernel.org, linux-sh@vger.kernel.org,
       linux@arm.linux.org.uk, hskinnemoen@atmel.com, vapier@gentoo.org,
       starvik@axis.com, dhowells@redhat.com, ysato@users.sourceforge.jp,
       tony.luck@intel.com, takata@linux-m32r.org, geert@linux-m68k.org,
       yasutake.koichi@jp.panasonic.com, kyle@mcmartin.ca
Subject: Re: [RFC][PATCH 0/14] Convert remaining arches to
 read/update_persistent_clock
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091223050810.GA25791@linux-sh.org>
References: <1261540762.3508.61.camel@localhost.localdomain>
	<20091223050810.GA25791@linux-sh.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mundt <lethal@linux-sh.org>
Date: Wed, 23 Dec 2009 14:08:10 +0900

> In any event, I wonder if it might make more sense to take something like
> the SPARC implementation that is simply a wrapper around the RTC, move
> that out in to a more generic place, and permit architectures to select
> an RTC class backed persistent clock instead (it seems to be only
> platforms that haven't caught up yet in terms of generic time and RTC
> migration that would want to define this interface on their own at all at
> this point)?

This sounds nice but don't we have a slew of RTC types that need
to be accessed over I2C and thus you can't touch them without
sleeping?
