Return-Path: <linux-kernel-owner+w=401wt.eu-S1759832AbYCXLfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759832AbYCXLfb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 07:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758180AbYCXLfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 07:35:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:17391 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758248AbYCXLfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 07:35:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=f9KcmsouL75uTy/rUIAGItSGOKv2FmleKxbiCfpXoJXt68jD7Hn2cLpiaK9LLI3L520SvqmSkI4lz9S5MSWOmSxAPBrFjGh5Oy9woxCikC1qialAWI4gXhy7Sg0f6fV8dmgLoyX6+URDBJ5CjLJM7vI2zlLzRFFWlQVeRZJtTQE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: 7eggert@gmx.de
Subject: Re: [PATCH 1/8] ide: always auto-tune PIO in legacy VLB host drivers
Date: Mon, 24 Mar 2008 12:50:02 +0100
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <aajV7-54-9@gated-at.bofh.it> <E1JdcPD-0000lP-2t@be1.7eggert.dyndns.org>
In-Reply-To: <E1JdcPD-0000lP-2t@be1.7eggert.dyndns.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803241250.02775.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 March 2008, Bodo Eggert wrote:
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> 
> |Subject: [PATCH 1/8] ide: always auto-tune PIO in legacy VLB host drivers
> 
> AFAIR this isn't safe for bus speeds above 33 MHz, is it?

It should be safe as VLB host drivers assume that bus speed is 50 MHz
(so the longest timings are used) if bus speed is not given by user
(using "idebus=" or "ide_core.vlb_clock=")?

Thanks,
Bart
