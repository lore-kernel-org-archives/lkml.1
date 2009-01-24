Return-Path: <linux-kernel-owner+w=401wt.eu-S1757506AbZAXUkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506AbZAXUkc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 15:40:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755567AbZAXUkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 15:40:23 -0500
Received: from usul.saidi.cx ([204.11.33.34]:46158 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755563AbZAXUkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 15:40:22 -0500
Message-ID: <497B7CA3.3080802@overt.org>
Date: Sat, 24 Jan 2009 12:40:03 -0800
From: Philip Langdale <philipl@overt.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>
CC: rjw@sisk.pl, linux kernel <linux-kernel@vger.kernel.org>,
       sdhci-devel@list.drzeus.cx
Subject: Re: [PATCH] ricoh_mmc: Use suspend_late/resume_early
References: <39393.98.210.152.237.1232305880.squirrel@overt.org> <20090124185723.7dc9a875@mjolnir.drzeus.cx>
In-Reply-To: <20090124185723.7dc9a875@mjolnir.drzeus.cx>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> On Sun, 18 Jan 2009 14:11:20 -0500 (EST)
> philipl@overt.org wrote:
> 
>> If ricoh_mmc suspends before sdhci_pci, it will pull the card
>> out from under the controller, which could leave the system in
>> a very confused state.
>>
>> Using suspend_late/resume_early ensures that sdhci_pci suspends first
>> and resumes second.
>>
>> Signed-off-by: Philip Langdale <philipl@overt.org>
>> ---
> 
> What's the plan here? Apply for .29?

That's what I'd recommend - we are seeing reports of problems that
would be fixed by this.

eg: http://lkml.org/lkml/2009/1/21/241

--phil
