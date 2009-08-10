Return-Path: <linux-kernel-owner+w=401wt.eu-S1752939AbZHJUGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbZHJUGB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 16:06:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbZHJUF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 16:05:59 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:57724 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872AbZHJUF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 16:05:58 -0400
Date: Mon, 10 Aug 2009 23:05:54 +0300
From: Felipe Balbi <me@felipebalbi.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Mike Rapoport <mike@compulab.co.il>, linux-kernel@vger.kernel.org
Subject: Question about userspace-consumer
Message-ID: <20090810200553.GB4652@gandalf>
Reply-To: me@felipebalbi.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I was reading userspace-consumer file ad was wondering whether would be
possible to use that in order to implement what SBS-IF [1] proposes
using sbs-enabled devices.

For doing that, probably userspace-consumer would have to be able to
set_voltage/get_voltage, set/get_current_limit and so on. So I was
thinking on changing userspace-consumer to use regulator_get() instead
of regulator_bulk_get() and make each instance of userspace-consumer to
talk to only and only one regulator.

I didn't put down any code but that seems quite plausible if we attach
userspace-consumer to the proper regulator(s) on board-file.

For doing the implementation and test part, I was thinking on getting
a bq2084evm [2] and sniffing the usb-i2c bus in order to write down some
code to use that under linux, but that's just implementation details.

Anyways, how do you guys feel about it ?

[1] http://www.sbs-forum.org
[2] http://focus.ti.com/docs/toolsw/folders/print/bq2084evm-001.html

-- 
balbi
