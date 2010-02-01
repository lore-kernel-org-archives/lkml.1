Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab0BASf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 13:35:59 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:50075 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754842Ab0BASf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 13:35:57 -0500
In-Reply-To: <15772.1265047413@jrobl>
References: <4B666164.3090504@cn.fujitsu.com> <15772.1265047413@jrobl>
To: hooanon05@yahoo.co.jp
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Shi Weihua <shiwh@cn.fujitsu.com>, Al Viro <viro@ZenIV.linux.org.uk>
MIME-Version: 1.0
Subject: Re: security ima: Kernel BUG in ima_file_free -- bisected to commit
 6c21a7fb492bf7e2c4985937082ce58ddeca84bd
X-KeepSent: 6927C959:C86D4BC1-852576BD:00651E94;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5 December 05, 2008
Message-ID: <OF6927C959.C86D4BC1-ON852576BD.00651E94-852576BD.0066295F@us.ibm.com>
From: Mimi Zohar <zohar@us.ibm.com>
Date: Mon, 1 Feb 2010 13:35:52 -0500
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Release 8.5.1HF41 | October 22, 2009) at
 02/01/2010 13:35:52,
	Serialize complete at 02/01/2010 13:35:52
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hooanon05@yahoo.co.jp wrote on 02/01/2010 01:03:33 PM:

> Shi Weihua:
> > Used the latest LTP to test 2.6.33-rc6, a Kernel BUG occured on my 
x86_64 
> (OS: Fedora 12).
> > The message from dmesg is as following.
> > The LTP case is testcases/kernel/syscalls/pipe/pipe06.c. For seeing 
code easily, I
> > recreated a simple code to reproduce this BUG. please check the code 
in the attached.
> > 
> > I bisected a commit 6c21a7fb492bf7e2c4985937082ce58ddeca84bd,
> 
> The problem is already known and a patch is posted in last year.
> http://marc.info/?l=linux-kernel&m=126206539702176&w=2
> 
> 
> J. R. Okajima

Thanks for the pointer.  Al, can you please push this patch forward?

Thanks!

Mimi
