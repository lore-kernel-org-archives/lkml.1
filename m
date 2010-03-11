Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465Ab0CKS0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:26:23 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:50612 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934309Ab0CKS0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:26:10 -0500
MIME-Version: 1.0
In-Reply-To: <20100311.102347.169562565.davem@davemloft.net>
References: <20100311174830.4824.19820.stgit@angua> <20100311.102043.40590962.davem@davemloft.net> 
	<20100311.102347.169562565.davem@davemloft.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 11 Mar 2010 11:25:46 -0700
X-Google-Sender-Auth: 80c7dbda8ee0f90e
Message-ID: <fa686aa41003111025n7f059995v9263f13fac1bd1ee@mail.gmail.com>
Subject: Re: [PATCH 00/37] OF: move device node pointer into struct device.
To: David Miller <davem@davemloft.net>
Cc: monstr@monstr.eu, gregkh@suse.de, benh@kernel.crashing.org,
       akpm@linux-foundation.org, sfr@canb.auug.org.au, jgarzik@pobox.com,
       ben-linux@fluff.org, dwmw2@infradead.org, jeremy.kerr@canonical.com,
       James.Bottomley@suse.de, broonie@opensource.wolfsonmicro.com,
       microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org,
       linux-ide@vger.kernel.org, netdev@vger.kernel.org,
       linux-i2c@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
       linux-scsi@vger.kernel.org, alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 11:23 AM, David Miller <davem@davemloft.net> wrote:
> From: David Miller <davem@davemloft.net>
> Date: Thu, 11 Mar 2010 10:20:43 -0800 (PST)
>
>> Three or four of the patches don't apply because only your tree
>> has those "/* temporary */" comments, f.e. in arch/sparc/kernel/pci.c
>>
>> I took care of this when applying to my tree.
>
> It also doesn't build, what the heck is this against
> Grant?
>
> drivers/of/device.c: In function 'of_match_device':
> drivers/of/device.c:24: error: 'const struct device' has no member named 'of_node'
> drivers/of/device.c:26: error: 'const struct device' has no member named 'of_node'
>
> Please make a patch set against Linus's vanilla tree so
> I and others can test this.

Oops, sorry David, I accidentally dropped the top patch.  Give me a
moment and I'll send it out.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
