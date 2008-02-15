Return-Path: <linux-kernel-owner+w=401wt.eu-S1758946AbYBOTzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758946AbYBOTzh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 14:55:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753576AbYBOTza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 14:55:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43615 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083AbYBOTz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 14:55:29 -0500
Date: Fri, 15 Feb 2008 20:55:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <andi@firstfloor.org>
Subject: [patch 0/3] x86_64: CPA, fix cache attribute inconsistency bug
Message-ID: <20080215195508.GA12405@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


the following 3 patches are the backports to 2.6.22, 2.6.23 and 2.6.24 
of a CPA bug we found while writing 2.6.25's new CPA code.

the bug affects the 64-bit kernel on two popular Linux distros, Fedora 
and Ubuntu:

   $ grep RELOCA /boot/config-2.6.23.9-85.fc8
     CONFIG_RELOCATABLE=y

   $ grep RELOC /boot/config-2.6.22-14-generic
     CONFIG_RELOCATABLE=y

havent checked more.

(There are no upstream commits for this because this code is not present 
in the new code.)

	Ingo
