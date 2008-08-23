Return-Path: <linux-kernel-owner+w=401wt.eu-S1756358AbYHWURp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358AbYHWURp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 16:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754320AbYHWURh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 16:17:37 -0400
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:56008 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753394AbYHWURf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 16:17:35 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Segmentation fault details?
To: Wang Yi <leonidwang@gmail.com>, linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Sat, 23 Aug 2008 22:23:55 +0200
References: <aZzy0-8hH-13@gated-at.bofh.it> <aZzy0-8hH-15@gated-at.bofh.it> <aZzxZ-8hH-11@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1KWzeO-0004TU-Hr@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wang Yi <leonidwang@gmail.com> wrote:

>  I'd like to know some details about segmentation fault.
>  What I mean is when a program accesses invalid memory area, it will
> get a SIGSEGV signal from kernel, and a message "Segmentation fault".
> 
>  I also find that dmesg can show we something like this:
>  ProgramName[Pid]: segfault at xxxx eip xxxx esp xxxx error x
>  It is useful and provides the first-step information for further
> debug/analysis.
> 
>  My question is how dmesg gets the information, and if there are any
> "decent" way to get this and maybe more information(An "indecent" way
> I came to is grep dmesg)
> so that I can perform some basic auto analysis.

I'm wondering if the default handler might print this information isntead
of the plain segmentation violation.

