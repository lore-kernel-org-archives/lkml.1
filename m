Return-Path: <linux-kernel-owner+w=401wt.eu-S1754795AbZEBKSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbZEBKSN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 06:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbZEBKR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 06:17:56 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:60211 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbZEBKRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 06:17:55 -0400
X-Greylist: delayed 480 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 May 2009 06:17:55 EDT
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Andrew Tridgell <tridge@samba.org>, Steve French <sfrench@us.ibm.com>,
       Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
References: <1241199689.13073.6.camel@norville.austin.ibm.com>
Date: Sat, 02 May 2009 19:09:49 +0900
In-Reply-To: <1241199689.13073.6.camel@norville.austin.ibm.com> (Dave
	Kleikamp's message of "Fri, 01 May 2009 12:41:29 -0500")
Message-ID: <87fxfnbytu.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Kleikamp <shaggy@linux.vnet.ibm.com> writes:

> Subject: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
>
> When this option is enabled the VFAT filesystem will refuse to create
> new files with long names. Accessing existing files with long names
> will continue to work.
>
> File names to be created must conform to the 8.3 format.  Mixed case is
> not allowed in either the prefix or the suffix.

I'll answer to only technical part. This patch creates different name
internally, without renaming dcache. Are you really sure if that's ok?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
