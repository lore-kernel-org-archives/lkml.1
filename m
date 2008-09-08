Return-Path: <linux-kernel-owner+w=401wt.eu-S1755712AbYIHUsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712AbYIHUsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 16:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754081AbYIHUsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 16:48:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49351
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754038AbYIHUsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 16:48:13 -0400
Date: Mon, 08 Sep 2008 13:48:05 -0700 (PDT)
Message-Id: <20080908.134805.45081035.davem@davemloft.net>
To: travis@sgi.com
Cc: nickpiggin@yahoo.com.au, mingo@elte.hu, akpm@linux-foundation.org,
       steiner@sgi.com, jes@sgi.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] smp: reduce stack requirements for
 smp_call_function_mask
From: David Miller <davem@davemloft.net>
In-Reply-To: <48C5870F.6050509@sgi.com>
References: <200809082030.41987.nickpiggin@yahoo.com.au>
	<20080908.125153.263452187.davem@davemloft.net>
	<48C5870F.6050509@sgi.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Travis <travis@sgi.com>
Date: Mon, 08 Sep 2008 13:11:59 -0700

> I was wondering if we'd need to be able to default a cpumask_t pointer
> argument to be a const and then use a different method for those cases
> where it shouldn't be?  This would strengthen the compiler type checking
> of functions calls.

Yes, of course, the pointer should be const.
