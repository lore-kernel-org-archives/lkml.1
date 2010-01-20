Return-Path: <linux-kernel-owner+w=401wt.eu-S1755761Ab0ATGtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761Ab0ATGtJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 01:49:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682Ab0ATGtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 01:49:07 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:32973 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab0ATGtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 01:49:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=ZK6+RUy7LyuA/DZsfxhlR9lFrpve3F23qzaiOJECLGAAOa/Wm+WkYWlJSm1IniU71C
         X1fbHDT9i2nqI4fZu/ScL2YjTGukS143+cP9HG9a9k4jlFe6TjGdgLnZuDoICLkTYO2y
         JgAwDGNwwqPkidAp2Y4tW7lxdE5emOdZ8FN20=
Message-ID: <4B56A8C9.2000807@gmail.com>
Date: Wed, 20 Jan 2010 15:55:05 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Bart Hartgers <bart.hartgers@gmail.com>
CC: linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
       linux-ide@vger.kernel.org, juergen.metzdorf@telelev-dsl.de,
       markpschool@hotmail.com, sporadic.crash@gmail.com, apopov@sirma.bg,
       david@coomber.co.za, jay4mail@gmail.com
Subject: Re: [patch 2/2] sata_via: Delay on vt6420 when starting ATAPI DMA
 	write
References: <20100116235653.898098245@gmail.com>	 <20100116235851.884756038@gmail.com> <4B5678E2.2050709@gmail.com> <7eb6a4d81001192244k19d28805p9cb4eaec7eed9366@mail.gmail.com>
In-Reply-To: <7eb6a4d81001192244k19d28805p9cb4eaec7eed9366@mail.gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 01/20/2010 03:44 PM, Bart Hartgers wrote:
> Yes, you're right. I'll drop the printk_once and send another patch
> for inclusion. However, for testing I found it very useful to make
> sure that I got the right module loaded. So I figured it could be
> helpful for the interpretation of success/failure reports.

Oh yeah, for testing, having it there is a good idea.

> Assuming that this patch works for other people as well, what is
> prefered: resending both patches or just to make a new #2/2 (the
> vt6420 one)?

I think just re-doing the second patch should be enough.

Thanks.

-- 
tejun
