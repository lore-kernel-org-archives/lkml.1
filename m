Return-Path: <linux-kernel-owner+w=401wt.eu-S1751932AbZJWODu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbZJWODu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 10:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669AbZJWODt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 10:03:49 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:57603 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbZJWODt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 10:03:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=qtZ1Vgko6QuzXLINJJQau9HD5D2AqTcXC0LUC08Y2EPpe4unnpgNtziL2dlxpoqu6R
         cmd5YpKtEKvo5ILNdepZZUkBXUZg3g1th61O+4qu6gbp6tl+tdt7AFlxdAWX0SLqH0U9
         5FJKKMaFqHPY8S/FMySHKzmlpcxECZC7n+7u4=
Message-ID: <4AE1BA31.4050000@gmail.com>
Date: Fri, 23 Oct 2009 16:14:09 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Bill Pemberton <wfp5p@virginia.edu>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] addi-data: Cleanup redundant tests on unsigned
References: <4AE184D1.4030006@gmail.com>
In-Reply-To: <4AE184D1.4030006@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 23-10-09 12:26, Roel Kluin schreef:
> The variables are unsigned so the test `>= 0' is always true,
> In these cases the other part of the test catch wrapped values.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
I forgot the stats:

 .../comedi/drivers/addi-data/APCI1710_Chrono.c     |    3 +--
 .../comedi/drivers/addi-data/hwdrv_apci1032.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci1500.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci1516.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci1564.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci2016.c      |    4 ++--
 .../comedi/drivers/addi-data/hwdrv_apci2200.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3120.c      |    5 ++---
 .../comedi/drivers/addi-data/hwdrv_apci3200.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3xxx.c      |    2 +-
 10 files changed, 12 insertions(+), 14 deletions(-)
