Return-Path: <linux-kernel-owner+w=401wt.eu-S1756075AbZEBK0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbZEBK0V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 06:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753365AbZEBK0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 06:26:11 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:49868 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbZEBK0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 06:26:09 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Andrew Tridgell <tridge@samba.org>, Steve French <sfrench@us.ibm.com>,
       Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
References: <1241199689.13073.6.camel@norville.austin.ibm.com>
	<87fxfnbytu.fsf@devron.myhome.or.jp>
	<87ws8zak1m.fsf@devron.myhome.or.jp>
Date: Sat, 02 May 2009 19:26:06 +0900
In-Reply-To: <87ws8zak1m.fsf@devron.myhome.or.jp> (OGAWA Hirofumi's message of
	"Sat, 02 May 2009 19:14:29 +0900")
Message-ID: <87bpqbaji9.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:

> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:
>
>> Dave Kleikamp <shaggy@linux.vnet.ibm.com> writes:
>>
>>> Subject: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
>>>
>>> When this option is enabled the VFAT filesystem will refuse to create
>>> new files with long names. Accessing existing files with long names
>>> will continue to work.
>>>
>>> File names to be created must conform to the 8.3 format.  Mixed case is
>>> not allowed in either the prefix or the suffix.
>>
>> I'll answer to only technical part. This patch creates different name
>> internally, without renaming dcache. Are you really sure if that's ok?
>
> Ah, sorry. I'm missing (is_shortname == 0) part.

Um.., probably, this patch would be handle the invalid chars for 8.3 alias.
Otherwise, it'll try to create ~<num> postfix, and I guess it'll become
the dcache problem.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
