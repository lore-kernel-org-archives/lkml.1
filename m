Return-Path: <linux-kernel-owner+w=401wt.eu-S1756726AbXLLOth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbXLLOth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 09:49:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756393AbXLLOt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 09:49:29 -0500
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:59013 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103AbXLLOt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 09:49:28 -0500
Message-ID: <475FF4A1.4020401@keyaccess.nl>
Date: Wed, 12 Dec 2007 15:48:01 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: linux@horizon.com
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFT] Port 0x80 I/O speed
References: <20071212112049.17891.qmail@science.horizon.com>
In-Reply-To: <20071212112049.17891.qmail@science.horizon.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-12-07 12:20, linux@horizon.com wrote:

> Here are a variety of machines:

Thanks much for all! Collecting all data now...

> With -O2, the cycle counts come out (before division) as
> out: 0xFFFFFFFFFFEA6F4F
> in:  0xFFFFFFFFFCE68BB6
> I think the "A" constraint doesn't work quite the same in
> 64-bit code.  The compiler seems to be using %rdx rather than
> %edx:%eax.

Yes indeed, that tripped me up. Have been using the "=A" locally for a while 
for similar timing tests. Will use a manual "=a" (lo), "=d" (hi) I guess for 
amd64 compatibility from now on.

If I'd care deeply I'd probably categorize this as a backwards compatibility 
bug in GCC though. Things were probably never guaranteed but they certainly 
worked that way...

Rene.
