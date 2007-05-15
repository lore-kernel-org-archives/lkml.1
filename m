Return-Path: <linux-kernel-owner+w=401wt.eu-S1761051AbXEPAqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761051AbXEPAqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 20:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760568AbXEPAqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 20:46:33 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:36716 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760575AbXEPAqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 20:46:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=l4SHvE+936cad9sYfHLPxNwVYuPZ82htr6zAq6eUDT5KxewogK2Cn34QVM6lJAqmYogs/XM+j9wpBll9cN97RoE7+AQivqYuIXUpsSmV8ZZRDo9ComZrmiIjXChA/M/eeQVlyZawfVblYlJzi0qvjjK0nftukKdLP3WyogWTWOk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Subject: Re: [PATCH 2/5] Use mutex instead of semaphore in IDE driver
Date: Wed, 16 May 2007 00:04:48 +0200
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <20070514090256.GF29206@traven> <20070514091424.GH29206@traven>
In-Reply-To: <20070514091424.GH29206@traven>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200705160004.48294.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 May 2007, Matthias Kaehlcke wrote:
> The IDE driver uses a semaphore as mutex. Use the mutex API instead of
> the (binary) semaphore.
> 
> Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

applied

Since I already had a patch from you with identical patch summary/description
(but for ide_cfg_sem semaphore) in my tree, I almost overlooked this one. :)

Please choose more descriptive patch summary/description next time.

Thanks,
Bart
