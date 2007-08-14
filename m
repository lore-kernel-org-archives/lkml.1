Return-Path: <linux-kernel-owner+w=401wt.eu-S1765924AbXHNVkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765924AbXHNVkR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 17:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754260AbXHNVZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:25:19 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:21965 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758009AbXHNVZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:25:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=df40dxyEsuQvY2pl+8vIvGsfg3y/FPUxIw3bPhAXsDCvkY3MJoJj/APjn/xiUHarz4LiP8AVQXMDGvgBJ0kHghgkpzuDy44ZrfJvWHErTbCF9a4dLbA/i5uKjDikTJufodLEPOcAxyJVZiAtXlWifC4vYJAH2TbDXU7+8vi9EwM=
Message-ID: <be1b757c0708141425qd887581n3922702b84a21758@mail.gmail.com>
Date: Tue, 14 Aug 2007 23:25:04 +0200
From: "Karl Meyer" <adhocrocker@gmail.com>
To: "Francois Romieu" <romieu@fr.zoreil.com>
Subject: Re: PROBLEM: 2.6.23-rc "NETDEV WATCHDOG: eth0: transmit timed out"
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070814070901.GA14693@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <be1b757c0708130435y689b9dd8raf9ac9f9c0fcc976@mail.gmail.com>
	 <20070813165821.GA19356@electric-eye.fr.zoreil.com>
	 <be1b757c0708131027v5c57822as2d9bd3190fd19b71@mail.gmail.com>
	 <20070814070901.GA14693@electric-eye.fr.zoreil.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I did some additional testing, the results are:
[0e4851502f846b13b29b7f88f1250c980d57e944] r8169: merge with version
8.001.00 of Realtek's r8168 driver
does not work, I after some traffic the transmit timeout occurs.
[6dccd16b7c2703e8bbf8bca62b5cf248332afbe2] r8169: merge with version
6.001.00 of Realtek's r8169 driver
Seems to be the last version to work. I did some stress testing (much
more than the level that was enough to make
[0e4851502f846b13b29b7f88f1250c980d57e944]  break) and am currently
using this version and no problems so far.


2007/8/14, Francois Romieu <romieu@fr.zoreil.com>:
> Karl Meyer <adhocrocker@gmail.com> :
> [...]
> > dmesg, interrupts and .config are attached. I will have a look at git bisect.
>
> Can you reproduce the problem when nvidia binary-only stuff is not loaded
> after boot ?
>
> --
> Ueimor
>
