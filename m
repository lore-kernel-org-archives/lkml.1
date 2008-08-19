Return-Path: <linux-kernel-owner+w=401wt.eu-S1753070AbYHSVZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070AbYHSVZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 17:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbYHSVZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 17:25:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55092 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbYHSVZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 17:25:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Meyer <thomas@m3y3r.de>
Subject: Re: Fwd: 2.6.26.3: ACPI: Fix thermal shutdowns
Date: Tue, 19 Aug 2008 23:28:30 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
References: <1219180571.48ab381bd85e5@213.133.104.17>
In-Reply-To: <1219180571.48ab381bd85e5@213.133.104.17>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808192328.30858.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 19 of August 2008, Thomas Meyer wrote:
> 
> Hi.
> 
> This one should go in 2.6.26.3, too:
> 
> I didn't see it in Greg's list:

Why haven't you sent a CC to Greg, then? :-)

> ACPI: Fix thermal shutdowns
> 
> Do not use unsigned int if there is test for negative number...
> 
> See drivers/acpi/processor_perflib.c
>   static unsigned int ignore_ppc = -1;
> ...
>   if (event == CPUFREQ_START && ignore_ppc <= 0) {
>        ignore_ppc = 0;
> ...
> 
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9f497bcc695fb828da023d74ad3c966b1e58ad21
