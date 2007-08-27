Return-Path: <linux-kernel-owner+w=401wt.eu-S1755540AbXH0BcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbXH0BcU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 21:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbXH0BcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 21:32:09 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:37073 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515AbXH0BcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 21:32:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=k3V3fMwkTlkvAdewIbSPhSxHw2Tud6kWtY+Z1vue7ga61s8Uq3qy48Bjk0NLz11z3UjiwSgt5qc+pTLy2JOLrGlIRpJNGai3Gcmqa4Q0Fwl0QfDqtTAlYMN0ZMDSvIlNM3YQcNTMn9kNzz4WmjUTrM4Bwo0CnE1V+XNaQOBWNrU=
Message-ID: <46D2298E.7010105@gmail.com>
Date: Mon, 27 Aug 2007 10:31:58 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Andreas John <lists@aj.net-lab.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Conke Hu <conke.hu@gmail.com>
Subject: Re: [PATCH] ahci.c: fix ati sb600 sata IRQ_TF_ERR
References: <5767b9100703140222k79dbed9dq6419b4f35d276242@mail.gmail.com>	 <45F7E7E9.6010703@gmail.com>	 <5767b9100703150500t1c34dfb0kc6a199b5374a8d78@mail.gmail.com>	 <45F93888.1080207@gmail.com> <5767b9100703270253j2ac3b543y499323b42c6402b@mail.gmail.com> <46CCA483.4080105@aj.net-lab.net> <46CCB23E.1000506@aj.net-lab.net> <46CD692D.3070508@aj.net-lab.net> <46CF92E2.8080207@gmail.com>
In-Reply-To: <46CF92E2.8080207@gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Andreas John wrote:
>> 00:00.0 Host bridge [0600]: ATI Technologies Inc Unknown device [1002:7910]
> 
> Okidoki, another ATI host bridge which can't forward MSI write upto the
> cpu.  I'll blacklist it.  Thanks.

Scrap that.  I got confused.  You weren't using MSI.

In the log, you have a detection failure on ata2.00.  What's attached to
the port?

Regarding timeout on /dev/sda: Most disks have a dip switch which forces
the drive to limit itself to 1.5Gbps if you put the dip switch on, is it
any better?

-- 
tejun
