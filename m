Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbYBQQK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbYBQQK1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 11:10:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbYBQQKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 11:10:14 -0500
Received: from defiant.darkvoyage.org.uk ([81.187.177.18]:60568 "EHLO
	defiant.darkvoyage.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbYBQQKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 11:10:13 -0500
Message-ID: <47B85C61.7060507@lkml.darkvoyage.org.uk>
Date: Sun, 17 Feb 2008 16:10:09 +0000
From: Iain Paton <ilp@lkml.darkvoyage.org.uk>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de>,
       Jordan Crouse <jordan.crouse@amd.com>,
       Andres Salomon <dilinger@queued.net>, marc.jones@amd.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, wim@iguana.be
Subject: Re: Geode GX/LX watchdog timer (RESEND)
References: <20080117211917.GF8244@cosmic.amd.com> <478FCDB6.4010708@i4.informatik.rwth-aachen.de> <20080117223644.GK8244@cosmic.amd.com> <478FDC12.6020505@i4.informatik.rwth-aachen.de> <20080119010624.GA25328@cosmic.amd.com> <47934B2E.3020707@i4.informatik.rwth-aachen.de> <20080121170700.GC6884@cosmic.amd.com> <4794E664.6020209@i4.informatik.rwth-aachen.de> <47B8413A.80105@lkml.darkvoyage.org.uk> <47B848A9.3080308@i4.informatik.rwth-aachen.de> <20080217145450.GB1403@cs181133002.pp.htv.fi>
In-Reply-To: <20080217145450.GB1403@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Sun, Feb 17, 2008 at 03:46:01PM +0100, Arnd Hannemann wrote:
>> Never tried to built it as a module.
>> Probably there are issues with that. If I remember correctly I saw a patch in 2.6.25-rc which
>> mentioned that using mfgpt in modules won't work. Does this apply to 2.6.24 as well?
> 
> For using code from modules it must be explicitely EXPORT_SYMBOL{,GPL}'ed.
> 
> Adding
>   EXPORT_SYMBOL_GPL(geode_mfgpt_toggle_event);
> and
>   EXPORT_SYMBOL_GPL(geode_mfgpt_alloc_timer);
> below the respective functions in mfgpt_32.c should fix this issue.

I couldn't find the patch Arnd mentioned on lkml or in Linus git tree, 
but adding the lines suggested by Adrian gets me a working module.

Hopefully the patch will arrive in the mainline tree at some point.

Thanks to both of you for the help!

Iain


