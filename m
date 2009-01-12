Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbZALJdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbZALJdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 04:33:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031AbZALJdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 04:33:22 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:29165 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbZALJdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 04:33:21 -0500
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <496B0E5F.1020902@tremplin-utc.net>
Date: Mon, 12 Jan 2009 10:33:19 +0100
From: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.19) Gecko/20081231 Mandriva/2.0.0.19-1mdv2009.1 (2009.1) Thunderbird/2.0.0.19 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: hp accelerometer: fix LED handling and add freefall detection
References: <20090112092839.GA2190@elf.ucw.cz>
In-Reply-To: <20090112092839.GA2190@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> lis3 chip can provide interrupt when it detects freefall; it is done
> by hardware and is rather reliable. This adds (experimental) support
> for it. 
> 
> LED on HP notebooks is connected through ACPI. That unfortunately
> means that it needs to be delayed by using schedule_work() to avoid
> calling ACPI interpretter in invalid context. This patch fixes that.
> 
Hi Pavel,
Thanks a lot for doing it! I'll test it this week. However, I think
eventually the LED fix and the freefall infrastructure should be two
different patches. Also, while adding the freefall support, you should
add the info in the doc, as well as the little C program demonstrating
its use.

See you,
Eric
