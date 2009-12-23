Return-Path: <linux-kernel-owner+w=401wt.eu-S1755032AbZLWLIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032AbZLWLIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 06:08:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754684AbZLWLI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 06:08:29 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:34119 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952AbZLWLI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 06:08:28 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Jean-Pierre =?iso-8859-1?Q?Andr=E9?= 
	<jean-pierre.andre@wanadoo.fr>
Cc: Eric Blake <ebb9@byu.net>, fuse-devel@lists.sourceforge.net,
       Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@lst.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com
Subject: Re: [fuse-devel] utimensat fails to update ctime
References: <4B2B156D.9040604@byu.net> <87aaxclr4q.fsf@devron.myhome.or.jp>
	<4B2F7421.10005@byu.net> <4B2F7A95.3010708@byu.net>
	<87hbrkjrk8.fsf@devron.myhome.or.jp> <4B304D04.6040501@byu.net>
	<87d427jscr.fsf@devron.myhome.or.jp> <4B3097C4.3060803@wanadoo.fr>
	<874onjjnln.fsf@devron.myhome.or.jp> <4B30B67A.7080703@wanadoo.fr>
	<87ljgvi1an.fsf@devron.myhome.or.jp> <4B30F0C9.2020702@wanadoo.fr>
	<87my1aevro.fsf@devron.myhome.or.jp> <4B31E63D.5040202@wanadoo.fr>
Date: Wed, 23 Dec 2009 20:08:20 +0900
In-Reply-To: <4B31E63D.5040202@wanadoo.fr> ("Jean-Pierre =?iso-8859-1?Q?An?=
 =?iso-8859-1?Q?dr=E9=22's?= message of
	"Wed, 23 Dec 2009 10:43:25 +0100")
Message-ID: <87my1ane1n.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean-Pierre André <jean-pierre.andre@wanadoo.fr> writes:

> Hi,

Hi,

> OGAWA Hirofumi wrote:
>>> I suggest I port Miklos patch to fuse-lite soon,
>>> and delay the low-level case (and microsecond
>>> precision) until January. Does that suit your needs ?
>>>      
>> Thanks. Sounds good. I'm not using ntfs-3g actually, I just bridged the
>> bug report on lkml to others. Eric?
>
> Attached is a proposed patch for selective update
> of timestamps in ntfs-3g (based on the release
> candidate version ntfs-3g-2009.11.14AC.2).
>
> It includes the backport of Miklos's patch posted
> yesterday to fuse-lite. As a matter of fact fuse-lite
> is needed, because I do not know how to make this
> compile with unpatched fuse.

Thanks for fixing this.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
