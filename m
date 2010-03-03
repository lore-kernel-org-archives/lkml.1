Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab0CCUwo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 15:52:44 -0500
Received: from mail-yx0-f204.google.com ([209.85.210.204]:51434 "EHLO
	mail-yx0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860Ab0CCUwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 15:52:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ikwvyP53LeM1eoDwdpacuF96dgAfix5JAmN1kKL+VWg39ocpk/lNHKZXuf2Zx+wquC
         JFBCjC9354UUvbc790zRSzC3XgF5rYdc+iu8t6zutY2nh6djkcrayXlHxNsVG/lnV5xC
         N8uRlCAfQzaugqFdsmxoZ+1BGmmzQoFEHz8ek=
Message-ID: <4B8ECC11.3020009@pobox.com>
Date: Wed, 03 Mar 2010 15:52:33 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Anton Vorontsov <avorontsov@ru.mvista.com>
CC: Sergei Shtylyov <sshtylyov@mvista.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/11] ahci: Introduce ahci_set_em_messages()
References: <20100303171713.GA6322@oksana.dev.rtsoft.ru> <20100303171745.GH12362@oksana.dev.rtsoft.ru>
In-Reply-To: <20100303171745.GH12362@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2010 12:17 PM, Anton Vorontsov wrote:
> Factor out some ahci_em_messages handling code from ahci_init_one().
> We would like to reuse it for non-PCI devices.
>
> Signed-off-by: Anton Vorontsov<avorontsov@ru.mvista.com>
> ---
>   drivers/ata/ahci.c |   41 ++++++++++++++++++++++++-----------------
>   1 files changed, 24 insertions(+), 17 deletions(-)

applied patches 1-8 (ie. up to and including this patch) to 
libata-dev.git#upstream.  Will drop all other patches, awaiting revision 
and resend.


