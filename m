Return-Path: <linux-kernel-owner+w=401wt.eu-S1756999AbYLFBC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999AbYLFBC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 20:02:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754988AbYLFBCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 20:02:19 -0500
Received: from ti-out-0910.google.com ([209.85.142.186]:41479 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630AbYLFBCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 20:02:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=V5+EUMdCOECAFRfgpgvFb90OKab2ShGWh3ybfO7q14xLdhPjyWLjn1Ej/pfv5Lwolk
         5R5pQZn26x5zrukIPkV2fea745EUn2Atk8Y9YWbgYps6yyiy6z8pV/TLOTdmdDPVi3dS
         QOOYB98QPjmdidBIDTY6wzPDdIgNdLao3g8kw=
Message-ID: <2375c9f90812051702m217ee049i79ce2f9cc8280fb1@mail.gmail.com>
Date: Sat, 6 Dec 2008 01:02:16 +0000
From: "=?UTF-8?Q?Am=C3=A9rico_Wang?=" <xiyou.wangcong@gmail.com>
To: "Johannes Weiner" <hannes@cmpxchg.org>
Subject: Re: [Patch] uml: drop const qualifier for kernel_execve()
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, jdike@addtoit.com,
       user-mode-linux-devel@lists.sourceforge.net
In-Reply-To: <20081203134035.GA17560@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <2375c9f90812021451hfd77292yf2463ca99d07b88e@mail.gmail.com>
	 <20081203012051.GA8953@cmpxchg.org>
	 <2375c9f90812030432m771984edkdd0c599bbae9bb3c@mail.gmail.com>
	 <20081203134035.GA17560@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id mB612Wdq009373

On Wed, Dec 3, 2008 at 1:40 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:> On Wed, Dec 03, 2008 at 12:32:02PM +0000, AmÃ©rico Wang wrote:>> On Wed, Dec 3, 2008 at 1:20 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:>> > On Tue, Dec 02, 2008 at 10:51:09PM +0000, AmÃ©rico Wang wrote:>> >> UML implementation of kernel_execve() should not have const qualifier,>> >> because it will finally call do_execve() which doesn't have.>> >>> > And you made sure that do_execve() is correctly annotated?>> >>>>> Yes, I checked that.>> Good.  Then please fix up do_execve() or let the warning stand out as> a reminder.
??Confused...
do_execve() is OK, we don't need to fix it.
Thanks.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
