Return-Path: <linux-kernel-owner+w=401wt.eu-S1755492AbYDMUDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbYDMUDk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 16:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752506AbYDMUDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 16:03:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37140 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbYDMUDb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 16:03:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Miller <davem@davemloft.net>
Subject: Re: [Bug #10434] 2.6.25-rc8: FTP transfer errors
Date: Sun, 13 Apr 2008 22:02:54 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, johnpol@2ka.mipt.ru,
       ilpo.jarvinen@helsinki.fi, jeff@garzik.org, lkml@rtr.ca,
       xemul@openvz.org, yoshfuji@linux-ipv6.org
References: <RR4Oy_oXY2J.A.b0H.A3lAIB@albercik> <oq66hWjeF4N.A.yJ.L3lAIB@albercik> <20080413.124823.173625519.davem@davemloft.net>
In-Reply-To: <20080413.124823.173625519.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804132202.55395.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 13 of April 2008, David Miller wrote:
> From: "Rafael J. Wysocki" <rjw@sisk.pl>
> Date: Sun, 13 Apr 2008 20:56:42 +0200 (CEST)
> 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.24.  Please verify if it still should be listed.
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10434
> > Subject		: 2.6.25-rc8: FTP transfer errors
> > Submitter	: Mark Lord <lkml@rtr.ca>
> > Date		: 2008-04-09 00:56 (5 days old)
> > References	: http://lkml.org/lkml/2008/4/9/4
> > Handled-By	: Jeff Garzik <jeff@garzik.org>
> > 		  YOSHIFUJI Hideaki / 吉藤英明 <yoshfuji@linux-ipv6.org>
> > 		  Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
> > 		  David S. Miller <davem@davemloft.net>
> > 		  Evgeniy Polyakov <johnpol@2ka.mipt.ru>
> > Patch		: http://lkml.org/lkml/2008/4/10/409
> > 
> 
> This patch is in Linus's tree and thus the bug is fixed.

Hm, "git whatchanged net/ipv4/inet_timewait_sock.c" returns

commit 7951f0b03a63d657c72c7d54d306ef3357e7e604
Author: Daniel Lezcano <dlezcano@fr.ibm.com>
Date:   Thu Apr 10 20:53:10 2008 -0700

    [NETNS][IPV6] tcp - assign the netns for timewait sockets

as the most recent commit changing that file ...

It doesn't look like the patch has been merged yet.

Thanks,
Rafael
