Return-Path: <linux-kernel-owner+w=401wt.eu-S1757767AbYLFAxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767AbYLFAxP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 19:53:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753238AbYLFAw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 19:52:59 -0500
Received: from ti-out-0910.google.com ([209.85.142.185]:29656 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbYLFAw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 19:52:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=sTgTy+/3n8lkDE91LnhWPIVAKjAXcORh6BN9gmJ5/vQT7aEdo99eSQfRWHg8y8RkzN
         zgQlZCqRjxzeFdi/o+6fnDohS2fpVkQSI3Yohjp88veTVQ62RvR59U9LhY9re3bRAoix
         M++fDuHEAVKMfrwFB/kvprUQpokPp3ieiTyo4=
Message-ID: <2375c9f90812051652n70475986td3f65a3a364e48dc@mail.gmail.com>
Date: Sat, 6 Dec 2008 00:52:56 +0000
From: "=?UTF-8?Q?Am=C3=A9rico_Wang?=" <xiyou.wangcong@gmail.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2/3] fix warning of not used variable
Cc: "Jianjun Kong" <jianjun@zeuux.org>,
       Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <200812051031.08121.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <20081204010022.GB17445@ubuntu>
	 <2375c9f90812040336r498cfefbta51b2ae2689a3d5f@mail.gmail.com>
	 <200812051031.08121.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id mB60rJdq009311

On Fri, Dec 5, 2008 at 12:01 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:> On Thursday 04 December 2008 22:06:33 AmÃ©rico Wang wrote:>> On Thu, Dec 4, 2008 at 1:00 AM, Jianjun Kong <jianjun@zeuux.org> wrote:>> > fix this warning:>> > kernel/module.c:824: warning: 'print_unload_info' defined but not used>> > print_unload_info() just used when CONFIG_PROC_FS was defined.>> >>> > Signed-off-by: Jianjun Kong <jianjun@zeuux.org>>>>> Reviewed-by: WANG Cong <wangcong@zeuux.org>>> My main concern is that this adds two new #ifdef sections.  How about marking> both cases "inline" instead?>
Hi, sorry for the delay.
Er, making them inline can solve this problem?ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
