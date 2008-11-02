Return-Path: <linux-kernel-owner+w=401wt.eu-S1754950AbYKBUgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950AbYKBUgY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 15:36:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754313AbYKBUgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 15:36:12 -0500
Received: from rn-out-0910.google.com ([64.233.170.190]:9624 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173AbYKBUgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 15:36:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QHL9Hj624SyrK8IzJUQ9P56X+YDMrd0uauFsWla8vqJNmHbCJBZGLeQI1lrwE6OsRa
         FBneoS8we0Uwh8nNnTlv0MIurKa1AwS2i0ZswnNDUqrMcP4w3XJ9LbKsWawqVGYdC1v+
         di72J2zbNpD4Q7J6DV+BoiBoH/PkP/nzXRpo8=
Message-ID: <bc64b4640811021236t3458bf69vd1becc4ab1133be1@mail.gmail.com>
Date: Sun, 2 Nov 2008 23:36:08 +0300
From: Dmitry <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power_supply: only register tosa_battery driver on tosa
Cc: cbou@mail.ru, "Andrew Morton" <akpm@linux-foundation.org>,
       "Dmitry Baryshkov" <dbaryshkov@gmail.com>
In-Reply-To: <1225271050-21171-1-git-send-email-dbaryshkov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1225271050-21171-1-git-send-email-dbaryshkov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/29 Dmitry Baryshkov <dbaryshkov@gmail.com>:
> There are already several wm97xx-battery drivers. Do register the tosa one
> only on tosa machines.
>
> Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
> ---
>  drivers/power/tosa_battery.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)

What about this patch? IMO it can and should be merged during 2.6.28-rc cycle.

-- 
With best wishes
Dmitry
