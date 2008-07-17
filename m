Return-Path: <linux-kernel-owner+w=401wt.eu-S1756999AbYGQIzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999AbYGQIzS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 04:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754193AbYGQIzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 04:55:05 -0400
Received: from main.gmane.org ([80.91.229.2]:44584 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754433AbYGQIzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 04:55:04 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: el es <el_es_cr@yahoo.co.uk>
Subject: Kernel version : what about s.yy.ww.tt scheme ?
Date: Thu, 17 Jul 2008 08:51:19 +0000 (UTC)
Message-ID: <loom.20080717T083755-676@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 81.151.87.91 (Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.16) Gecko/20080702 Firefox/2.0.0.16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
inspired by the bikeshed painting contest, I got the following idea :

The scheme to be s.yy.ww.tt, that is :

s - series, as it is now (freedom to Linus to bump it to 3 when BKL is removed
for example ;) )

yy - two (in a hundred years, three) digits of the year

Now the interesting part begins which is

ww - the number of the week of the release. This will be between 1 and 52 (53)

tt - the number of the week of stable release. As above.

I see it like :

Take a hypotetical new-scheme 2.8.30 release (roughly the current 2.6.26, didn't
count these weeks). Linus starts to accumulate patches for 2.8.30-rcX as usual,
and when he is ready to release, puts the release week number instead of 30 -
let's assume it is a 2.8.40 then, more or less. By the time, the stable team
produces 2.8.30.[32,34,36,38,40 and so on]. If the weeks leap into the next
year, stable team puts e.g. 2.8.30.9.01 (yy.ww). This scheme would reflect the
fast pace of development quite good, and also have the information, when the
code in question was produced actually. I think the weekly granularity is quite
good idea anyway.

What do you think ?



