Return-Path: <linux-kernel-owner+w=401wt.eu-S1753111AbXCWOgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbXCWOgs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 10:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753123AbXCWOgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 10:36:47 -0400
Received: from iggypop2.siwnet.net ([81.216.65.12]:54509 "EHLO
	iggypop2.siwnet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbXCWOgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 10:36:46 -0400
From: Marcus Better <marcus@better.se>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] clockevents: Fix suspend/resume to disk hangs
Date: Fri, 23 Mar 2007 15:36:34 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <eu05p3$u20$1@sea.gmane.org> <200703231447.47741.rjw@sisk.pl>
In-Reply-To: <200703231447.47741.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703231536.34566.marcus@better.se>
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Fri Mar 23 15:36:42 2007
X-DSPAM-Confidence: 0.6354
X-DSPAM-Probability: 0.0062
X-DSPAM-Signature: 4603e5fa20677806819289
X-DSPAM-Factors: 27,
	Received*(unknown, 0.94439,
	as+I, 0.12045,
	Date*Fri, 0.15939,
	Received*Fri, 0.18895,
	Received*Fri, 0.18895,
	as, 0.20688,
	From*Marcus Better <marcus@better.se>, 0.23155,
	Subject*Re, 0.67420,
	Received*(Postfix)+with, 0.67386,
	Received*(Postfix)+with, 0.67386,
	Received*(Postfix), 0.67386,
	Received*(Postfix), 0.67386,
	but, 0.40000,
	Received*15E04205827, 0.40000,
	driver?+No, 0.40000,
	of, 0.40000,
	Received*ESMTP, 0.40000,
	Received*ESMTP, 0.40000,
	manage, 0.40000,
	Content-Disposition*inline, 0.40000,
	References*<eu05p3$u20$1+sea.gmane.org>, 0.40000,
	From*Marcus, 0.40000,
	use, 0.40000,
	To*"Rafael, 0.40000,
	RAM+but, 0.40000,
	References*sea.gmane.org>, 0.40000,
	to+suspend, 0.40000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Do you use the microcode driver?

No.

I'm in the middle of bisecting. Strange enough the symptoms change as I go. 
Some commits manage to suspend to RAM, but hang at resume.

Marcus

