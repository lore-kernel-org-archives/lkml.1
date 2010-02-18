Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab0BRVcr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 16:32:47 -0500
Received: from server109f.appriver.com ([72.32.253.90]:1947 "EHLO
	server109.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751857Ab0BRVcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 16:32:46 -0500
X-Policy: GLOBAL - intcomgrp.com
X-Primary: jkosin@intcomgrp.com
X-Note: This Email was scanned by AppRiver SecureTide
X-ALLOW: JKosin@intcomgrp.com ALLOWED
X-Virus-Scan: V-
X-Note: Spam Tests Failed: 
X-Country-Path: PRIVATE->UNITED STATES->UNITED STATES
X-Note-Sending-IP: 216.54.13.100
X-Note-Reverse-DNS: mail.intcomgrp.com
X-Note-WHTLIST: JKosin@intcomgrp.com
X-Note: User Rule Hits: 
X-Note: Global Rule Hits: G173 G174 G175 G176 G180 G181 G192 G279 
X-Note: Encrypt Rule Hits: 
X-Note: Mail Class: ALLOWEDSENDER
X-Note: Headers Injected
Message-ID: <4B7DB266.10105@intcomgrp.com>
Date: Thu, 18 Feb 2010 16:34:30 -0500
From: James Kosin <jkosin@intcomgrp.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.7) Gecko/20100111 Lightning/1.0b1 Thunderbird/3.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] hw-breakpoints: Accept breakpoints on NULL address
References: <edVLc-5aQ-23@gated-at.bofh.it> <efiZ6-5YR-51@gated-at.bofh.it> <eflWW-1XV-11@gated-at.bofh.it>
In-Reply-To: <eflWW-1XV-11@gated-at.bofh.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Feb 2010 21:34:30.0564 (UTC) FILETIME=[27858640:01CAB0E2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/18/2010 4:20 PM, Roland McGrath wrote:
> Setting a watchpoint on address 0 seems like an entirely reasonable thing
> to do.  This change looks right to me.
> 
> Thanks,
> Roland

Okay with me.  Most platforms use address 0x0000 for the RESET vector.
Nice to catch; only problem was if it was a true RESET the information
is gone anyway.
If not a true RESET, the caller tried to call a function at 0x0000 which
then really isn't allowed under most circumstances.

James
