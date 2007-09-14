Return-Path: <linux-kernel-owner+w=401wt.eu-S932611AbXINPdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932611AbXINPdB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 11:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbXINPcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 11:32:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbXINPcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 11:32:52 -0400
Message-ID: <46EAA9A1.1080100@redhat.com>
Date: Fri, 14 Sep 2007 11:32:49 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: EDD still failing on some systems with 2.6.23-rc6-git2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I added debugging code to print a letter for each step in i386 setup,
and it gets to 'J', then it hangs:

        /* Query EDD information */
#if defined(CONFIG_EDD) || defined(CONFIG_EDD_MODULE)
        putchar('J');
        query_edd();
#endif

Multiple reports of this happening on 2.6.23-rc6 can be found at
the end of:

https://bugzilla.redhat.com/show_bug.cgi?id=251724
https://bugzilla.redhat.com/show_bug.cgi?id=239585
