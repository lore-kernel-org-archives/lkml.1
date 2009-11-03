Return-Path: <linux-kernel-owner+w=401wt.eu-S1754166AbZKCRZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbZKCRZB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 12:25:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbZKCRZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 12:25:00 -0500
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:61601 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751864AbZKCRZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 12:25:00 -0500
From: Frans Pop <elendil@planet.nl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.32-rc5: unexpected thermal shutdown?
Date: Tue, 3 Nov 2009 18:25:03 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <20091103105717.GA2516@elf.ucw.cz>
In-reply-To: <20091103105717.GA2516@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911031825.04169.elendil@planet.nl>
X-OriginalArrivalTime: 03 Nov 2009 17:25:04.0599 (UTC) FILETIME=[94E93E70:01CA5CAA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> I found this in the syslog afterwards.
> 
> Nov  3 09:59:14 amd kernel: Critical temperature reached (128 C),
> shutting down.
> Nov  3 09:59:14 amd shutdown[17819]: shutting down for system halt 
> Nov  3 09:59:15 amd init: Switching to runlevel: 0

Looks like what happened to me earlier this year. See
http://bugzilla.kernel.org/show_bug.cgi?id=13918.
 
> Now, machine was lying on the bed at that point, so...

So probably both the fan intake and hot air outlet were blocked, 
effectively preventing cooling.

What hardware is this?
What's the output of 'grep . /proc/acpi/thermal_zone/TZ*/*'?
Any thermal zones in there that don't have a "passive" trip point?

Cheers,
FJP
