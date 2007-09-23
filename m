Return-Path: <linux-kernel-owner+w=401wt.eu-S1753373AbXIWANR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbXIWANR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 20:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751224AbXIWANJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 20:13:09 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4348 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbXIWANI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 20:13:08 -0400
Subject: Re: [RFC] New kernel-message logging API
From: Joe Perches <joe@perches.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, holzheu <holzheu@linux.vnet.ibm.com>,
       Rob Landley <rob@landley.net>,
       Dick Streefland <dick.streefland@altium.nl>
In-Reply-To: <19f34abd0709221227v67443c0bg2cd2010e5bd5a6c1@mail.gmail.com>
References: <19f34abd0709221227v67443c0bg2cd2010e5bd5a6c1@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 22 Sep 2007 17:13:03 -0700
Message-Id: <1190506383.30132.11.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-09-22 at 21:27 +0200, Vegard Nossum wrote:
> #define kprint(fmt, ...)

Good ideas.  Perhaps a prefix of klog or kp_ instead?
Given the number of 80 column zealots, character naming length matters.

> Additionally, this would allow the compiler to completely optimize out
> calls that are below a certain log-level severity level [2][3].

Severity doesn't really equate to desire to log.
I'd prefer arbitrary control of log levels.

cheers, Joe

