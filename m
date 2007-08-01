Return-Path: <linux-kernel-owner+w=401wt.eu-S1762017AbXHALEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762017AbXHALEf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 07:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756932AbXHALEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 07:04:25 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:36631 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756642AbXHALEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 07:04:24 -0400
Message-ID: <46B06815.10200@gmail.com>
Date: Wed, 01 Aug 2007 13:01:41 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       CK Mailinglist <ck@vds.kolivas.org>, teresa@kvitka.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux Kernel cfs scheduler and xorg kbd
References: <1185827130.26459.16.camel@xtower.fri>	<6bffcb0e0707301549t6be3cd97y27726f5421bb7680@mail.gmail.com>	<20070801064816.GC10134@elte.hu> <p73abtbpk2s.fsf@bingen.suse.de>
In-Reply-To: <p73abtbpk2s.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2007 01:31 PM, Andi Kleen wrote:

> Ingo Molnar <mingo@elte.hu> writes:

>> another reaction below in this thread reported kbd problems in vanilla 
>> 2.6.22.1 as well. What is the X versions, etc.? Does the problem go away 
>> if the X kbd driver selection is tweaked to a simpler model, say:
> 
> Or perhaps just test with CFS reverted? It really sounds more like something
> independent from the scheduler. Perhaps someone could put a CFS-revert-for-testing patch
> on ftp somewhere. It's only a few git changesets so shouldn't be too difficult to
> do.

Teresa was already using 2.6.22.1, with CFS (v19.1) patched in, so reverting 
that would be a matter of patching it out again. She said she wasn't seeing 
trouble on other kernels though.

I was the one who also saw keyboard trouble on 2.6.22.1 without CFS by the 
way -- and haven't (yet) seen any anymore since patching _in_ CFS v19.1...

Rene.

