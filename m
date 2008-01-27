Return-Path: <linux-kernel-owner+w=401wt.eu-S1755905AbYA0Kmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbYA0Kmx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 05:42:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbYA0Kmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 05:42:44 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:34871 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbYA0Kmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 05:42:44 -0500
Date: Sun, 27 Jan 2008 11:42:42 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Kevin Winchester <kjwinchester@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: X fails to start with latest Linus git
In-Reply-To: <20080127062703.GA23444@elte.hu>
Message-ID: <Pine.LNX.4.64.0801271142070.15243@fbirervta.pbzchgretzou.qr>
References: <479BCE03.6070603@gmail.com> <479BD1D1.8020503@gmail.com>
 <20080127062703.GA23444@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 27 2008 07:27, Ingo Molnar wrote:
>* Kevin Winchester <kjwinchester@gmail.com> wrote:
>
>> The machine boots normally, but without that revert, X locks up.  Does 
>> that make sense to anyone?
>
>could you send your full bootlog? Also please send me the output of:
>
> http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh
>
>and please send me your .config as well.
>
>somehow this new ktime_get() done within printk() will lock up your box 
>- that's weird. We can undo this commit easily, but it would be nice to 
>figure out what's going on.

Maybe it's not valid to call ktime_get() within interrupt context?
