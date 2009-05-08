Return-Path: <linux-kernel-owner+w=401wt.eu-S1759784AbZEHTjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759784AbZEHTjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 15:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755324AbZEHTi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 15:38:59 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36477 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754285AbZEHTi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 15:38:58 -0400
Subject: Re: Adaptec driver crashes (1/3 and 2/3)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Norman Diamond <n0diamond@yahoo.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <8690A202112B4316A178F6DD0AD7E394@DIAMOND8600>
References: <8690A202112B4316A178F6DD0AD7E394@DIAMOND8600>
Content-Type: text/plain
Date: Fri, 08 May 2009 19:38:57 +0000
Message-Id: <1241811537.3327.91.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-06 at 16:13 +0900, Norman Diamond wrote:
> The easiest 100% reproducible way to crash a Linux system is as follows.
> 
> Insert either an Adaptec 1460 PCMCIA card or Adaptec 1480 CardBus card. 
> Remove the card.  Insert the card again.  Even if you knew to set the 
> console to a text mode terminal first (since Linux doesn't give Blue Screens 
> of Death otherwise), you still won't get a dump.  Not much to go on without 
> a dump, but at least it's 100% repro.

Sounds like something's still pinned.  When you remove it the first
time, can you remove the module? (that's aha152x_cs right?).

James


