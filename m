Return-Path: <linux-kernel-owner+w=401wt.eu-S1752495AbXHZKKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbXHZKKP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 06:10:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbXHZKJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 06:09:59 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:29134 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbXHZKJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 06:09:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=EirCcVTda3ISFm2zZIMUOAjVGEyFP1zCFfqSIGllZQOjA4N58riyAs1SHca+Sepbs/FaOV9Vxhs/hP9uPWbHpkPIGGBhXqAdm7x/swpT0g/P8D8fkq4REV6gLF68i85OF0u1yge1/Jea8qSrKgqsggDXhmtm4VyEPLGb1TT5JQ0=
Message-ID: <46CF92E2.8080207@gmail.com>
Date: Sat, 25 Aug 2007 11:24:34 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andreas John <lists@aj.net-lab.net>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Conke Hu <conke.hu@gmail.com>
Subject: Re: [PATCH] ahci.c: fix ati sb600 sata IRQ_TF_ERR
References: <5767b9100703140222k79dbed9dq6419b4f35d276242@mail.gmail.com>	 <45F7E7E9.6010703@gmail.com>	 <5767b9100703150500t1c34dfb0kc6a199b5374a8d78@mail.gmail.com>	 <45F93888.1080207@gmail.com> <5767b9100703270253j2ac3b543y499323b42c6402b@mail.gmail.com> <46CCA483.4080105@aj.net-lab.net> <46CCB23E.1000506@aj.net-lab.net> <46CD692D.3070508@aj.net-lab.net>
In-Reply-To: <46CD692D.3070508@aj.net-lab.net>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas John wrote:
> 00:00.0 Host bridge [0600]: ATI Technologies Inc Unknown device [1002:7910]

Okidoki, another ATI host bridge which can't forward MSI write upto the
cpu.  I'll blacklist it.  Thanks.

-- 
tejun

