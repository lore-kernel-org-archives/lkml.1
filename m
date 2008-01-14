Return-Path: <linux-kernel-owner+w=401wt.eu-S1753384AbYANNEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbYANNEd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 08:04:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751001AbYANNEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 08:04:25 -0500
Received: from mxout1.volkswagen.de ([194.114.62.41]:29065 "EHLO
	mxout1.volkswagen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbYANNEY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 08:04:24 -0500
X-Greylist: delayed 366 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Jan 2008 08:04:24 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Missing 'warned = 1' in your latest linux-2.6 commit
Date: Mon, 14 Jan 2008 13:58:01 +0100
Message-ID: <71A66C381173F7418BA6E78EE9E33465AC02EC@vwagwox00011.vw.vwg>
Thread-Topic: Missing 'warned = 1' in your latest linux-2.6 commit
Thread-Index: AchWrRgHdY3nISqXQVKHsEQtkKXuYQ==
From: "Hartkopp, Oliver (K-EFE/E)" <oliver.hartkopp@volkswagen.de>
To: <len.brown@intel.com>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 14 Jan 2008 12:58:02.0104 (UTC) FILETIME=[18894780:01C856AD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

in two cases you just introduce the 'warned' variable but do not set
them to '1' after the printk() which is the intetion to print it just
one time. Namely in pnpacpi_parse_allocated_ioresource() and
pnpacpi_parse_allocated_memresource() the 'warned = 1' is missing.

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commi
tdiff;h=66a21736defda339cd93a0e70c1120ab813640f6;hp=2c838197751db19d08a0
0e633e33dce23a69fb0c

Even if it will vanish in 2.6.25 you should fix this new introduced
code. :-)

Regards,
Oliver

