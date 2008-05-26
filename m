Return-Path: <linux-kernel-owner+w=401wt.eu-S1754926AbYEZIFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926AbYEZIFl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 04:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463AbYEZIFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 04:05:25 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58008 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458AbYEZIFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 04:05:24 -0400
Date: Mon, 26 May 2008 10:06:14 +0200
From: Pavel Machek <pavel@suse.cz>
To: Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ACPI: add DMI info to enable OSI(Linux) on
	PRIMEQUEST
Message-ID: <20080526080614.GA28147@elf.ucw.cz>
References: <4816F9B9.3090609@jp.fujitsu.com> <4836660B.3080406@jp.fujitsu.com> <483667A4.9000606@jp.fujitsu.com> <20080525114308.GA5237@ucw.cz> <483A6D15.6030701@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483A6D15.6030701@jp.fujitsu.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-05-26 16:56:05, Taku Izumi wrote:
>
> Thank you for your response.
>
>>> This patch adds DMI info to enable OSI(Linux) on PRIMEQUEST.
>>> (PRIMEQUEST is ia64 machine.)
>>
>> Why is it needed? Why needs your bios know whether it is Linux or BSD
>> or whatver running?
>
>   For memory hotplug support.
>   Memory hotplug doesn't work on PRIMEQUEST when OSI(Linux) is disabled.

So fix the BIOS: there's no reason why memory hotplug should not work
on BSD or Windows...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
