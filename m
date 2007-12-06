Return-Path: <linux-kernel-owner+w=401wt.eu-S1754570AbXLFUZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbXLFUZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 15:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560AbXLFUZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 15:25:15 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:37070 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbXLFUZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 15:25:14 -0500
Subject: Re: [PATCH 3/3] printer port driver: semaphore to mutex
From: Daniel Walker <dwalker@mvista.com>
To: Remy Bohmer <linux@bohmer.net>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <3efb10970712061201l343ad865mae920c3e6d43bfd9@mail.gmail.com>
References: <20071206021857.826386004@mvista.com>
	 <20071206021909.131993721@mvista.com> <20071206102334.GE17299@elte.hu>
	 <1196958847.1568.98.camel@jnielson-xp.ddns.mvista.com>
	 <3efb10970712061201l343ad865mae920c3e6d43bfd9@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 06 Dec 2007 12:12:25 -0800
Message-Id: <1196971945.1568.107.camel@jnielson-xp.ddns.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-12-06 at 21:01 +0100, Remy Bohmer wrote:
> Daniel,
> 
> FYI: I am working on the conversion of the 2 sem->mutex in kernel/printk.c

I looked at the console_sem , but i was going to leave that as last..

The problem with the console_sem is that it can get locked from
interrupt context, which is discouraged with mutex types.. I think it
will be complicated to convert..

Daniel

