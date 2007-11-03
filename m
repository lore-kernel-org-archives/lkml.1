Return-Path: <linux-kernel-owner+w=401wt.eu-S1755170AbXKCMa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbXKCMa0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 08:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753586AbXKCMaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 08:30:09 -0400
Received: from main.gmane.org ([80.91.229.2]:60164 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754603AbXKCMaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 08:30:07 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Remigiusz Modrzejewski <lkml.only@maxnet.org.pl>
Subject: Policy on dual licensing?
Date: Sat, 3 Nov 2007 12:14:15 +0000 (UTC)
Message-ID: <slrnfiopoa.9cu.lkml.only@localhost.localdomain>
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: host-ip38-174.crowley.pl
X-stopkeylogger: don't use broken software
X-Posting-License: http://ppl.7thguard.net/PPL
X-Homesite: http://lrem.net/
User-Agent: slrn/0.9.8.1 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We've all seen the last flame war about Linux stealing BSD code. Due to
Theo's bad wording whole discussion rolled around the question about
legality of this, a big waste of time (question answered a thousand
times). Still, the question about ethics is quite valid...

There are over four hundred C source files that mention BSD, but only 
a hundred of them is dual licensed. Of course not all mentions of BSD
mean the file is derived from it, as well as not each such licensed file
must use the acronym.  No matter what the scale really is, the problem
exists.

What I suppose is that people porting BSD code to Linux don't mean
closing the doors for back-porting changes. They are simply unaware 
or forget about the possibility of dual licensing. Obviously, each
submitter should read Documentation/SubmittingDrivers, where it is
explicitly stated. Yet humans are prone to forgetting, so this may
seem not enough.

What I propose is implementing a policy on accepting such code.
According to it, every time a maintainer is considering a driver
that is derived from BSD and licensed GPL-only, should request
for dual licensing before accepting the patch. If the submitter is
reluctant to do so - what can we do, it's better to have this inside
this way than not at all. However, this should minimize such cases 
and, hopefully, satisfy the claims about Linux maintainers not doing 
all that they could to make the world a better place.

Best regards,
Remigiusz Modrzejewski

-- 
Remigiusz 'lRem' Modrzejewski
I might be *extremely unresponsive* at the From: email...
Contact: http://lrem.net/pages/view/about
Feel free to correct my English.

