Return-Path: <linux-kernel-owner+w=401wt.eu-S1753978AbYGYSTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbYGYSTj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 14:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbYGYSTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 14:19:30 -0400
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:38263 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750858AbYGYST3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 14:19:29 -0400
Message-ID: <488A192F.4040308@lwfinger.net>
Date: Fri, 25 Jul 2008 13:19:27 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kernel BUG in 2.6.26-git series
References: <4889E538.5010007@lwfinger.net> <20080725181514.GL20882@one.firstfloor.org>
In-Reply-To: <20080725181514.GL20882@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Fri, Jul 25, 2008 at 09:37:44AM -0500, Larry Finger wrote:
>> In the current git pulls from Linus's tree, I get a kernel BUG if 
>> CONFIG_SCHED_SMT is defined. It does not always appear, but when it does, 
>> it is late in the bootup sequence. Perhaps there is a timing issue. This is 
>> an x86_64 system on an HP dv2815nr notebook with and AMD Turion X2 CPU. My 
>> distro is openSUSE 11.0.
> 
> A couple of people ran into that. It was a latent bug triggered by
> some changes of mine. Here's the patch.

Thanks. The patch fixes it for me.

Larry

