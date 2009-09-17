Return-Path: <linux-kernel-owner+w=401wt.eu-S1758636AbZIQNOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758636AbZIQNOo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 09:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758239AbZIQNOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 09:14:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51955 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754613AbZIQNOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 09:14:42 -0400
Date: Thu, 17 Sep 2009 14:15:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Markus Armbruster <armbru@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>, Alan Cox <alan@linux.intel.com>,
       Amit Shah <amit.shah@redhat.com>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for
 generic guest and host communication
Message-ID: <20090917141531.4d2489d4@lxorguk.ukuu.org.uk>
In-Reply-To: <87tyz1en5f.fsf@pike.pond.sub.org>
References: <1252678386-17404-1-git-send-email-amit.shah@redhat.com>
	<1252678386-17404-2-git-send-email-amit.shah@redhat.com>
	<20090911170010.34c80f2d@linux.intel.com>
	<20090911163806.GB25535@amit-x200.redhat.com>
	<4AAA8838.1080106@codemonkey.ws>
	<20090911173307.GB27046@amit-x200.redhat.com>
	<4AAA8A56.3040707@codemonkey.ws>
	<20090916112332.6bf981a5@linux.intel.com>
	<4AB164A0.8000402@codemonkey.ws>
	<87tyz1en5f.fsf@pike.pond.sub.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, really fundamentally, this is just a reliable full-duplex byte
> stream, with connect and hangup notification.  To me, that sounds more
> like TCP with an address family almost, but not quite AF_UNIX, but that
> case was thrown out of court long ago, so here we are.

Well the tty one has also been thrown out of court because its even dumber

To be honest it sounds more to me like either a pipe or a char device, or
in most cases like sysfs.

Alan
