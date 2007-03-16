Return-Path: <linux-kernel-owner+w=401wt.eu-S2992466AbXCPBar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992466AbXCPBar (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 21:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992468AbXCPBar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 21:30:47 -0400
Received: from inet-tsb5.toshiba.co.jp ([202.33.96.24]:49821 "EHLO
	inet-tsb5.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992466AbXCPBaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 21:30:46 -0400
Message-Id: <200703160130.l2G1UfFT007355@toshiba.co.jp>
MIME-Version: 1.0
Date: Fri, 16 Mar 2007 10:32:42 +0900
X-Mailer: Denshin 8 Go V32.1.4.5
X-My-Real-Login-Name: a_iguchi; 133.114.92.20
From: Akira Iguchi <akira2.iguchi@toshiba.co.jp>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Al Viro <viro@ftp.linux.org.uk>, torvalds@linux-foundation.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: (Your message of "Thu, 15 Mar 2007 20:48:42 +0100")
  <200703152048.42972.bzolnier@gmail.com>
References: <E1HRPb0-0003Eh-OG@ZenIV.linux.org.uk>
 <200703150608.l2F68JY2026403@toshiba.co.jp>
 <20070315084645.GR4095@ftp.linux.org.uk>
 <200703152048.42972.bzolnier@gmail.com>
Subject: Re: [PATCH 10/13] BLK_DEV_IDE_CELLEB dependency fix
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Bart wrote:
>> Al wrote:
>> So AFAICS the minimal fix for that sucker is dependency on BLK_DEV_IDE=y;
>> however, I really wonder if
>> 	* it needs to be linked into ide-core (as opposed to being a normal
>> module of its own)
>
>AFAICS there are no legacy device ordering issues with scc_pata so it doesn't
>need to be linked into ide-core but I'll leave the definitive answer to Akira
>
>> 	* alternatively, its init should be called explicitly.

I don't have the answer why scc_pata is linked into ide-core.
Reviewing your comments and codes, I will make the following fixes:
  * remove link to ide-core and make normal module
  * move from ide/ppc to ide/pci

I will send these patches later.

Best regards,
Akira Iguchi
