Return-Path: <linux-kernel-owner+w=401wt.eu-S1756845AbYJHA72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845AbYJHA72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 20:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbYJHA7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 20:59:19 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51978 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbYJHA7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 20:59:19 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Yanping Du" <Yanping.Du@datadomain.com>
Subject: Re: mlock() return value issue in kernel 2.6.23.17
Cc: kosaki.motohiro@jp.fujitsu.com, <linux-kernel@vger.kernel.org>,
       <yanping.du@gmail.com>
In-Reply-To: <7FF8E1C68090A144B921AFD6A6736A7303FC3879@sjcex01.DataDomain.com>
References: <7FF8E1C68090A144B921AFD6A6736A7303FC3879@sjcex01.DataDomain.com>
Message-Id: <20081008094111.9BBF.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Wed,  8 Oct 2008 09:59:13 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yanping,

> Hi Kosaki,
> 
>   Seems SUSv3 has more requirements beyond errno return code. Upon
> failure (EAGAIN, etc), it requires .no change is made to any locks in
> the address space of the process., but Linux mlock(2) will set vma flag
> as VM_LOCKED even if make_pages_present() fails for some pages in the
> vma. Any comment on this ?
> 
> SUSv3: http://www.unix.org/single_unix_specification/
> 
> "Upon successful completion, the mlock() and munlock() functions shall
> return a value of zero. Otherwise, no change is made to any locks in the
> address space of the process, and the function shall return a value of
> -1 and set errno to indicate the error."

Correct.

However, I haven't seen this behavior cause any trouble.
Do you know any case?

So, if nobody feel awful, I don't interest it so much ;)



