Return-Path: <linux-kernel-owner+w=401wt.eu-S1754449AbZEBNGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449AbZEBNGn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 09:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753842AbZEBNGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 09:06:33 -0400
Received: from mail.samba.org ([66.70.73.150]:43097 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752989AbZEBNGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 09:06:33 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18940.17732.738194.350106@samba.org>
Date: Sat, 2 May 2009 23:06:12 +1000
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
In-Reply-To: <87my9v657r.fsf@devron.myhome.or.jp>
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
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Current default (shortname=lower) is just for historically reason.
 > Personally, I'm thinking it's not good as default ("winnt" or "mixed" is
 > prefer).

It might make sense to make the default depend on the fs type. For
example, make FAT32 use "winnt" and FAT12/16 use "mixed". That would
give maximum interoperability I think.

I'm presuming that the versions of win95 that supported FAT32 also
supported the mixed case bits, though I haven't tested that.

Cheers, Tridge
