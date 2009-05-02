Return-Path: <linux-kernel-owner+w=401wt.eu-S1757661AbZEBOBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757661AbZEBOBw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 10:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755304AbZEBOB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 10:01:26 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:53241 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548AbZEBOBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 10:01:24 -0400
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
	<8763gj7m23.fsf@devron.myhome.or.jp>
	<18940.14675.395802.635154@samba.org>
	<87my9v657r.fsf@devron.myhome.or.jp>
	<18940.17732.738194.350106@samba.org>
Date: Sat, 02 May 2009 23:01:20 +0900
In-Reply-To: <18940.17732.738194.350106@samba.org> (tridge@samba.org's message
	of "Sat, 2 May 2009 23:06:12 +1000")
Message-ID: <87iqkj61u7.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tridge@samba.org writes:

>  > Current default (shortname=lower) is just for historically reason.
>  > Personally, I'm thinking it's not good as default ("winnt" or "mixed" is
>  > prefer).
>
> It might make sense to make the default depend on the fs type. For
> example, make FAT32 use "winnt" and FAT12/16 use "mixed". That would
> give maximum interoperability I think.
>
> I'm presuming that the versions of win95 that supported FAT32 also
> supported the mixed case bits, though I haven't tested that.

"mixed" means created like win95, but support to read winnt field. So,
it is compatible to win95. And even if user is using winnt option, the
file created can be readed on win95, win95 will ignore the lcase field,
and just display filename as upper case though.

I.e. created filename by any options can read on any plathome, it may
ignore the lcase field though. And, even if user is using "winnt", many
plathome wouldn't be supporting it.

Well, I think changing default by fstype is confusable.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
