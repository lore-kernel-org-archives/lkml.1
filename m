Return-Path: <linux-kernel-owner+w=401wt.eu-S1755602AbZEBKUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602AbZEBKUs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 06:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753636AbZEBKUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 06:20:38 -0400
Received: from mail.samba.org ([66.70.73.150]:56792 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608AbZEBKUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 06:20:38 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18940.7781.437239.963551@samba.org>
Date: Sat, 2 May 2009 20:20:21 +1000
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
In-Reply-To: <87fxfnbytu.fsf@devron.myhome.or.jp>
References: <1241199689.13073.6.camel@norville.austin.ibm.com>
	<87fxfnbytu.fsf@devron.myhome.or.jp>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi writes:
 > I'll answer to only technical part. This patch creates different name
 > internally, without renaming dcache. Are you really sure if that's ok?

The name handling should be the same as the existing code path where
goto shortname is done after vfat_create_shortname() in
vfat_build_slots() (ie. when the name conformed to 8.3).

What situation are you thinking of which this would cause a problem?

Cheers, Tridge
