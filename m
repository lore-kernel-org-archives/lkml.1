Return-Path: <linux-kernel-owner+w=401wt.eu-S933054AbXCUQut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933054AbXCUQut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 12:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933057AbXCUQus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 12:50:48 -0400
Received: from mail.parknet.jp ([210.171.160.80]:2537 "EHLO parknet.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933054AbXCUQur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 12:50:47 -0400
X-AuthUser: hirofumi@parknet.jp
To: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       agalakhov@ifmlrs.uran.ru, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] Sanitize filesystem NLS handling
References: <45FD6EF5.1030706@ums.usu.ru> <87hcsius7b.fsf@duaron.myhome.or.jp>
	<45FDFC69.6020605@ums.usu.ru> <87d535vqrz.fsf@duaron.myhome.or.jp>
	<45FE13B9.8000203@ums.usu.ru> <87vegxdc8i.fsf@duaron.myhome.or.jp>
	<45FE2483.4060706@ums.usu.ru> <878xdtux71.fsf@duaron.myhome.or.jp>
	<45FEA669.1060301@ums.usu.ru> <871wjlp2l0.fsf@duaron.myhome.or.jp>
	<45FF7E5B.3070602@ums.usu.ru>
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Thu, 22 Mar 2007 01:50:33 +0900
In-Reply-To: <45FF7E5B.3070602@ums.usu.ru> (Alexander E. Patrakov's message of "Tue\, 20 Mar 2007 11\:25\:31 +0500")
Message-ID: <87vegu4k2u.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Alexander E. Patrakov" <patrakov@ums.usu.ru> writes:

> Would it be OK for you if I add the mount-time check for iocharset=utf8 to 
> the fat filesystem and silently replace this with the "utf8" option, instead 
> of overly actively warning the users? This way, the sysfs option and the 
> nls_base.iocharset module parameter will still work as I want.

Sounds good. But, how do you specify the iocharset's nls for utf8?

>> Because you didn't change the locale. And it is your policy, right?
>
> Yes. This is because I have some files with non-ASCII names in my home 
> directory. Changing the locale would make these filenames look wrong until I 
> change it back.

The _kernel_ has no reason to force one policy, and that's why I
suggested to add per-filesystem driver option (not per-super_block).
(e.g. nls provides interface for it, etc...)
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
