Return-Path: <linux-kernel-owner+w=401wt.eu-S1761770AbXGTG0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761770AbXGTG0R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 02:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbXGTG0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 02:26:04 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:54368 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182AbXGTG0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 02:26:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=raDFkhA0jv3LX8ZpY0PkC+lbwQy8InecujrvPH7LIV4/vvcomaRnhdVs5xm/VbnTua67Vk2ROBWIMDpc5w5WZLTH+1VZsRyvxP7aGbtlSmXrxlTYjF0ZJU3GEpWoG4dq9qT2mhMwLKHPMNjiYlUoIyZEd5W9s8LlF9komC8CmJY=
Message-ID: <46A0552E.30606@gmail.com>
Date: Fri, 20 Jul 2007 15:24:46 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?R=FAben_Fonseca?= <krani1@0x82.com>
CC: Linux Kernel Mailling List <linux-kernel@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: libata [ata_piix] still no resume from S3 ?
References: <20070712162450.GA7132@0x82.com> <469744DB.5070600@gmail.com> <20070714210117.GA20723@0x82.com> <469DD216.5040305@gmail.com> <20070719092053.GA21254@0x82.com> <469F2E4A.1020502@gmail.com> <20070719150436.GA9006@0x82.com>
In-Reply-To: <20070719150436.GA9006@0x82.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rúben Fonseca wrote:
> I wish I could disable this card reader. It is built in on the hardware,
> and there are no drivers for Linux. There is no option on the BIOS to
> disable the device. Is there any way (kernel parameters, magic program,
> etc) to disable this device without opening my laptop to cut the wires?
> :D

OIC.  How about not loading tifm_7xx1 module?  Does that make any
difference?

-- 
tejun
