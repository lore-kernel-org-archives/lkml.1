Return-Path: <linux-kernel-owner+w=401wt.eu-S1759340AbYDYIwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759340AbYDYIwL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 04:52:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757063AbYDYIvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 04:51:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:57902 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830AbYDYIvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 04:51:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ROUy2n3eJvE1Jv9waCelZS5DMWuW8Q278kcCitsQmtWP4JLAGgNzMRl3c28AJTbHe57Rie1jSU1wDbPDHbIPs0guwoDBge6GmOXNvkhSNzncSNDhMTBS6zgY2aCDLWOrWSfu+VoN8w2VsMuMvOU8MVz/vSFYa56UU8eB/mzKVdM=
Message-ID: <18b669d80804250151h516788cdqc7931a7ab5a195de@mail.gmail.com>
Date: Fri, 25 Apr 2008 17:51:49 +0900
From: "Shigeo N" <shigeonx@gmail.com>
To: "=?UTF-8?Q?Ilpo_J=C3=A4rvinen?=" <ilpo.jarvinen@helsinki.fi>
Subject: Re: XTP for 2.6.25
Cc: "Andi Kleen" <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0804251115470.2363@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <18b669d80804240314t7b2f6e4cpc9a9f2690c6d21b4@mail.gmail.com>
	 <873apbijb9.fsf@basil.nowhere.org>
	 <18b669d80804240606n47854939x94278f8d974034c1@mail.gmail.com>
	 <18b669d80804250059m793f3f56xc4fdb8bad949fa3@mail.gmail.com>
	 <Pine.LNX.4.64.0804251115470.2363@wrl-59.cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m3P8qHEB030873

One host(sender) is 2.6.25, but the other(receiver) is 2.6.18.I will evaluate again after I upgrade it to 2.6.25.
Thanks
On Fri, Apr 25, 2008 at 5:23 PM, Ilpo JÃ¤rvinen<ilpo.jarvinen@helsinki.fi> wrote:> On Fri, 25 Apr 2008, Shigeo N wrote:>>  > case2) random delay>  >>  >  In this case, add a fixed amount of delay + 10% random delay by>  > command, "tc change dev eth0 root netem delay 100ms 10ms 25%".>  >>  >  Here is the result.>  >>  >     fixed delay    UDP/TCP/XTP throghput>  >   --------------------------------------->  >       10ms         88/80/92 Mbps>  >       30ms         88/51/91 Mbps>  >       50ms         88/41/89 Mbps>  >       70ms         88/28/80 Mbps>  >      100ms         88/19/66 Mbps>  >>  >  TCP's perfomance looks very poor when delay is long and variable.>>  Where these results with 2.6.25 as well? ...John Heffner just couple of>  days ago fixed reordering related problem in TCP (in case that netem>  parametrization causes reordering), the fix is not even in 2.6.24.y, I>  think...>>  -->   i.>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
