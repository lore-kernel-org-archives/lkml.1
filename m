Return-Path: <linux-kernel-owner+w=401wt.eu-S1753949AbYKJHxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbYKJHxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 02:53:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753911AbYKJHw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 02:52:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50696 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837AbYKJHw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 02:52:56 -0500
Date: Mon, 10 Nov 2008 08:52:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: CONFIG_NUMA breaks hibernation on x86-32 with PAE
Message-ID: <20081110075216.GD2093@elte.hu>
References: <20081109140726.GB1786@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081109140726.GB1786@ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0087]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@suse.cz> wrote:

> ...at least on 2.6.27 and 2.6.28-rc3. Resume gets to 
> acpi_hibernation_leave, then SLAB corruption is detected and machine 
> ends in series of oops.
> 
> Any ideas how to debug that?

do you get any serial log or USB key output, so that it's debuggable 
directly?

	Ingo
