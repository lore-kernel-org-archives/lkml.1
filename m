Return-Path: <linux-kernel-owner+w=401wt.eu-S1757393AbZGGGaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbZGGGaB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 02:30:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754194AbZGGG3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 02:29:53 -0400
Received: from smtp-out.google.com ([216.239.33.17]:39394 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940AbZGGG3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 02:29:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=FgalSw0yrKWuDtwIxZglC4nk4ntfuc6b2IRRbnw6TYjw8PttJ53srLl1lTQZQH9Uq
	gkkOdwk7GacuLAs8759oQ==
Date: Mon, 6 Jul 2009 23:29:50 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Larry Finger <Larry.Finger@lwfinger.net>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
In-Reply-To: <4A529F60.7010509@lwfinger.net>
Message-ID: <alpine.DEB.2.00.0907062302540.10840@chino.kir.corp.google.com>
References: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera> <bXZeuxPQAWE.A.Y2.2BpUKB@chimera> <4A529F60.7010509@lwfinger.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jul 2009, Larry Finger wrote:

> I have not seen the fix yet, but one is being prepared. I think the
> bug can be closed.
> 

http://patchwork.kernel.org/patch/34385 should fix your issue (try with 
CONFIG_SLUB_DEBUG_ON still enabled and slub_debug=O on the command line).

Pekka indicated he wanted this fixed in 2.6.31, so he'll probably push it 
to Linus before the 2.6.31-rc3.
