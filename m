Return-Path: <linux-kernel-owner+w=401wt.eu-S1753344AbXCZRnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbXCZRnG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 13:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbXCZRnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 13:43:06 -0400
Received: from iggypop2.siwnet.net ([81.216.65.12]:49807 "EHLO
	iggypop2.siwnet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbXCZRnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 13:43:03 -0400
From: Marcus Better <marcus@better.se>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: [3/5] 2.6.21-rc4: known regressions (v2)
Date: Mon, 26 Mar 2007 19:42:51 +0200
User-Agent: KMail/1.9.6
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <200703261200.25587.marcus@better.se> <20070326143433.GC16477@stusta.de>
In-Reply-To: <20070326143433.GC16477@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703261942.52126.marcus@better.se>
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Mon Mar 26 19:43:00 2007
X-DSPAM-Confidence: 0.5832
X-DSPAM-Probability: 0.0265
X-DSPAM-Signature: 46080624744011868995345
X-DSPAM-Factors: 27,
	Received*(unknown, 0.94439,
	went, 0.15440,
	were, 0.18075,
	Yes, 0.20359,
	From*Marcus Better <marcus@better.se>, 0.23118,
	Subject*Re, 0.67420,
	Received*(Postfix)+with, 0.67386,
	Received*(Postfix)+with, 0.67386,
	Received*(Postfix), 0.67386,
	Received*(Postfix), 0.67386,
	Cc*vger.kernel.org>, 0.40000,
	Subject*regressions+(v2), 0.40000,
	R60, 0.40000,
	Cc*J., 0.40000,
	(The, 0.40000,
	Received*D4AC72059BB, 0.40000,
	Cc*<rjw+sisk.pl>, 0.40000,
	Received*879C6114, 0.40000,
	instant, 0.40000,
	Adrian+Bunk, 0.40000,
	Received*ESMTP, 0.40000,
	Received*ESMTP, 0.40000,
	Subject*[3/5], 0.40000,
	Content-Disposition*inline, 0.40000,
	), 0.40000,
	To*<bunk, 0.40000,
	From*Marcus, 0.40000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> > > Subject    : ThinkPad R60: suspend to disk broken

> Does setting CONFIG_PCI_MSI=n make any difference?

Yes, it does. The hanging resume problem went away. 

(The display corruption and the instant resume were not affected.)

Marcus

