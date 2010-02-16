Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab0BPI0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 03:26:19 -0500
Received: from mail-px0-f191.google.com ([209.85.216.191]:35771 "EHLO
	mail-px0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab0BPI0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 03:26:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=ZkWVN0E2mItj/QTC1uhWGt0RHm1zh+eEEZAl7UA9lUp/EpAPquKCYvfAOv/pqnqgRi
         ptDAkzDDNRqYqPVgAJnljVl4wIZXThsbU6ikGr1IZJcuSCkMofxUDs6GZlrxNWhaROeK
         EuLlaW6lZ+iBro23plfls9rPTsBE+H7C6vn4Q=
Message-ID: <4B7A5893.9010809@gmail.com>
Date: Tue, 16 Feb 2010 17:34:27 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Bart Hartgers <bart.hartgers@gmail.com>
CC: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/1] Delay on vt6420 when starting ATAPI DMA write
References: <20100214120449.503204189@gmail.com> <20100214120819.947320201@gmail.com>
In-Reply-To: <20100214120819.947320201@gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2010 09:04 PM, Bart Hartgers wrote:
> When writing a disc on certain lite-on dvd-writers (also rebadged 
> as optiarc/LG/...) connected to a vt6420, the ATAPI CDB ends
> up in the datastream and on the disc, causing silent corruption. 
> Delaying between sending the CDB and starting DMA seems to 
> prevent this.
> 
> I do not know if there are burners that do not suffer from
> this, but the patch should be safe for those as well.
> 
> There are many reports of this issue, but AFAICT no solution was 
> found before. For example:
> http://lkml.indiana.edu/hypermail/linux/kernel/0802.3/0561.html
> 
> Signed-off-by: Bart Hartgers <bart.hartgers@gmail.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks!

-- 
tejun
