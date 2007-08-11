Return-Path: <linux-kernel-owner+w=401wt.eu-S1757557AbXHKPzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557AbXHKPzp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 11:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750903AbXHKPzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 11:55:38 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:33569 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbXHKPzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 11:55:38 -0400
Date: Sat, 11 Aug 2007 17:55:37 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Mark Cannon <random.bits@rogers.com>, linux-kernel@vger.kernel.org
Subject: Re: Use of directories to hold root?
In-Reply-To: <46BCFE01.2040703@zytor.com>
Message-ID: <Pine.LNX.4.64.0708111753510.3101@fbirervta.pbzchgretzou.qr>
References: <200708101724.26724.random.bits@rogers.com>
 <Pine.LNX.4.64.0708102332580.3054@fbirervta.pbzchgretzou.qr>
 <46BCFE01.2040703@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 10 2007 17:08, H. Peter Anvin wrote:
>Jan Engelhardt wrote:
>> On Aug 10 2007 17:24, Mark Cannon wrote:
>>> You pass the kernel the root option to specify the root partition.
>>> Is there a way to identify a directory in that partition that holds the
>>> root or something equivalent to this?
>> 
>> No, but you can use pivot_root.
>
>Or better yet, use an initramfs with MS_MOVE; same as you would with the
>"normal" use of initramfs.

mount --move /foo /
=> error

What did I miss?



	Jan
-- 
