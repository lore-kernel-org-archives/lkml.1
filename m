Return-Path: <linux-kernel-owner+w=401wt.eu-S1755808AbYDGU4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808AbYDGU4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 16:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbYDGU4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 16:56:17 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:48592 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbYDGU4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 16:56:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=aOtWzGxDDXk04mpwvsftYsN0UEsgs7NQ6OgFg0vPeNHLCURob0a2cxMefv5SRNtI8f5Pyw3CGVG88Z7GC0PKGAsxHrQu/cV2sLM1DVUqsRErDiDfZMBw6X0VHyOUbIYAhMgrHLGQh+83pTxeNfjNbUaY/FWfSPk6M5cgnW533EI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 0/6] ide-tape: refit tape data buffer bits/kill pipelining-v2
Date: Mon, 7 Apr 2008 23:11:12 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1207543504-27888-1-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1207543504-27888-1-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804072311.12947.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Monday 07 April 2008, Borislav Petkov wrote:
> Hi Bart,
> 
> here's another patchset that contains some other fixes along with the changes
> you suggested. We have now a tape->merge_bh buffer which is a singly linked list
> of bh's and tape->bh is a pointer within that list. The remaining pipelining
> functions have been readjusted to handle the merge buffer. I guess, that was it,
> pipelining is gone.
> 
>  drivers/ide/ide-tape.c |  215 ++++++++++++++++++++++--------------------------
>  1 files changed, 99 insertions(+), 116 deletions(-)

I applied all 6 patches, thanks!

Bart
