Return-Path: <linux-kernel-owner+w=401wt.eu-S1752046AbZIHSCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbZIHSCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 14:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbZIHSCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 14:02:16 -0400
Received: from h155.mvista.com ([63.81.120.155]:48012 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751878AbZIHSCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 14:02:16 -0400
Message-ID: <4AA69CA6.9050909@ru.mvista.com>
Date: Tue, 08 Sep 2009 22:04:22 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Frederik Deweerdt <frederik.deweerdt@xprog.eu>, linux-ide@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Limiting DMA speeds for individual IDE drives
References: <Pine.LNX.4.44L0.0909081157520.2653-100000@iolanthe.rowland.org> <20090908161204.GA3113@gambetta>
In-Reply-To: <20090908161204.GA3113@gambetta>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Frederik Deweerdt wrote:

>>Is there any simple way to force the old IDE driver to limit the DMA
>>speed for a particular device?

    No, you can only disable DMA totally, and then set the needed speed via 
hdparm.

>>I've got a situation where a drive claims to be capable of supporting
>>UDMA/100, but it's in a noisy environment and gets lots of errors at
>>that speed.  I'd like to limit it to UDMA/66 or even UDMA/33.

    Are you sure that it's all because of the noise and not a cable type 
misdetection?

>>The hdparm command should be able to do this but I can't run it until 
>>the system has booted, by which time a bunch of CRC and possibly other 
>>errors have already occurred.  Ideally it should be possible to limit 
>>the speed starting as early as device detection, but I can't find any 
>>way to do it.  Is there support for such a thing or will I have to hack 
>>it in?

> Does passing ide=nodma at bootime, and then having init set the DMA at
> the right speed, would work?

    ide=nodma is now obsolete -- use ide_core.nodma=<interface>,<device> 
instead. Read Documentation/ide/ide.txt before advising. ;-)

> Regards,
> Frederik

WBR, Sergei
