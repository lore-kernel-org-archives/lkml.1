Return-Path: <linux-kernel-owner+w=401wt.eu-S967648AbXG3SMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967648AbXG3SMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 14:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966340AbXG3SMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 14:12:12 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:32633 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966439AbXG3SML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 14:12:11 -0400
Subject: Re: [PATCH -rt] temporary WARN_ON removal
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
In-Reply-To: <20070723195548.GA10445@elte.hu>
References: <1185124961.2573.14.camel@imap.mvista.com>
	 <20070723195548.GA10445@elte.hu>
Content-Type: text/plain
Date: Mon, 30 Jul 2007 11:01:30 -0700
Message-Id: <1185818490.2636.49.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-23 at 21:55 +0200, Ingo Molnar wrote:
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > These two WARN_ON calls send my system into a boot hang. They trigger 
> > over and over , some examples below.
> 
> hm, could you try to figure out why they trigger on your box and not on 
> anyone else's box? By disabling them we might be papering over a 
> potential problem.

This patch can be ignored .. I must have mistakenly though I had the
series fully applied .. Turned out to be a bisect issue .. The WARN_ONs
are added before the SYSTEM_BOOTING_SCHEDULER_OK changes.. So naturally
you get these warnings .. The change in my tree resolved this ..

Daniel

