Return-Path: <linux-kernel-owner+w=401wt.eu-S1762151AbXKTVz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762151AbXKTVz3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 16:55:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757313AbXKTVzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 16:55:21 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:65401 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580AbXKTVzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 16:55:20 -0500
Date: Tue, 20 Nov 2007 22:54:15 +0100
From: Chris Friedhoff <chris@friedhoff.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "chris@friedhoff.org" <chris@friedhoff.org>
Subject: Re: 2.6.24-rc2 STD with s2disk fails to activate suspended system
 after loading - now 2.6.24-rc3
Message-Id: <20071120225415.c5943463.chris@friedhoff.org>
In-Reply-To: <200711200058.29663.rjw@sisk.pl>
References: <20071110221629.1d180480.chris@friedhoff.org>
	<200711191958.36570.rjw@sisk.pl>
	<20071119234334.2b955b92.chris@friedhoff.org>
	<200711200058.29663.rjw@sisk.pl>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.10.14; i486-slackware-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19ySxkEc9nTJvfENDqG3PoqYLvEBu7ohr5gs/3
 ftNVyJHUEDEtxbjhBg6ZQEPvA41eHsuKBy3tpJ8uBJxMxXoCtS
 krezoEbGJJh/fFXA4kKY3U5ZFSO+7QH
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The patch
http://bugzilla.kernel.org/attachment.cgi?id=13652&action=view from
Comment #16 of http://bugzilla.kernel.org/show_bug.cgi?id=9345
also works for me and enables successful s2disk cycles.

Tested with 6 cycles, 3 from console and than 3 from within X.

Thanks,
Chris


On Tue, 20 Nov 2007 00:58:29 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Monday, 19 of November 2007, Chris Friedhoff wrote:
> > dmesg output is added.
> > 
> > increasing CONFIG_BLK_DEV_RAM_SIZE from 7777 to 131072 hasn't changed
> > the non-functioning of 2.6.24-rc3
> > 
> > s2disk works with 2.6.23.8 ; I tested 4 cycles in a row, 2 from console
> > and 2 from within X
> 
> I've attached a patch to the bugzilla entry, please test it.
> 
> Thanks,
> Rafael


--------------------
Chris Friedhoff
chris@friedhoff.org
