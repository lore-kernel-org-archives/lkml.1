Return-Path: <linux-kernel-owner+w=401wt.eu-S1754367AbYGVRd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbYGVRd6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 13:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbYGVRdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 13:33:50 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:43327 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbYGVRdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 13:33:49 -0400
Date: Tue, 22 Jul 2008 10:27:39 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: bjorn.helgaas@hp.com, linux-next@vger.kernel.org
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: linux-next build error (PNP/IXJ)
Message-Id: <20080722102739.61462b04.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm seeing several build errors in linux-next-20080722 that I haven't
seen previously, although I don't know what changed to cause this.

They are all basically the same, in ixj (drivers/telephony/ixj*), when
CONFIG_PNP=n, and CONFIG_PHONE_IXJ=y or =m (so the actual error message
varies depending on IXJ=y or =m):

IXJ=y:
ixj.c:(.text+0x329d98): undefined reference to `pnp_get_resource'
or IXJ=m:
ERROR: "pnp_get_resource" [drivers/telephony/ixj.ko] undefined!


Suggestions?

Thanks,
---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
