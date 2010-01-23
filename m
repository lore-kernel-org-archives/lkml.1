Return-Path: <linux-kernel-owner+w=401wt.eu-S1752838Ab0AWXVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab0AWXVn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 18:21:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956Ab0AWXVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 18:21:42 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:61478 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab0AWXVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 18:21:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PdUSYBNKHRyhnxuz4Wcq26ghtU5CEkCtocD9w0R0k/bDa/g9eorUkLA9N1DoGR4w+P
         deLxAcu2sF6gIMa5xMo+/VPKcsN0mVX8Weootwy8W9ONvOarlB/oGbC5Swvyo+4V1JyG
         Q54cIC58bgt2OPK2MYITxyaC+TstxIFvwX54M=
Date: Sun, 24 Jan 2010 00:21:33 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Michael Breuer <mbreuer@majjas.com>
Cc: David Miller <davem@davemloft.net>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       akpm@linux-foundation.org, flyboy@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Michael Chan <mchan@broadcom.com>, Don Fry <pcnet32@verizon.net>,
       Francois Romieu <romieu@fr.zoreil.com>,
       Matt Carlson <mcarlson@broadcom.com>
Subject: Re: Hang: 2.6.32.4 sky2/DMAR (was [PATCH] sky2: Fix WARNING: at
 lib/dma-debug.c:902 check_sync)
Message-ID: <20100123232133.GA3487@del.dom.local>
References: <20100120094103.GA6225@ff.dom.local>
 <4B58B217.8030001@majjas.com>
 <20100121204133.GB3085@del.dom.local>
 <4B59E7EB.3050605@majjas.com>
 <20100122215304.GA3105@del.dom.local>
 <4B5A2362.6000306@majjas.com>
 <20100122230605.GB3105@del.dom.local>
 <4B5A33D8.90501@majjas.com>
 <20100122234656.GC3105@del.dom.local>
 <4B5A39BD.8020305@majjas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B5A39BD.8020305@majjas.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 22, 2010 at 06:50:21PM -0500, Michael Breuer wrote:
> When the packets were dropped, there was a different sequence in the
> log - DISCOVER/OFFER repeated. The "normal" is that the sequence
> appeared correct and complete - DISCOVER/OFFER/REQUEST/ACK - or
> INFORM/ACK (vs. INFORM repeatedly sans ACK) as the case may be.

Anyway, I'd be intersted if the switch matters here.

Plus one more test: could you try to load sky2 with the parameter:
"copybreak=1" (the rest as in any recent test, which gave you dmar
errors; any switch).

Thanks,
Jarek P.
