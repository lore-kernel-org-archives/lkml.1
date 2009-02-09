Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbZBIJkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbZBIJkm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 04:40:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbZBIJkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 04:40:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42870 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689AbZBIJkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 04:40:32 -0500
Date: Mon, 9 Feb 2009 10:40:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Arnd Bergmann <arnd@arndb.de>,
       Geoff Levand <geoffrey.levand@am.sony.com>,
       Remis Lima Baima <remis.developer@googlemail.com>
Subject: Re: [PATCH] ftrace, powerpc64: fix math to calculate offset in TOC
Message-ID: <20090209094014.GE7930@elte.hu>
References: <alpine.DEB.1.10.0902080118480.30802@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0902080118480.30802@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Paul,
> 
> I found the bug that was causing large modules to fail in setting
> up dynamic ftrace. It wound up being a simple math error. To calculate
> the offset in the TOC, I had used an OR, but the bottom half was
> a signed extended short, and it should have been an addition.
> The fix is in my tree below, as well as posted here.

Looks like a .29 candidate?

	Ingo
