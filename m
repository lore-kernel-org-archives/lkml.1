Return-Path: <linux-kernel-owner+w=401wt.eu-S1756454AbZEBL7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454AbZEBL7a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 07:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754927AbZEBL7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 07:59:20 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:50376 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbZEBL7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 07:59:19 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: tridge@samba.org
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
References: <1241199689.13073.6.camel@norville.austin.ibm.com>
	<87fxfnbytu.fsf@devron.myhome.or.jp>
	<87ws8zak1m.fsf@devron.myhome.or.jp>
	<87bpqbaji9.fsf@devron.myhome.or.jp>
	<18940.9039.850580.48730@samba.org>
	<87ab5v9381.fsf@devron.myhome.or.jp>
	<18940.10942.989329.993465@samba.org>
	<87ocub7ngh.fsf@devron.myhome.or.jp>
	<18940.12667.429391.927727@samba.org>
Date: Sat, 02 May 2009 20:59:16 +0900
In-Reply-To: <18940.12667.429391.927727@samba.org> (tridge@samba.org's message
	of "Sat, 2 May 2009 21:41:47 +1000")
Message-ID: <8763gj7m23.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tridge@samba.org writes:

>  > Yes. I guess -ENAMETOOLONG would not good for !valid, and !(is_shortname
>  > && base_info.valid && ext_info.valid) or add "else" part is more prefer
>  > though.
>
> ok, new patch below. 

Looks good to me as technical stand.

>  > Yes. The case-insensitive is ok, the dcache can handle case-insensitive.
>
> good, that makes life simpler :-)
>
> Are you happy with the shortname_flags hackery in
> vfat_create_shortname() ?

Ah. What is the intent to force WINNT option (lcase field)? To force it
may not be good. So, change default if config is on?
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
