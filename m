Return-Path: <linux-kernel-owner+w=401wt.eu-S1753966AbZEYUYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbZEYUYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 16:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbZEYUYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 16:24:41 -0400
Received: from Cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:59861 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751715AbZEYUYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 16:24:40 -0400
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.30-rc6: Reported regressions from 2.6.29
Date: Mon, 25 May 2009 22:24:35 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, kernel-testers@vger.kernel.org,
       linux-acpi@vger.kernel.org
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>
In-reply-To: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905252224.37012.elendil@planet.nl>
X-OriginalArrivalTime: 25 May 2009 20:24:37.0655 (UTC) FILETIME=[D33BA270:01C9DD76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> If you know of any other unresolved regressions from 2.6.29, please let
> me know either and I'll add them to the list.

It may be worth tracking a possible regression introduced with -rc6 as a 
result of http://bugzilla.kernel.org/show_bug.cgi?id=13259.

A new warning that was added in drivers/acpi/processor_throttling.c 
(commit 4973b22a: 'ACPI processor: reset the throttling state once it's 
invalid') may be triggering in cases where it shouldn't. It seems to 
trigger during boot and on 'cat /proc/acpi/processor/*/throttling'.
Otherwise it's probably relatively harmless.

See the comments starting at #23 for details.

Cheers,
FJP
