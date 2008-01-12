Return-Path: <linux-kernel-owner+w=401wt.eu-S1763582AbYALO1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763582AbYALO1j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 09:27:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763110AbYALO0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 09:26:44 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:50596 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762750AbYALO0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 09:26:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=vsc9NKH7XXnidUUDujOGOG2fefQIPGpxhrwazi+GHNtmKyzbdkOw95lpDhFeQgTir320CTy6Vww5h8cfnDLzZGCGT7vrNNRqirykghB1zSZ2ISwWn0+KRXj2WaXbIGpi4yrLpStblgJSYLVi24TJ5AlKp7V/vP06QkCYclxSeLI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <bbpetkov@yahoo.de>
Subject: Re: [PATCH 00/21] ide-floppy redux v2
Date: Sat, 12 Jan 2008 14:46:00 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1200052699-28420-1-git-send-email-bbpetkov@yahoo.de>
In-Reply-To: <1200052699-28420-1-git-send-email-bbpetkov@yahoo.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801121446.00276.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 January 2008, Borislav Petkov wrote:
> 
> Hi Bart,
> 
>    here's the second version of the ide-floppy refactoring trail. All the
> patches are based on the version of your quilt tree from the 05.01. Also, you've
> already applied patch 5 in this series but i'm submitting it still for the sake
> of completeness.
> 
> 
>  drivers/ide/ide-cd.c     |    2 -
>  drivers/ide/ide-floppy.c | 1403 ++++++++++++++++++----------------------------
>  include/linux/cdrom.h    |    1 +
>  include/linux/ide.h      |    3 +
>  4 files changed, 558 insertions(+), 851 deletions(-)

applied patches #1-4, #8
(#4 with some changes)

#5 was already applied so I just re-ordered it into the right spot

I have some comments for #6-7
