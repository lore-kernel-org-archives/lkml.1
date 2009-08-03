Return-Path: <linux-kernel-owner+w=401wt.eu-S1755183AbZHCPNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbZHCPNh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 11:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932157AbZHCPNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 11:13:36 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:33215 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926AbZHCPNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 11:13:36 -0400
X-Greylist: delayed 327 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Aug 2009 11:13:35 EDT
Subject: scheduling co-processors
From: Sherif Fadel <fahmy@vt.edu>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Mon, 03 Aug 2009 18:08:04 +0300
Message-Id: <1249312084.5762.17.camel@sherif-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu fahmy@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020203.4A76FD59.011C,ss=1,fgs=0,
	ip=198.82.161.152,
	so=2009-06-02 18:41:42,
	dmn=2009-06-06 00:02:10,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a dual-core system on which I would like to treat one processor
as a scheduling co-processor. I have already implemented some custom
scheduling policies and tested them with SMP disabled, I would not like
to see if it is possible to have the scheduling algorithm running on one
core and the scheduled tasks running on another.

I do not know if I can somehow use cpus_allowed to restrict the kernel
to one core and the running tasks to another. Is this possible? If so,
could you please inform me how one would go about this?

In case you are wondering why I would need this, I am writing a bunch of
high-overhead distributed scheduling algorithms and I want to mitigate
their overhead in this way.

Thanks.

