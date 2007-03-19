Return-Path: <linux-kernel-owner+w=401wt.eu-S966044AbXCSR0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966044AbXCSR0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 13:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966046AbXCSR0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 13:26:14 -0400
Received: from mail.parknet.jp ([210.171.160.80]:2200 "EHLO parknet.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966044AbXCSR0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 13:26:14 -0400
X-AuthUser: hirofumi@parknet.jp
To: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       agalakhov@ifmlrs.uran.ru, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] Sanitize filesystem NLS handling
References: <45FD6EF5.1030706@ums.usu.ru> <87hcsius7b.fsf@duaron.myhome.or.jp>
	<45FDFC69.6020605@ums.usu.ru> <87d535vqrz.fsf@duaron.myhome.or.jp>
	<45FE13B9.8000203@ums.usu.ru> <87vegxdc8i.fsf@duaron.myhome.or.jp>
	<45FE2483.4060706@ums.usu.ru> <878xdtux71.fsf@duaron.myhome.or.jp>
	<45FEA669.1060301@ums.usu.ru>
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Tue, 20 Mar 2007 02:26:03 +0900
In-Reply-To: <45FEA669.1060301@ums.usu.ru> (Alexander E. Patrakov's message of "Mon\, 19 Mar 2007 20\:04\:09 +0500")
Message-ID: <871wjlp2l0.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Alexander E. Patrakov" <patrakov@ums.usu.ru> writes:

> But, anyway, this is a separate issue that my patch doesn't attempt to 
> correct. The conclusion so far is that we disagree, and that there are 
> situations where using utf8 iocharset is the least of all evils, so the 
> warning is not justified enough. Reproducible testcase:

Again, I don't care about read at all. And why don't you use "utf8"
option, instead of "iocharset=utf8". "iocharset=utf8" is warned until
it is fixed. The "utf8" also doesn't work correctly in some case though.

>> I'm talking about two filesystems on a system here, not two encoding
>> on one filesystem.
>
> I am also talking about this. Mounting two filesystems with different 
> iocharsets is insane, because this will result in one of the following outcomes:
>
> 1) "ls" will show wrong characters in filenames on one of the filesystems
> 2) one of the two filesystems will contain wrong on-disk data for filenames, 
> that, when misinterpreted by mounting with wrong iocharset, results in 
> seemingly-correct output, but is misunderstood by the properly set up 
> reference implementation (that's what is likely to happen with jfs in your 
> example).

Because you didn't change the locale. And it is your policy, right?
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
