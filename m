Return-Path: <linux-kernel-owner+w=401wt.eu-S1755334AbZHDImj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbZHDImj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 04:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755302AbZHDImi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 04:42:38 -0400
Received: from smtp.nokia.com ([192.100.105.134]:33263 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265AbZHDImh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 04:42:37 -0400
Subject: Re: [PATCH take 2][RFC] fat: Save FAT root directory timestamps to
	volume label
From: =?ISO-8859-1?Q?J=F6rg?= Schummer <ext-jorg.2.schummer@nokia.com>
To: ext OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
In-Reply-To: <87ljmas5ym.fsf@devron.myhome.or.jp>
References: <1248274841-3586-1-git-send-email-ext-jorg.2.schummer@nokia.com>
	 <1248428635-26073-1-git-send-email-ext-jorg.2.schummer@nokia.com>
	 <87fxclmhxy.fsf@devron.myhome.or.jp>
	 <1248691635.4618.43.camel@jorg-desktop>
	 <87ljmas5ym.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 04 Aug 2009 11:42:37 +0300
Message-Id: <1249375357.5736.53.camel@jorg-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 04 Aug 2009 08:42:14.0638 (UTC) FILETIME=[775DD0E0:01CA14DF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-27 at 13:47 +0200, ext OGAWA Hirofumi wrote:
> Jörg Schummer <ext-jorg.2.schummer@nokia.com> writes:

> BTW, the patch has several bugs. fat_get_label_entry() doesn't check
> IS_FREE(), is it right? fat_create_label_entry() doesn't initialize all
> timestamp in the case of msdos. spin_lock() usage is wrong. and more...

After reviewing the patch again, I did notice some additional problems
(I suppose that was the "and more..."). If and when I have time again, I
might take a closer look at it again.

Thanks for your help until now!

Jörg


