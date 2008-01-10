Return-Path: <linux-kernel-owner+w=401wt.eu-S1757096AbYAJSV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096AbYAJSV7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 13:21:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754671AbYAJSVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 13:21:51 -0500
Received: from rn-out-0910.google.com ([64.233.170.190]:62037 "EHLO
	rn-out-0102.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754225AbYAJSVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 13:21:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=WGpvW/pYUuz/ITraKcBF53vhSTBKa3LTLbpKV1GunZ5HojVDBfavhEyQDZnTBhndsbF2APgFkr43Lr4qEOhgQfcF1onIs0Ea00ZhzKwjQIPnDWlKYZMzy9vtSDTocyRlAwr3E1jOb5IH4F2kYddGx2D3xCaxOA/+wuBnLjDLeFY=
Message-ID: <e9c3a7c20801101021n7aa37bdrd6255245a773546e@mail.gmail.com>
Date: Thu, 10 Jan 2008 11:21:47 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Zhang Wei" <Wei.Zhang@freescale.com>
Subject: Re: [PATCH v2] Add DMA engine driver for Freescale MPC85xx processors.
Cc: linux-kernel@vger.kernel.org, "Zhu Ebony" <ebony.zhu@freescale.com>,
       galak@kernel.crashing.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 06e6a737ec9e22d4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 10, 2008 3:10 AM, Zhang Wei <Wei.Zhang@freescale.com> wrote:
> I think your patch is good. What should I do next?
>
> Cheers!
> Wei.
>

I do not think all the review comments have been addressed, for
example my earlier comments about GFP_ATOMIC and spin_lock_irqsave
[1].  We have two options to take this forward:

1/ Continue to carry this in the async-tx tree and get an
Acked-by/Reviewed-by tag from Kumar.
2/ Move this to Kumar's tree, and coordinate our pull requests to have
the async-tx updates hit first.

I prefer option 1, but I will defer to Kumar.

Thanks,
Dan

[1] http://marc.info/?l=linux-kernel&m=118936050531240&w=2
