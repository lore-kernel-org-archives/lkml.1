Return-Path: <linux-kernel-owner+w=401wt.eu-S932182AbYGBLZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182AbYGBLZg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 07:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757077AbYGBLZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 07:25:07 -0400
Received: from main.gmane.org ([80.91.229.2]:34597 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756447AbYGBLZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 07:25:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Stefan Becker <stefan.becker@nokia.com>
Subject: Re: 2.6.26-rc8: Reported regressions from 2.6.25
Date: Wed, 2 Jul 2008 11:18:59 +0000 (UTC)
Message-ID: <loom.20080702T110852-313@post.gmane.org>
References: <q5WW6DLC10O.A.dxC.R69ZIB@albercik>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 192.100.116.143 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.14) Gecko/20080416 Fedora/2.0.0.14-1.fc8 Firefox/2.0.0.14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

Rafael J. Wysocki <rjw <at> sisk.pl> writes:
> 
> This message contains a list of some regressions from 2.6.25, for which there
> are no fixes in the mainline I know of.  If any of them have been fixed
> already, please let me know.

I started a discussion about a USB lockup regression for 2.6.24/25 under the
following thread:

<http://thread.gmane.org/gmane.linux.kernel/696589>

I prepared a patch for 2.6.26-final and sent it to Greg:

<http://article.gmane.org/gmane.linux.usb.general/6996>

This will fix IRQF_SHARED|IRQF_DISABLED at least for USB and probably solve
various problems people have reported...

Regards,

     Stefan

