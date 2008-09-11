Return-Path: <linux-kernel-owner+w=401wt.eu-S1754070AbYIKNCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbYIKNCi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 09:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbYIKNC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 09:02:29 -0400
Received: from ti-out-0910.google.com ([209.85.142.187]:25891 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbYIKNC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 09:02:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=GZz8UuzjAYOzGg01XA9wsmMpBee8mYBaxc6GchkxiWCNywV/sMSmaigPIEYv+xKGBl
         0s+DtIKd0xHIZCVVlw53KncufG5l/Ipjv9sgnB0QEZ9btV8g8BCzR8q16Yog1OxE8v5I
         1lJAhzCSEul5F/VmyBzk5pxSnLuPfjUIDs0nE=
Message-ID: <48C9168C.4090101@gmail.com>
Date: Thu, 11 Sep 2008 15:01:00 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Elias Oltmanns <eo@nebensachen.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] libata: Implement disk shock protection support
References: <87wshzplvk.fsf@denkblock.local>	<20080829211345.4355.89284.stgit@denkblock.local>	<48B913E6.1000104@gmail.com> <87k5dym5t9.fsf@denkblock.local>	<48BA638B.2030001@gmail.com> <87ej45mlp3.fsf@denkblock.local>	<48BA969C.4060207@gmail.com> <87abetmaap.fsf@denkblock.local>	<48BBA8D1.8020604@gmail.com> <87myirly1p.fsf@denkblock.local>	<48BC1BB8.2030007@gmail.com> <87fxoh0yil.fsf@denkblock.local>	<48BFA528.2040305@gmail.com> <87ej3zrf3o.fsf@denkblock.local>	<48C0F2F8.1040308@gmail.com> <87ej3snm3s.fsf@denkblock.local>	<48C7DC55.30002@gmail.com> <8763p3ol55.fsf@denkblock.local>	<48C82CB1.2070308@gmail.com> <871vzrogpz.fsf@denkblock.local>	<48C850AA.2030409@gmail.com> <87k5diq35g.fsf@denkblock.local> <48C91458.7090503@gmail.com>
In-Reply-To: <48C91458.7090503@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ah.. just one more thing.

I think it would be easier on the application if the written timeout
value is cropped if it's over the maximum instead of failing the
write.

Thanks.

-- 
tejun
