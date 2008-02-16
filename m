Return-Path: <linux-kernel-owner+w=401wt.eu-S1759514AbYBPTaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759514AbYBPTaB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 14:30:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756464AbYBPT3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 14:29:52 -0500
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:59694 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404AbYBPT3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 14:29:52 -0500
Message-ID: <47B739AA.6070108@tiscali.nl>
Date: Sat, 16 Feb 2008 20:29:46 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] kernel/{exit.c, signal.c, power/process.c}: replace
 !likely(x) by likely(!x)
References: <47B70810.5030608@tiscali.nl> <47B732EF.4050504@zytor.com>
In-Reply-To: <47B732EF.4050504@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Roel Kluin wrote:
>> Not entirely sure who to send this to
>> ---
>> Replace !likely(x) by likely(!x)
> 
> Whoa...
> 
> Are you sure this is correct?
> 
> !likely(x) is equivalent to unlikely(!x), not the opposite, so this is a
> functional change...
> 
>     -hpa
> 
You are right, sorry, Need more caffeine. I will send the right patch later.
