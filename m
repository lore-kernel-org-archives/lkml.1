Return-Path: <linux-kernel-owner+w=401wt.eu-S1756910AbYABV2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910AbYABV2w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 16:28:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbYABV2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 16:28:45 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:37480 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbYABV2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 16:28:44 -0500
Date: Wed, 2 Jan 2008 22:28:43 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       davem@davemloft.net, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Use __u64 in aligned_u64's definition
In-Reply-To: <alpine.LFD.1.00.0801021251040.32517@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0801022225460.14900@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801022135500.14900@fbirervta.pbzchgretzou.qr>
 <alpine.LFD.1.00.0801021251040.32517@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 2 2008 12:52, Linus Torvalds wrote:
>On Wed, 2 Jan 2008, Jan Engelhardt wrote:
>> 
>> please cherrypick 35f2e577e432b28969710bc1fd4d9a4c0875f81b from
>> the git://computergmbh.de/linux repository from the "netfilter"
>> branch (or use patch below).
>
>Umm. This is missing an explanation of what exactly cares.. Does it 
>actually fix some bogus warning, or is it just a cleanup? After -rc1, I 
>care. After -rc5, I care a lot.
>
A cleanup. Or perhaps a precautionary change, should unsigned long
long ever become something that is not 64-bit. It was intended for
2.6.25 actually. You don't take patches this early, do you?


thanks,
Jan
