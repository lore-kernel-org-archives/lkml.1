Return-Path: <linux-kernel-owner+w=401wt.eu-S1757250AbXJAVjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250AbXJAVjw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 17:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753880AbXJAVjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 17:39:36 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:62096 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316AbXJAVje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 17:39:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=hopHRNZTfLA9Uew3d0eCPJMF56czJwv7bsgOHgnkXm08X4MgXlrR1A9b6zT0GBATkjyA1WK+aPvv30xgVpnoj+rS+uqRZ4MCr9hqNWZCCwu64KLSC+sjZMTWu8QY3j9tR/yzVgoM15xEaIz5ZJx6MvW8Xb11HyfzmzNkv22sFFk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 4/4] hpt366: MWDMA filter for SATA cards (take 2)
Date: Mon, 1 Oct 2007 23:12:45 +0200
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200709300004.43335.sshtylyov@ru.mvista.com>
In-Reply-To: <200709300004.43335.sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710012312.45552.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 September 2007, Sergei Shtylyov wrote:
> The Marvell bridge chips used on HighPoint SATA cards do not seem to support
> the MWDMA modes (at least that caould be seen in their so-called drivers :-),
> so the driver needs to account for this -- to achieve this:
> 
> - add mdma_filter() method from the original patch by Bartlomiej Zolnierkewicz
>   with his consent, also adding the method callout to ide_rate_filter();
> 
> - install the method for all chips to only return empty mask if a SATA drive
>   is detected on HPT372{AN]/374 chips...
> 
> Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

applied
