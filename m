Return-Path: <linux-kernel-owner+w=401wt.eu-S1753854AbYDMV6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbYDMV6f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 17:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbYDMV61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 17:58:27 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:64707 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbYDMV61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 17:58:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hQbkYweEFOuCXEjbKkl1c7X4nJIC8DT/Seo8nGmgp2iLBYkz+Rwez8TyhYVlYcRGMylDd/s/v59z+MQMuRo/sliuUjUgln9wLCu/l3of8pnzENu1Ytr1bhaHgLo0/W9HcWDOvJlPfZpiZVmga7z/ZjdDNMoWKpqLbFlv3DSNxAg=
Message-ID: <740b8bba0804131458w7a4f22bco3f4e5c48b75169c6@mail.gmail.com>
Date: Sun, 13 Apr 2008 14:58:26 -0700
From: "David Erickson" <halcyon1981@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Kernel module unable to find an exported symbol
Cc: "Dmitri Vorobiev" <dmitri.vorobiev@gmail.com>
In-Reply-To: <4802808F.9020209@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Disposition: inline
References: <740b8bba0804131418q4a210d44k77f95714002b92a@mail.gmail.com>
	 <4802808F.9020209@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m3DLqDEB002338

On Sun, Apr 13, 2008 at 2:52 PM, Dmitri Vorobiev<dmitri.vorobiev@gmail.com> wrote:> David Erickson ĞÉÛÅÔ:>> > Hi everyone, I have two kernel modules I am developing, both use the>  > call_rcu exported function. The core module finds it no problem,>  > installs, and uses it.  The second module however when I try to insmod>  > it complains:>  >>  > Unknown symbol call_rcu>  >>  > I have verified that it is exported via /proc/kallsyms:>  > c04348c8 T call_rcu>  >>  > I am at a loss as to how to proceed, can anyone shed some light on how>  > this could be happening? Or how to diagnose and debug the problem?>>  It is very much possible that adding the following line to the source>  code of your module will help:>>  MODULE_LICENSE("GPL");>>  HTH,>  Dmitri
That did the trick, thank you Dmitri!
-Davidÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
