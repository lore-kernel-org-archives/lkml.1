Return-Path: <linux-kernel-owner+w=401wt.eu-S933517AbYETUAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933517AbYETUAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 16:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759032AbYETUAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 16:00:30 -0400
Received: from mx1.slu.se ([130.238.96.70]:49035 "EHLO mx1.slu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756318AbYETUA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 16:00:29 -0400
From: Robert Olsson <Robert.Olsson@data.slu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18483.11702.257165.615708@robur.slu.se>
Date: Tue, 20 May 2008 21:59:50 +0200
To: "Denis V. Lunev" <den@openvz.org>
Cc: Robert Olsson <Robert.Olsson@data.slu.se>, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Patrick McHardy <kaber@trash.net>,
       Robert Olsson <robert.olsson@its.uu.se>,
       Ben Greear <greearb@candelatech.com>
Subject: Re: [PATCH 2/4] pktgen: make sure that pktgen_thread_worker has
	been executed
In-Reply-To: <1211309022.7496.3.camel@iris.sw.ru>
References: <1211277589-8565-1-git-send-email-den@openvz.org>
	<1211277589-8565-2-git-send-email-den@openvz.org>
	<18483.6334.468166.282922@robur.slu.se>
	<1211309022.7496.3.camel@iris.sw.ru>
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Denis V. Lunev writes:

 > static int kthread(void *_create)
 > {
 >    ...
 >    if (!kthread_should_stop())
 >        pktgen_thread_worker();
 >    ...
 > }
 > 
 > and kthread_stop. If kthread_stop will be called _before_ the control
 > goes inside pktgen_thread_worker you'll OOPS.

 For some reason my tests survives here... but agree the completion syncing
 gives better control.

 Cheers
						--ro
