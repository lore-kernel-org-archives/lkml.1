Return-Path: <linux-kernel-owner+w=401wt.eu-S1759279AbZA2QpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759279AbZA2QpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 11:45:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751782AbZA2QpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 11:45:03 -0500
Received: from charybdis-ext.suse.de ([195.135.221.2]:49273 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751754AbZA2QpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 11:45:01 -0500
Message-ID: <4981DD09.6080809@suse.de>
Date: Thu, 29 Jan 2009 19:44:57 +0300
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Ingo Molnar <mingo@elte.hu>, Frans Pop <elendil@planet.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken
 on Toshiba R500 (bisected)
References: <200812020320.31876.rjw@sisk.pl> <200901281300.40171.elendil@planet.nl> <20090129141111.GN24391@elte.hu> <200901291548.36575.rjw@sisk.pl>
In-Reply-To: <200901291548.36575.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Thursday 29 January 2009, Ingo Molnar wrote:
>> * Frans Pop <elendil@planet.nl> wrote:
>>> With current git head I get:
>>>    ACPI: Waking up from system sleep state S3
>>>    ACPI: EC: non-query interrupt received, switching to interrupt mode
>> i started getting those messages too - but earlier in the cycle, during 
>> one of the ACPI merges i think.
> 
> AFAICS, the last message only means that the ACPI EC code is now going to use
> interrupts instead of polling, which generally is good.
> 
> Alex, is that correct?
Yes. Interrupt mode is better.

Regards,
Alex.
