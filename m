Return-Path: <linux-kernel-owner+w=401wt.eu-S1758369AbYAXXWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758369AbYAXXWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 18:22:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755088AbYAXXWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 18:22:34 -0500
Received: from wmsmtp.opaltelecom.net ([62.24.128.253]:43341 "EHLO
	smtp.talktalk.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753657AbYAXXWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 18:22:33 -0500
X-Path: TTSMTP
Date: Thu, 24 Jan 2008 23:22:21 +0000 (GMT)
From: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
X-X-Sender: tigran@ginsburg.homenet
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
cc: Heikki Orsila <shdl@zakalwe.fi>, trivial@kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 5/9] bfs: move function prototype to the proper header
 file
In-Reply-To: <47991B7C.6000208@gmail.com>
Message-ID: <Pine.LNX.4.61.0801242318560.8513@ginsburg.homenet>
References: <1201213928-18183-1-git-send-email-dmitri.vorobiev@gmail.com>
 <1201213928-18183-6-git-send-email-dmitri.vorobiev@gmail.com>
 <20080124225031.GC12172@zakalwe.fi> <47991B7C.6000208@gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463810303-1840755351-1201216941=:8513"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463810303-1840755351-1201216941=:8513
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Fri, 25 Jan 2008, Dmitri Vorobiev wrote:

> Heikki Orsila =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>>> +extern void dump_imap(const char *, struct super_block *);
>>> +
>>
>> Functions should not be externed, remove extern keyword.
>>
>
> Care to explain why?

because dump_imap() is just a BFS' internal helper (for debugging purposes=
=20
only btw) to dump the inode map via printk. Why should it be moved into=20
the header, i.e. where one expects to see things potentially visible by=20
the rest of the kernel?

> 3) The checkpatch.pl did not complain at this particular patch.

maybe this script should be simplified to not complain at things like=20
that, which are best left to the author of the code to decide which=20
declaration should be where?

Kind regards
Tigran
---1463810303-1840755351-1201216941=:8513--
