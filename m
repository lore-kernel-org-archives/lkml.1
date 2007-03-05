Return-Path: <linux-kernel-owner+w=401wt.eu-S1752840AbXCESMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbXCESMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 13:12:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbXCESMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 13:12:30 -0500
Received: from morbo.e-centre.net ([66.154.82.3]:65199 "EHLO
	cubert.e-centre.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752840AbXCESM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 13:12:29 -0500
X-Greylist: delayed 12029 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Mar 2007 13:12:28 EST
X-ASG-Debug-ID: 1173106317-24137-37-0
X-Barracuda-URL: http://10.3.1.19:8000/cgi-bin/mark.cgi
X-ASG-Orig-Subj: Re: [patch] disable NMI watchdog by default
Subject: Re: [patch] disable NMI watchdog by default
From: Arjan van de Ven <arjan@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20070305122011.GA16133@elte.hu>
References: <20070305122011.GA16133@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 05 Mar 2007 06:49:57 -0800
Message-Id: <1173106198.3218.130.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=4.0 tests=
X-Barracuda-Spam-Report: Code version 3.02, rules version 3.0.35707
	Rule breakdown below  pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Frankly, i find it ridiculous that i had to write more than 10 emails 
> about this stupid topic already, while i'm the original author of this 
> feature to begin with. The "do not enable by default debug features that 
> break certain systems" concept is obvious to me.


NMI breaks on some systems, esp in combination with SMM so

Acked-by: Arjan van de Ven <arjan@linux.intel.com> for both 32 bit and
64 bit
