Return-Path: <linux-kernel-owner+w=401wt.eu-S1762831AbXGFJOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762831AbXGFJOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 05:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755829AbXGFJOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 05:14:07 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:52770 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756414AbXGFJOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 05:14:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=eS2GUM1ld8nmfPkVMyORxYwcsx20YKvhZMXkD0nIlNwhG5ywI4/46MRdNL8lK6wBwf2goUKkj0boMBLRE+5PhhPlEO5wtze2Jp1Syz8SnucWZQ9VqgkUfygpiL14RsRHdcaVvTlQIKNBJ7Q3DAIPstQXs4FHxDk0M+Vc2QKM24o=
From: Suren Karapetyan <surenkarapetyan@gmail.com>
To: Christoph Pleger <Christoph.Pleger@cs.uni-dortmund.de>
Subject: Re: PATA-disk named sda
Date: Fri, 6 Jul 2007 14:13:42 +0500
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <20070706102132.14fbc600.Christoph.Pleger@cs.uni-dortmund.de>
In-Reply-To: <20070706102132.14fbc600.Christoph.Pleger@cs.uni-dortmund.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707061413.53182.surenkarapetyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 July 2007 13:21:32 Christoph Pleger wrote:
> Hello,
>
> In the newest Ubuntu Release, my PATA-disk is called sda instead of hda.
> Is that a general feature in newer kernel versions or is it a special
> feature in Ubuntu?
>
> Regards
>   Christoph
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

In recent kernels both PATA and SATA (SCSI too) drives are handled by libata 
library. It calls all the drives sd* . 
More info: http://linux-ata.org/
