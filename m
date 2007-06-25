Return-Path: <linux-kernel-owner+w=401wt.eu-S1755834AbXFYM5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834AbXFYM5f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 08:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754590AbXFYM5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 08:57:14 -0400
Received: from cmx2.usace.army.mil ([140.194.245.34]:16918 "EHLO
	cmx2.usace.army.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044AbXFYM5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 08:57:10 -0400
X-Greylist: delayed 847 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Jun 2007 08:57:10 EDT
Message-ID: <467FB844.6060702@bellsouth.net>
Date: Mon, 25 Jun 2007 07:42:44 -0500
From: Jay Cliburn <jacliburn@bellsouth.net>
Reply-To: jacliburn@bellsouth.net
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: "Jay L. T. Cornwall" <jay@esuna.co.uk>
CC: linux-kernel@vger.kernel.org, kronos.it@gmail.com,
       Chris Snook <csnook@redhat.com>
Subject: Re: Attansic L1 page corruption
References: <467B12CA.5060405@esuna.co.uk>	<467BE118.4090308@redhat.com>	<467BE4F1.7040308@esuna.co.uk>	<467D0EB0.9030100@esuna.co.uk>	<20070624125957.2e27820c@osprey.hogchain.net>	<467ED4A8.4080500@esuna.co.uk> <20070624164519.04f215b8@osprey.hogchain.net> <467FB237.2030703@esuna.co.uk>
In-Reply-To: <467FB237.2030703@esuna.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jun 2007 12:43:01.0501 (UTC) FILETIME=[5DE0EAD0:01C7B726]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jay L. T. Cornwall wrote:
> Jay Cliburn wrote:
> 
>> For reasons not yet clear to me, it appears the L1 driver has a bug or
>> the device itself has trouble with DMA in high memory.  This patch,
>> drafted by Luca Tettamanti, is being explored as a workaround.  I'd be
>> interested to know if it fixes your problem.
> 
> Yes, it certainly seems to. Now running with this patch and 4GB active,
> I've transferred about 15GB with no problem so far. It usually oopses
> after a GB or two.
> 
> I guess it's not an ideal solution, architecturally speaking, but it's a
> good deal better than an unstable driver. If there's any other patches
> you'd like me to test or traces to capture, I'm happy to help out.
> Otherwise I'll run with this one for now since it does the job!

Okay Jay, thanks.

Luca, would you please submit your patch to Jeff Garzik and netdev?

Jay

