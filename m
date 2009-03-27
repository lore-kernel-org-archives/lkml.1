Return-Path: <linux-kernel-owner+w=401wt.eu-S1759571AbZC0DZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759571AbZC0DZW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 23:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759157AbZC0DZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 23:25:07 -0400
Received: from main.gmane.org ([80.91.229.2]:43074 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757421AbZC0DZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 23:25:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Michael B. Trausch" <mike@trausch.us>
Subject: 2.6.29 Networking Problems
Date: Thu, 26 Mar 2009 23:20:45 -0400
Organization: news.gmane.org
Message-ID: <20090326232045.700a251a@zest.trausch.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 173.15.213.186
X-Newsreader: Claws Mail 3.6.1 (GTK+ 2.16.0; x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alright, so I upgraded to 2.6.29 and had all sorts of issues with my
networking (x86-64 system, both forcedeth and 3c59x NICs).  At first I
thought my forcedeth NIC was dying or something, so I disabled it and
installed a trusty 3com.  When it started acting up also, I began to
suspect software, and some searching led me to the thread (and
eventually the patch) at:

  http://patchwork.kernel.org/patch/14465/

So, I applied this patch to my local kernel, and my test (transferring
13 GiB of data over the LAN) now can be run repeatedly.  Prior to
applying the patch, I'd start the transfer and it'd go for about 20
seconds and all transfer would stop, and ping would not return errors,
just nothing.

Any chance that this patch will land in 2.6.29.1?  Or other code that
fixes the same problem?  I haven't tried it against Linus' kernel tree
yet because I probably won't run that kernel again until at least -rc2
or -rc3, so apologies if this issue is already fixed in the trunk.

	--- Mike

