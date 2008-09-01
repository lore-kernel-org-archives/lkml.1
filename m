Return-Path: <linux-kernel-owner+w=401wt.eu-S1754805AbYIAWBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805AbYIAWBv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 18:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbYIAWBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 18:01:42 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:44681 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbYIAWBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 18:01:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=u2EjyAo/NZ12Soqppr7m9PWIowTngTPC6hNkl+/l6XWkl//jc69C+7pEGMgRFLwHeX
         7hJqXxXkEztpOCzrYME3vwv1pjkFq1KfZ72Ljsj7PO1/emstuw2CY4PuNv3J1eU9y5yO
         cptSoDmusGEqZR+mYWox0zq0CqkoXVkr7JB/U=
Message-ID: <bc64b4640809011501j30dae45bqd8326169478c4060@mail.gmail.com>
Date: Tue, 2 Sep 2008 02:01:40 +0400
From: Dmitry <dbaryshkov@gmail.com>
To: "David Woodhouse" <dwmw2@infradead.org>
Subject: Re: warning during mtd registration in 2.6.27-rc5
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
       axboe@kernel.dk
In-Reply-To: <1220300264.2982.140.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080901142949.GA18081@doriath.ww600.siemens.net>
	 <1220300264.2982.140.camel@pmac.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/2 David Woodhouse <dwmw2@infradead.org>:
> On Mon, 2008-09-01 at 18:29 +0400, Dmitry Baryshkov wrote:
>> This happens when adding mtd partitions. I've traced it to the fact that
>> mtd partition devices share the genhd queue with the whole chip block device.
>> Thus blk_register_filter receives the same pointer for the chip and for each
>> registered partition.
>
> Yes, the fix for that is already on its way to Linus.

Thanks. Sorry for the noise.

>
> --
> David Woodhouse                            Open Source Technology Centre
> David.Woodhouse@intel.com                              Intel Corporation
>
>
>
>



-- 
With best wishes
Dmitry
