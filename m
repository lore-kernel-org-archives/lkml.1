Return-Path: <linux-kernel-owner+w=401wt.eu-S1760782AbZFZQXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760782AbZFZQXi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 12:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbZFZQXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 12:23:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57662
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750698AbZFZQX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 12:23:29 -0400
Date: Fri, 26 Jun 2009 09:23:33 -0700 (PDT)
Message-Id: <20090626.092333.104882157.davem@davemloft.net>
To: petkovbb@googlemail.com
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ide-cd: handle fragmented packet commands gracefully
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090626081958.GA15449@liondog.tnic>
References: <1245574527-2104-1-git-send-email-petkovbb@gmail.com>
	<200906221150.22992.bzolnier@gmail.com>
	<20090626081958.GA15449@liondog.tnic>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <petkovbb@googlemail.com>
Date: Fri, 26 Jun 2009 10:19:58 +0200

> Hi David,
> 
> On Mon, Jun 22, 2009 at 11:50:22AM +0200, Bartlomiej Zolnierkiewicz wrote:
>> On Sunday 21 June 2009 10:55:27 Borislav Petkov wrote:
>> > There are some devices in the wild that clear the DRQ bit during the
>> > last word of a packet command and therefore could use a "second chance"
>> > for that last word of data to be xferred instead of simply failing the
>> > request. Do that by attempting to suck in those last bytes in PIO mode.
>> > 
>> > In addition, the ATA_ERR bit has to be cleared for we cannot be sure the
>> > data is valid otherwise.
>> > 
>> > See http://bugzilla.kernel.org/show_bug.cgi?id=13399 for details.
>> > 
>> > Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
>> 
>> Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> can you pick that one too, please. I can't seem to find it on patchwork.

Yep, I'll dig into the archives to get it, I had this on my TODO
list.

Thanks!
