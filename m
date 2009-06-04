Return-Path: <linux-kernel-owner+w=401wt.eu-S1755097AbZFDVd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097AbZFDVd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 17:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbZFDVds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 17:33:48 -0400
Received: from mail.samba.org ([66.70.73.150]:55190 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753008AbZFDVdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 17:33:47 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18984.15789.768050.525468@samba.org>
Date: Fri, 5 Jun 2009 07:33:33 +1000
To: vimal singh <vimal.newwork@gmail.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
In-Reply-To: <ce9ab5790906040326t8deb5fbs600c8c8cd93d9746@mail.gmail.com>
References: <1241199689.13073.6.camel@norville.austin.ibm.com>
	<87bpqbaji9.fsf@devron.myhome.or.jp>
	<18940.9039.850580.48730@samba.org>
	<87ab5v9381.fsf@devron.myhome.or.jp>
	<18940.10942.989329.993465@samba.org>
	<87ocub7ngh.fsf@devron.myhome.or.jp>
	<18940.12667.429391.927727@samba.org>
	<8763gj7m23.fsf@devron.myhome.or.jp>
	<ce9ab5790905270505i530febcerfda874f5049c6c93@mail.gmail.com>
	<18973.54100.522638.314377@samba.org>
	<ce9ab5790906040326t8deb5fbs600c8c8cd93d9746@mail.gmail.com>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vimal,

 > Is there any problem in previous patch, which you looking to fix in
 > the new version? Or these are all non-technical issues.

The previous patch is fine, although as several people pointed out it
lacked a public explanation of why it is needed. We are working on
fixing that. We are also working towards the release of a new patch
that has some advantages in terms of what functionality is lost when
the patch is enabled.

 > Can I take this patch for as of now?

yes, there are no issues with the patch we sent that would prevent
anyone using it, it just lacks an explanation and loses more
functionality than is strictly necessary.

Cheers, Tridge
