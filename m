Return-Path: <linux-kernel-owner+w=401wt.eu-S1762628AbYLCUgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762628AbYLCUgl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:36:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759518AbYLCUSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 15:18:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40443 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759540AbYLCUSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 15:18:21 -0500
Message-ID: <4936E96B.6090706@zytor.com>
Date: Wed, 03 Dec 2008 12:17:47 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jody McIntyre <scjody@sun.com>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH] Fix compile error in arch/x86/kernel/syscall_64.c
References: <20081202215154.GL29919@clouds> <4936C927.3030504@zytor.com> <20081203195022.GA7080@clouds>
In-Reply-To: <20081203195022.GA7080@clouds>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jody McIntyre wrote:
> 
> I'm confused as to why this matters - I didn't think the kernel build
> used any external includes (except for helper utilities like "conf".)
> 

It *shouldn't* (except for UML), but it has been known to happen by
accident.

I was particularly suspicious because you said "one of my systems",
which implies other systems don't behave that way...

Now, the syscall_64.i you sent me is the working version, right?  Could
you send me the non-working version, too?

	-hpa

