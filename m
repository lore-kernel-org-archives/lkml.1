Return-Path: <linux-kernel-owner+w=401wt.eu-S1756605AbXI1XQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbXI1XQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 19:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754274AbXI1XQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 19:16:12 -0400
Received: from outbound-mail-28.bluehost.com ([69.89.17.198]:33873 "HELO
	outbound-mail-28.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754234AbXI1XQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 19:16:11 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH] i915: make vbl interrupts work properly on i965g/gm
Date: Fri, 28 Sep 2007 16:14:11 -0700
User-Agent: KMail/1.9.7
Cc: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0709280248480.10526@skynet.skynet.ie> <200709281307.56037.jbarnes@virtuousgeek.org> <ada1wcimnsy.fsf@cisco.com>
In-Reply-To: <ada1wcimnsy.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709281614.12244.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.103.130.182 authed with jbarnes@virtuousgeek.org}
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box128.bluehost.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [642 12] / [47 12]
X-AntiAbuse: Sender Address Domain - virtuousgeek.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 28, 2007 3:23 pm Roland Dreier wrote:
>  > I don't have a 945 to test with, but Dave might...
>
> Actually I'm not looking for testing (I can test fine on my own
> laptop :) I was just hoping someone with docs could tell me "MSI is
> documented to be broken on 945GM" or "Oh yeah, 945GM requires you to
> set SECRET_MSI_ENABLE_BIT in register FOO before it generates MSIs."
>
> As I said, it's not a big deal but I'd sort of like to know whether
> my MSI enable hack at least has a chance at working before I try too
> hard to get it working.

I don't see anything in the docs (either public or private) that would 
indicate that MSI is broken on those chips, so I'd expect it to work...

Jesse

