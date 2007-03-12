Return-Path: <linux-kernel-owner+w=401wt.eu-S965672AbXCLLhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965672AbXCLLhK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 07:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965663AbXCLLhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 07:37:09 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:9217 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965692AbXCLLhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 07:37:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=GlfH4hglS3FnPXEPNw/dEsaSpYOLQ/mZprq+wrfpHJLxpt1cFkMzp/pxiLCTg3RgAQZYvLETLtz/3xnRyPaJB1njHOHRQZBcWfgwl2ny2c81WV/2h+fia0fTLLRmE4PkocS1bs1aLlmIdILnlTeut3+rzAcYLvZolgaQ3dUW8m4=
Message-ID: <45F53B60.8020908@gmail.com>
Date: Mon, 12 Mar 2007 20:37:04 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: =?UTF-8?B?TWF0aGlldSBCw6lyYXJk?= <Mathieu.Berard@crans.org>
CC: Jeff Garzik <jeff@garzik.org>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org,
       Michal Jaegermann <michal@ellpspace.math.ualberta.ca>,
       Fabio Comolli <fabio.comolli@gmail.com>,
       Janosch Machowinski <jmachowinski@gmx.de>,
       Lukas Hejtmanek <xhejtman@fi.muni.cz>, Meelis Roos <mroos@linux.ee>,
       Olivier Mondoloni <darkcore71@yahoo.fr>,
       Thomas Renninger <trenn@suse.de>, Robert Moore <robert.moore@intel.com>,
       lenb@kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [3/6] 2.6.21-rc2: known regressions
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015036.GH3441@stusta.de> <45EE9E39.3010800@garzik.org> <45F20541.9090208@crans.org>
In-Reply-To: <45F20541.9090208@crans.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Bérard wrote:
> Jeff Garzik a écrit :
>> Adrian Bunk wrote:
>>> Subject    : NCQ problem with ahci and Hitachi drive
>>> References : http://lkml.org/lkml/2007/3/4/178
>>> Submitter  : Mathieu Bérard <Mathieu.Berard@crans.org>
>>> Status     : unknown
>> according to the last message in that thread, it sounds like ACPI and
>> interrupt problems
>>
> Hi,
> after more testing with a 2.6.21-rc3, it appears that after several ata
> errors the boot process
> somehow continued as normal, after a "NCQ disabled due to excessive
> errors" message.
> "pci=noacpi" or "noacpi" parameters workarounds the problem "irqpoll"
> does nothing.

I was mistaken.  It can't be IRQ routing problem.  I somehow thought the
port was a ata_piix one.  Considering the reported broken NCQ feature on
the device GTF might be mangling with the drive to disable NCQ or
something.  Does giving "libata.noacpi=1" make any difference?

Thanks.

-- 
tejun
