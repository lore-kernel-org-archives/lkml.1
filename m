Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab0CDSE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 13:04:27 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62002 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab0CDSEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 13:04:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=KnRqh95dOHszwLdS5X+OB2OViL3ocVi6ZgDBVGI0GB/VWC4wC8S9UIjnt3EM21poik
         5XMfryQP3bRW6oA5DhglfT9mljxX4+XsGYr4vQqzN74X75HNVKR1K8/q5lbN+TxzjvA8
         m0dlxfcsVz5F0mew53Ff9R6CDixPAbaf7bClU=
Message-ID: <4B8FF626.6060704@pobox.com>
Date: Thu, 04 Mar 2010 13:04:22 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Anton Vorontsov <avorontsov@ru.mvista.com>
CC: Sergei Shtylyov <sshtylyov@mvista.com>, Mark Lord <kernel@teksavvy.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ahci: Add platform driver
References: <20100304170525.GA8126@oksana.dev.rtsoft.ru> <20100304170606.GB29022@oksana.dev.rtsoft.ru>
In-Reply-To: <20100304170606.GB29022@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2010 12:06 PM, Anton Vorontsov wrote:
> This can be used for AHCI-compatible interfaces implemented inside
> System-On-Chip solutions, or AHCI devices connected via localbus.
>
> Signed-off-by: Anton Vorontsov<avorontsov@ru.mvista.com>
> ---
>   drivers/ata/Kconfig           |    8 ++
>   drivers/ata/Makefile          |    1 +
>   drivers/ata/ahci_platform.c   |  191 +++++++++++++++++++++++++++++++++++++++++
>   include/linux/ahci_platform.h |   29 ++++++
>   4 files changed, 229 insertions(+), 0 deletions(-)
>   create mode 100644 drivers/ata/ahci_platform.c
>   create mode 100644 include/linux/ahci_platform.h

applied 1-2 to #upstream

Thanks for this work, this will give me the kick-in-the-pants necessary 
to move forward on mv-ahci and acard-ahci.

	Jeff



