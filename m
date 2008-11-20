Return-Path: <linux-kernel-owner+w=401wt.eu-S1755480AbYKTM2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbYKTM2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 07:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754715AbYKTM2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 07:28:06 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:40804 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669AbYKTM2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 07:28:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qUlfgEDvLiEvxpag35qudMnGCHh+jNHES6hr/sQo4qOLHSzVxwKnljJBqpqFQVFE2N
         jR/N5yk3CxGWu2sgxFjJW1kg3j8CWbQpd6V/RQJfH1PcEcXwLngxSqyvpMkbGW16+KBd
         dJAIOWSYLDZBiVn50duf4MgQwsme5e4EcUNbc=
Message-ID: <b647ffbd0811200428u2b41b108ifb02872563c871ab@mail.gmail.com>
Date: Thu, 20 Nov 2008 13:28:03 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: O_DIRECT patch for processors with VIPT cache for mainline kernel (specifically arm in our case)
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       linux-fsdevel@vger.kernel.org, "Naval Saini" <navalnovel@gmail.com>,
       linux-arch@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org, naval.saini@nxp.com,
       "Ralf Baechle" <ralf@linux-mips.org>
In-Reply-To: <200811201759.01039.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d8dd82df0811180606w503563ach8650ab07dcd0a35c@mail.gmail.com>
	 <200811191740.23638.nickpiggin@yahoo.com.au>
	 <20081119204315.GB17209@flint.arm.linux.org.uk>
	 <200811201759.01039.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/20 Nick Piggin <nickpiggin@yahoo.com.au>:
>
> [ ... ]
>
> - The page is sent to the block layer, which stores into the page. Some
>  block devices like 'brd' will potentially store via the kernel linear map
>  here, and they probably don't do enough cache flushing.

btw., if someone is curious, here is another case of what may happen
on VIPT systems when someone uses a "virtual" block device (like
'brd') as, heh, a swap :-)

http://www.linux-mips.org/archives/linux-mips/2008-11/msg00038.html


-- 
Best regards,
Dmitry Adamushko
