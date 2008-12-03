Return-Path: <linux-kernel-owner+w=401wt.eu-S1754083AbYLCMcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbYLCMcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 07:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbYLCMcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 07:32:06 -0500
Received: from rv-out-0506.google.com ([209.85.198.224]:53897 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbYLCMcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 07:32:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=NLoSbMHBQSXaIzAdtjs4WPsk80/Ni/4YoDOn4R4EY/cr7m4PNf0GrS9FbeaIvfSdnN
         pdLFPpbVPWut0IweeUoFxuWbhDWI0OOOglhRnrm0e+shK5t84NVlUBcLytPb2XveF/YG
         CaNrCDjzPvEUzpxgclyJEvbyJ5rnsn9bzJuPM=
Message-ID: <2375c9f90812030432m771984edkdd0c599bbae9bb3c@mail.gmail.com>
Date: Wed, 3 Dec 2008 12:32:02 +0000
From: "=?UTF-8?Q?Am=C3=A9rico_Wang?=" <xiyou.wangcong@gmail.com>
To: "Johannes Weiner" <hannes@cmpxchg.org>
Subject: Re: [Patch] uml: drop const qualifier for kernel_execve()
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, jdike@addtoit.com,
       user-mode-linux-devel@lists.sourceforge.net
In-Reply-To: <20081203012051.GA8953@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <2375c9f90812021451hfd77292yf2463ca99d07b88e@mail.gmail.com>
	 <20081203012051.GA8953@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id mB3CWMdq003320

On Wed, Dec 3, 2008 at 1:20 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:> On Tue, Dec 02, 2008 at 10:51:09PM +0000, AmÃ©rico Wang wrote:>> UML implementation of kernel_execve() should not have const qualifier,>> because it will finally call do_execve() which doesn't have.>> And you made sure that do_execve() is correctly annotated?>
Yes, I checked that.
Thanks.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
