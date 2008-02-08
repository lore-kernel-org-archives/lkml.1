Return-Path: <linux-kernel-owner+w=401wt.eu-S1751488AbYBHF2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488AbYBHF2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 00:28:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933294AbYBHF2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 00:28:08 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52673 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbYBHF2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 00:28:05 -0500
Date: Fri, 08 Feb 2008 14:28:34 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "rohit h" <hrohit85@gmail.com>
Subject: Re: C++ in linux kernel
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
In-Reply-To: <90d987c0802072121v378da809l7b2690980566cd9@mail.gmail.com>
References: <90d987c0802072121v378da809l7b2690980566cd9@mail.gmail.com>
Message-Id: <20080208142638.87EB.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

>  I am a kernel newbie.
>  I tried to insmod a C++ module containing classes, inheritance.
>  I am getting 'unresolved symbol' error when I use the 'new' keyword.
>  What could the problem be?

under using gcc, new operator use malloc by default.
but linux doesn't have malloc.

Could you create custom allocater?

>  What kind of runtime support is needed ( arm linux kernel)? Is a
> patch available for it?

may be nothing.

- kosaki


