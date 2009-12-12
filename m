Return-Path: <linux-kernel-owner+w=401wt.eu-S1756750AbZLLG7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750AbZLLG7d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 01:59:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbZLLG73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 01:59:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41901 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbZLLG72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 01:59:28 -0500
Date: Sat, 12 Dec 2009 07:59:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: [build failure] Re: [GIT PATCH] USB patches for 2.6.33-git
Message-ID: <20091212065923.GA8500@elte.hu>
References: <20091211212646.GB6624@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091211212646.GB6624@kroah.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


FYI, there's a new build breakage on latest upstream, on allyesconfig 
x86:

 drivers/net/usb/kaweth.c: In function kaweth_open:
 drivers/net/usb/kaweth.c:719: error: implicit declaration of function usb_autopm_enable

The problem appears to be that usb_autopm_enable() is obsolete and got 
eliminated recently via:

| commit 8e4ceb38eb5bbaef22fc00abe9bc11e26bea2ab5
| Author: Alan Stern <stern@rowland.harvard.edu>
| Date:   Mon Dec 7 13:01:37 2009 -0500
|
|    USB: prepare for changover to Runtime PM framework

	Ingo
