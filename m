Return-Path: <linux-kernel-owner+w=401wt.eu-S1754667AbYGLPIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbYGLPIF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 11:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbYGLPHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 11:07:55 -0400
Received: from bruhost-2.ispvds.com ([82.146.33.243]:60531 "EHLO
	bruhost-2.ispvds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbYGLPHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 11:07:54 -0400
Message-ID: <4878C8B7.2030400@r000n.net>
Date: Sat, 12 Jul 2008 19:07:35 +0400
From: Roman Mindalev <lists@r000n.net>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #11035] System hangs on 2.6.26-rc8
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>	<uBi7uNfg81L.A.xt.SzLcIB@albercik>	<487600B3.2010008@r000n.net> <20080710150841.139c2a71@doriath.conectiva>
In-Reply-To: <20080710150841.139c2a71@doriath.conectiva>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (bruhost-2.ispvds.com [82.146.33.243]); Sat, 12 Jul 2008 17:07:44 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luiz Fernando N. Capitulino wrote:
> Em Thu, 10 Jul 2008 16:29:39 +0400
> Roman Mindalev <lists@r000n.net> escreveu:
> 
> | Rafael J. Wysocki wrote:
> | > This message has been generated automatically as a part of a report
> | > of recent regressions.
> | > 
> | > The following bug entry is on the current list of known regressions
> | > from 2.6.25.  Please verify if it still should be listed.
> | > 
> | > 
> | > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11035
> | > Subject		: System hangs on 2.6.26-rc8
> | > Submitter	: Roman Mindalev <lists@r000n.net>
> | > Date		: 2008-07-02 14:25 (5 days old)
> | > References	: http://marc.info/?l=linux-kernel&m=121500871414995&w=4
> | > 
> | > 
> | > 
> | I have this problem with 2.6.25 too.
> | Unfortunately, I can't check 2.6.24. With config from 2.6.26-rc8 I got
> | error of compiling:
> | 
> |   LD      .tmp_vmlinux1
> | kernel/built-in.o: In function `timespec_add_ns':
> | /usr/src/kernels/linux-2.6.24/include/linux/time.h:179: undefined
> | reference to `__umoddi3'
> 
>  [...]
> 
>  You're trying to compile with gcc 4.3, right? 
Yes, GCC 4.3.1. With time.patch kernel compiled successfully. Thanks for
help!
