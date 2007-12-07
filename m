Return-Path: <linux-kernel-owner+w=401wt.eu-S1757874AbXLGWf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874AbXLGWf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 17:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755334AbXLGWfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 17:35:12 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:42138 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282AbXLGWfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 17:35:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ppMCYzlbis+auriiZxWK/Jy5A8JPzsLQKdR8/GoAu+2ywyDTmR7FVdU7Ut/QUit16fjRY9VwiaoVL8WrvK3wZ/SqDD46HMFgCiISvozFIBSx0y2OWZKwBjQuuyEiQmZr7vfZ4Lt8Hhiu7Y6HMGLU14/W0+LOYRrZIWC5QIjv2ig=
Message-ID: <4759CA95.4070905@gmail.com>
Date: Sat, 08 Dec 2007 07:35:01 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] SCSI: make pcmcia directory use obj-y|m instead of subdir-y|m
References: <47594C57.4070006@gmail.com> <20071207160603.GB31641@uranus.ravnborg.org>
In-Reply-To: <20071207160603.GB31641@uranus.ravnborg.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Fri, Dec 07, 2007 at 10:36:23PM +0900, Tejun Heo wrote:
>> subdir-y|m isn't supposed to contain modules or built-in components.
>> Change subdir-$(CONFIG_PCMCIA) to obj-$(CONFIG_PCMCIA).
>>
>> Signed-off-by: Tejun Heo <htejun@gmail.com>
>> Cc: Sam Ravnborg <sam@ravnborg.org>
>> Cc: James Bottomley <James.Bottomley@SteelEye.com>
> Ack-by: Sam Ravnborg <sam@ravnborg.org>

Thanks.  I guess this should go through SCSI tree.  James, can you
please forward this upstream?

-- 
tejun
