Return-Path: <linux-kernel-owner+w=401wt.eu-S1757782AbYDMXw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782AbYDMXw6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 19:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbYDMXwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 19:52:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44839 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbYDMXwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 19:52:50 -0400
Message-ID: <48029B04.9010108@zytor.com>
Date: Sun, 13 Apr 2008 16:45:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: x86 git tree broken (bisected)
References: <200804102159.14563.rjw@sisk.pl> <200804140010.01034.rjw@sisk.pl> <86802c440804131532g4626233br82a425d6a96a6e11@mail.gmail.com> <200804140141.45830.rjw@sisk.pl>
In-Reply-To: <200804140141.45830.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> 
> Well, unfortunately current x86.git doesn't even boot on the affected box.
> It 'cannot open root device "md1" or unknown-block (0,0)' (Ingo, any ideas?).
> 
> Today I have to take some sleep, so I'll try to debug it tomorrow, unless
> someone else does it earlier.
> 

Sounds like you didn't compile in the appropriate RAID support...

	-hpa

