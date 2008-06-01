Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbYFAV3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbYFAV3c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 17:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbYFAV3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 17:29:08 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:37518 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbYFAV3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 17:29:07 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Pavel Machek <pavel@ucw.cz>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Rsync cannot copy to a vfat partition on kernel 2.6.25
References: <bug-449080-176318@bugzilla.redhat.com>
	<200805301659.m4UGx3AW001503@bz-web2.app.phx.redhat.com>
	<20080530171432.GA32480@redhat.com>
	<87prr36284.fsf@duaron.myhome.or.jp> <20080601203229.GA5615@ucw.cz>
	<878wxouafc.fsf@duaron.myhome.or.jp>
	<87fxrwsv6u.fsf@duaron.myhome.or.jp>
Date: Mon, 02 Jun 2008 06:29:02 +0900
In-Reply-To: <87fxrwsv6u.fsf@duaron.myhome.or.jp> (OGAWA Hirofumi's message of
	"Mon, 02 Jun 2008 06:26:49 +0900")
Message-ID: <87bq2ksv35.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:

> BTW, if users specified "quiet" option, FAT driver will ignore some
> permission check (uid, gid, etc.).

And it will return 0 without changing attribute.

> So, another solution would be to specify this option, or change default
> of it.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
