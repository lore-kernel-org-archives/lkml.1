Return-Path: <linux-kernel-owner+w=401wt.eu-S1759472AbYGPOYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759472AbYGPOYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 10:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757388AbYGPOY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 10:24:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43832 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757352AbYGPOYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 10:24:25 -0400
Date: Wed, 16 Jul 2008 16:23:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Lutomirski <luto@myrealbox.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       public-kernel-testers-u79uwXL29TY76Z2rM5mHXA@lo.gmane.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFT] x86 acpi: normalize segment descriptor register on resume
Message-ID: <20080716142354.GA20897@elte.hu>
References: <200807010148.02135.rjw@sisk.pl> <487A2431.2050103@myrealbox.com> <487A4CB7.1080001@firstfloor.org> <200807132115.08230.rjw@sisk.pl> <487A617B.80707@firstfloor.org> <487A67C3.50000@zytor.com> <487AD37A.2050903@zytor.com> <cb0375e10807160713r5aa2bb82md1e0b3b349ca8115@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb0375e10807160713r5aa2bb82md1e0b3b349ca8115@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Andrew Lutomirski <luto@myrealbox.com> wrote:

> Sorry for the delay in testing.  This appears to work and fix the problem.

great, thanks!

Peter's fix is now upstream as:

| commit 3bf2e77453a87c22eb57ed4926760ac131c84459
| Author: H. Peter Anvin <hpa@zytor.com>
| Date:   Sun Jul 13 21:18:02 2008 -0700
|
|    x86, suspend, acpi: enter Big Real Mode

and has been requested to be added to v2.6.26.1 as well.

	Ingo
