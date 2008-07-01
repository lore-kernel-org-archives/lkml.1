Return-Path: <linux-kernel-owner+w=401wt.eu-S1752811AbYGADyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbYGADyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 23:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbYGADyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 23:54:31 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:43809 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbYGADya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 23:54:30 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, bunk@kernel.org
Subject: Re: [PATCH 3/7] fat/dir.c: switch to struct __fat_dirent
References: <9edbdefc3e848699cfe111608.ps@mail.parknet.co.jp>
	<129170883e848699cff211608.ps@mail.parknet.co.jp>
	<d3ce91fd3e848699cff311608.ps@mail.parknet.co.jp>
	<20080630203228.7b3ac420.akpm@linux-foundation.org>
Date: Tue, 01 Jul 2008 12:54:16 +0900
In-Reply-To: <20080630203228.7b3ac420.akpm@linux-foundation.org> (Andrew
	Morton's message of "Mon, 30 Jun 2008 20:32:28 -0700")
Message-ID: <87vdzqw97b.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Tue, 01 Jul 2008 11:57:03 +0900 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:
>
>> struct __fat_dirent is what was formerly the kernel struct dirent
>> (that was different from the userspace struct dirent).
>> 
>> Converting all fat users to struct __fat_dirent will allow us to get 
>> rid of the conflicting struct dirent definition.
>> 
>> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>> Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
> I assume this was authored by Adrian.  Please tell me if that is wrong.

Yes, Adrian is author.

> The way you sent this implies that you were the author.

Oops.

> The way to communicate authorship with emailed patches is to place the
> author's "From:" line right at the top of the changelog.

I see. Sorry. I'll fix my script, and will add "From: " line next time.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
