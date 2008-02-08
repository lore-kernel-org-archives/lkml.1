Return-Path: <linux-kernel-owner+w=401wt.eu-S1756708AbYBHV2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbYBHV2Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 16:28:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbYBHV2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 16:28:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38550 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbYBHV2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 16:28:16 -0500
Message-ID: <47ACC942.1020308@zytor.com>
Date: Fri, 08 Feb 2008 13:27:30 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Re: [rft] s2ram wakeup moves to .c, could fix few
 machines
References: <20080208210004.GA12923@elf.ucw.cz> <Pine.LNX.4.44L0.0802081617280.5958-100000@iolanthe.rowland.org> <20080208212317.GD12923@elf.ucw.cz>
In-Reply-To: <20080208212317.GD12923@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> 
> See arch/x86/kernel/acpi/realmode/wakeup.S (the version that was sent
> to the list). No problem there, but table stored at nonzero
> offset. Short jump at the beggining of table would fix it (ugly).
> 

Ugly, but it's the standard way to deal.  We have it in the bzImage 
format, too.

	-hpa
