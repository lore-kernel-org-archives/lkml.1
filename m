Return-Path: <linux-kernel-owner+w=401wt.eu-S932747AbZHDKce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932747AbZHDKce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 06:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932540AbZHDKce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 06:32:34 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:34144 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932513AbZHDKcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 06:32:33 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: =?iso-8859-1?Q?J=F6rg?= Schummer <ext-jorg.2.schummer@nokia.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH take 2][RFC] fat: Save FAT root directory timestamps to volume label
References: <1248274841-3586-1-git-send-email-ext-jorg.2.schummer@nokia.com>
	<1248428635-26073-1-git-send-email-ext-jorg.2.schummer@nokia.com>
	<87fxclmhxy.fsf@devron.myhome.or.jp>
	<1248691635.4618.43.camel@jorg-desktop>
	<87ljmas5ym.fsf@devron.myhome.or.jp>
	<1249375357.5736.53.camel@jorg-desktop>
Date: Tue, 04 Aug 2009 19:32:29 +0900
In-Reply-To: <1249375357.5736.53.camel@jorg-desktop> (=?iso-8859-1?Q?=22J?=
 =?iso-8859-1?Q?=F6rg?= Schummer"'s
	message of "Tue, 04 Aug 2009 11:42:37 +0300")
Message-ID: <87zlafswci.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jörg Schummer <ext-jorg.2.schummer@nokia.com> writes:

> On Mon, 2009-07-27 at 13:47 +0200, ext OGAWA Hirofumi wrote:
>> Jörg Schummer <ext-jorg.2.schummer@nokia.com> writes:
>
>> BTW, the patch has several bugs. fat_get_label_entry() doesn't check
>> IS_FREE(), is it right? fat_create_label_entry() doesn't initialize all
>> timestamp in the case of msdos. spin_lock() usage is wrong. and more...
>
> After reviewing the patch again, I did notice some additional problems
> (I suppose that was the "and more..."). If and when I have time again, I
> might take a closer look at it again.
>
> Thanks for your help until now!

No problem at all. Thanks for your work.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
