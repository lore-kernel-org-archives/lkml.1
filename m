Return-Path: <linux-kernel-owner+w=401wt.eu-S1759693AbYCTX5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759693AbYCTX5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 19:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756487AbYCTX40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 19:56:26 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:63287 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214AbYCTX4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 19:56:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=L/urD2jmHdktTgBahI2XTKI/9coN70OTx2OiQ6RIOh4oUU78HIlA3kJ9NdV1zBhqU6DWQbZT5DrG2IcSLeq88rKR8/Qu0XVxjjbmXqAhCqfzinK4IQ0i5MOsqPRXM+YHXEPDXZDRGeFbJLQ9G09Wji7nzGN4OHJOcSq9EF2tIOc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 0/17] ide-tape: remove pipeline functionality-v3
Date: Fri, 21 Mar 2008 01:04:17 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1205736090-4435-1-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1205736090-4435-1-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803210104.17651.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Monday 17 March 2008, Borislav Petkov wrote:
> Hi Bart,
> 
> here's the rest of the pipeline removal series. What's left is to rewrite the
> whole allocation logic around tape->merge_stage and all the other small buffers
> so that we can get at least some sanity into the driver before working on it
> any further :).
> 
>  Documentation/ide/ide-tape.txt |  211 ++++---------
>  drivers/ide/ide-tape.c         |  689 ++--------------------------------------
>  2 files changed, 99 insertions(+), 801 deletions(-)

Thanks.

I applied everything except patches #3-4 (as they need to be delayed
after tape->merge_state and co. rewrite).

Bart
