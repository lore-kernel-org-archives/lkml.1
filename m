Return-Path: <linux-kernel-owner+w=401wt.eu-S1753411AbYIYB2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbYIYB2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 21:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbYIYB2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 21:28:11 -0400
Received: from quechua.inka.de ([193.197.184.2]:49377 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179AbYIYB2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 21:28:11 -0400
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] VMware guest detection for x86 and x86-64
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <20080925002333.GD21049@yantp.cn.ibm.com>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1KifeK-0002Qg-00@calista.eckenfels.net>
Date: Thu, 25 Sep 2008 03:28:08 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <20080925002333.GD21049@yantp.cn.ibm.com> you wrote:
> Oh I never heard about this. I've been using several VMware VMs
> (combined RHEL and SLES and Debian) but haven't seen such
> issue. What's the symptom?

Having a high HZ slows down VMs and also leads to tick loss (time drift). HZ
100 or 250 is recommended by most Vendors.

I think some distributions use the reduced HZ value by default anyway, so
you might never had a problem with this.

It is also only a problem with system load and timekeeping, which is not
always obvious. When running a lot of nearly idle VM Guests you might see
it.

Gruss
Bernd
