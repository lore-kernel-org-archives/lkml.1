Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036Ab0CKSh3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:37:29 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:54629 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757997Ab0CKShG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:37:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=vM5AN70sSLWG53y0QRuuAzt8uXtZiTIoz5vcUVMiud7V/HtxZWqPpdY5KZho4Val6z
         w/SSGLoXl+DSHpJoMt8a9Sdi+0cuARRtU5KHIRFqGaFhFL3gOPwO5uOQm0UvI3COEJUW
         lVCoYEPNuGwk0WpWC20IqsvYpsNWzzS6LrQdk=
Message-ID: <4B993847.3030100@pobox.com>
Date: Thu, 11 Mar 2010 13:36:55 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: Grant Likely <grant.likely@secretlab.ca>, monstr@monstr.eu, gregkh@suse.de,
       benh@kernel.crashing.org, akpm@linux-foundation.org,
       davem@davemloft.net, sfr@canb.auug.org.au, ben-linux@fluff.org,
       dwmw2@infradead.org, jeremy.kerr@canonical.com, James.Bottomley@suse.de,
       broonie@opensource.wolfsonmicro.com, microblaze-uclinux@itee.uq.edu.au,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       sparclinux@vger.kernel.org, linux-ide@vger.kernel.org,
       netdev@vger.kernel.org, linux-i2c@vger.kernel.org,
       devicetree-discuss@lists.ozlabs.org, linux-scsi@vger.kernel.org,
       alsa-devel@alsa-project.org
Subject: Re: [PATCH 21/37] drivers/ata: use .dev.of_node instead of .node
 in struct of_device
References: <20100311174830.4824.19820.stgit@angua> <20100311180543.4824.70491.stgit@angua> <4B9936F2.3020105@ru.mvista.com>
In-Reply-To: <4B9936F2.3020105@ru.mvista.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2010 01:31 PM, Sergei Shtylyov wrote:
> Hello.
>
> Grant Likely wrote:
>
>> .node is being removed
>>
>> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>> ---
>>
>> drivers/ata/pata_macio.c | 2 +-
>> drivers/ata/pata_of_platform.c | 2 +-
>> drivers/ide/pmac.c | 10 +++++-----
>> 3 files changed, 7 insertions(+), 7 deletions(-)
>
> Should probably have been 2 patches instead of one, as drivers/ata/ and
> drivers/ide/ are different subsystems...

Possibly, but these patches should go in via the OF tree anyway, so 
collecting ACKs should be sufficient.

	Jeff



