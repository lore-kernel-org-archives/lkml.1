Return-Path: <linux-kernel-owner+w=401wt.eu-S1753171AbYCLQi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbYCLQi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 12:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbYCLQiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 12:38:50 -0400
Received: from gv-out-0910.google.com ([216.239.58.187]:16581 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbYCLQit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 12:38:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=hClgQ9aSwIxv2u7X28/iDTsOrnLf8/cfzXpUtLKK0ecwfr3NoShltL/3ahnJdpNF4ZPh881tIVhGj4CalhlBc36nZdSFPpnz3THBos+oE3xphOHJf2YWP2rWIyjJRMDgymtIgGoLS3B7UgZ3JwdHV7HDRxZLAUqKzDyq3GFSLyc=
Message-ID: <e9c3a7c20803120938w1d10da4bk33a0376e90fe9e61@mail.gmail.com>
Date: Wed, 12 Mar 2008 09:38:45 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Zhang Wei" <Wei.Zhang@freescale.com>
Subject: Re: [PATCH 2/2] Add device_prep_dma_interrupt support to fsldma.c
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <ABF87B0B6A38C0458E319AC973ED68AECE527E@zch01exm26.fsl.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1205205917-21861-1-git-send-email-wei.zhang@freescale.com>
	 <1205205917-21861-2-git-send-email-wei.zhang@freescale.com>
	 <e9c3a7c20803111455g354741f0sff7d4fc0172dc65e@mail.gmail.com>
	 <ABF87B0B6A38C0458E319AC973ED68AECE527E@zch01exm26.fsl.freescale.net>
X-Google-Sender-Auth: b42a17da91386669
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2008 at 7:28 PM, Zhang Wei <Wei.Zhang@freescale.com> wrote:
[..]
>  But I have a question about device_prep_dma_interrupt(), which is no way to assign
>   dest and src address. Is it a null tx action dma_async_tx_descriptor except to trigger
>   an interrupt?
>

Yes, it is for sequences where we are scheduling a chain of operations
of indeterminate length and want a callback after they all complete.
See ops_run_biofill() in drivers/md/raid5.c for an example.

>  Thanks!
>  Wei.

--
Dan
