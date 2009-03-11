Return-Path: <linux-kernel-owner+w=401wt.eu-S1752833AbZCKGuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbZCKGuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 02:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbZCKGub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 02:50:31 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:41714 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567AbZCKGua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 02:50:30 -0400
Date: Wed, 11 Mar 2009 07:50:24 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: David Brownell <david-b@pacbell.net>
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Kim Kyuwon <chammoru@gmail.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "=?UTF-8?B?6rmA6rec7JuQ?=" <q1.kim@samsung.com>,
       "=?UTF-8?B?67CV6rK966+8?=" <kyungmin.park@samsung.com>
Subject: Re: [PATCH] OMAP: HSMMC: Initialize hsmmc controller registers when
 resuming
Message-ID: <20090311075024.5b5fa28a@mjolnir.ossman.eu>
In-Reply-To: <200903102033.51026.david-b@pacbell.net>
References: <4d34a0a70902200400s252f48ddvfd6e0d83e91fa291@mail.gmail.com>
	<4d34a0a70902222141y345a7bc3g314e6de5df156f2d@mail.gmail.com>
	<49A258A2.2020408@nokia.com>
	<200903102033.51026.david-b@pacbell.net>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Mar 2009 19:33:50 -0800
David Brownell <david-b@pacbell.net> wrote:

> 
> It'd be nice to have a nice unambiguous set_voltage()
> request from the MMC core.  The set_ios() thing has
> always been confusing.
> 

set_ios() should be taken out back. But someone has to have the time to
reimplement things. :/

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
