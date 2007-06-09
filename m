Return-Path: <linux-kernel-owner+w=401wt.eu-S1758079AbXFIH44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079AbXFIH44 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 03:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753647AbXFIH4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 03:56:49 -0400
Received: from host86-137-96-215.range86-137.btcentralplus.com ([86.137.96.215]:57875
	"EHLO hawkeye.stone.uk.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755107AbXFIH4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 03:56:49 -0400
Message-ID: <466A5D25.3090008@hawkeye.stone.uk.eu.org>
Date: Sat, 09 Jun 2007 08:56:21 +0100
From: Jack Stone <jack@hawkeye.stone.uk.eu.org>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ian Kent <raven@themaw.net>, hpa@zytor.com
Subject: Re: [PATCH 0/7] Cleanup code to replace DPRINTK with pr_debug
References: <4669D5B7.7050005@hawkeye.stone.uk.eu.org> <1181371406.3423.4.camel@shark.themaw.net>
In-Reply-To: <1181371406.3423.4.camel@shark.themaw.net>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Kent wrote:
> On Fri, 2007-06-08 at 23:18 +0100, Jack Stone wrote:
>> This patch series replaces DPRINTK with pr_debug in alternative.c,
>> autofs, autofs4
>> and ncpfs. A new function called pr_err is also added to keep
>> functionality in
>> ncpfs. The last 2 patches add support for pr_debug_pid and apply it to
>> autofs4 to
>> keep the output the same as the current DPRINTK statements.
> 
> And ???
> 
> Presenting patches without the reason why they are needed is not a good
> policy.
> 
> Not to mention that several appear to be missing headers, I can't
> believe you tested that they applied before posting them.
> 
> NACK.
> 
> Ian

Sorry, I think I must've miss copied the patches. I'll re-email them.

The reason for these patches is to move the debug printk macros to the
central debug printk macro. This is so future updates are easier and the
code is more uniform.

Jack

