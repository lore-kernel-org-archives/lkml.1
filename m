Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab0BAP32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 10:29:28 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54693 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754988Ab0BAP31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 10:29:27 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sebastian Ott <sebott@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] PM: disable nonboot cpus before suspending devices
Date: Mon, 1 Feb 2010 16:30:04 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
References: <alpine.LFD.2.00.1001221841490.2266@localhost> <201001252237.42545.rjw@sisk.pl> <alpine.LFD.2.00.1002011527580.5334@localhost>
In-Reply-To: <alpine.LFD.2.00.1002011527580.5334@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002011630.04281.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 February 2010, Sebastian Ott wrote:
> Hi Rafael,
> 
> since you didn't like the idea of calling the driver callbacks with just
> one cpu enabled, we gave your patch: "MM / PM: Force GFP_NOIO during
> suspend/hibernation and resume" a try and i can confirm that this
> fixes the issue on s390.

Great, thanks for testing!

> Will this go in 2.6.33/stable?

That depends on Andrew, actually.

Andrew, what do you think of the patch at:
http://patchwork.kernel.org/patch/74740/mbox/ ?

It helps people and I don't see any major drawbacks of it.

Rafael
