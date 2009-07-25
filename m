Return-Path: <linux-kernel-owner+w=401wt.eu-S1755135AbZGYGlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135AbZGYGlA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 02:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755073AbZGYGk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 02:40:59 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:56925 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648AbZGYGk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 02:40:58 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Jorg Schummer <ext-jorg.2.schummer@nokia.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH take 2][RFC] fat: Save FAT root directory timestamps to volume label
References: <1248274841-3586-1-git-send-email-ext-jorg.2.schummer@nokia.com>
	<1248428635-26073-1-git-send-email-ext-jorg.2.schummer@nokia.com>
Date: Sat, 25 Jul 2009 14:48:25 +0900
In-Reply-To: <1248428635-26073-1-git-send-email-ext-jorg.2.schummer@nokia.com>
	(Jorg Schummer's message of "Fri, 24 Jul 2009 12:43:55 +0300")
Message-ID: <87fxclmhxy.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jorg Schummer <ext-jorg.2.schummer@nokia.com> writes:

> Standard FAT implementations cannot store any of the FAT root directory's
> timestamps. This commit adds the mount option 'rootts', which allows saving
> the FAT root directory timestamps as the timestamps of the FAT volume label
> directory entry. At least Mac OS X is known to support the same mechanism
> and interoperate with this commit.
>
> When mounting, the following values can be specified for the 'rootts' mount
> option:
>
>   "rootts=ignore"   ignores root directory timestamps. All timestamps are
>                     reset to 0 (1/1/1970). This is the default.
>
>   "rootts=load"     only tries to load the root directory's timestamps from
>                     a volume label entry when mounting.
>
>   "rootts=preserve" tries to load and save the root directory's timestamps
>                     if a volume label entry exists.
>
>   "rootts=save"     tries to load and save the root directory's timestamps.
>                     If the root directory was accessed but no volume label
>                     entry exists, the label "NO NAME" is created.

Looks like interesting hack. However, personally, I don't think I want
this, but I guess it can be only me.

Well, so, what is this for? If rootdir doesn't have timestamp, some app
is not working, or something?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
