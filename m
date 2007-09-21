Return-Path: <linux-kernel-owner+w=401wt.eu-S1760544AbXIUOsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760544AbXIUOsP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 10:48:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758267AbXIUOsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 10:48:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61181 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758047AbXIUOr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 10:47:59 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [BUG] Possible cache memory leak.
To: Micha? Kazior <kazikcz@gmail.com>, linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Fri, 21 Sep 2007 16:47:48 +0200
References: <95NCx-7eE-13@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1IYjnJ-0000ee-2g@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1+HGiV++Vr3g0AOejXyHaBdXSNFyz0RinTwtwm
 gxjOPK6Gn/1ZJCUmtbJBRWwVwypnr6CxjwF4hnAl7roxIPYfYT
 Ed9paLyAgH+1RYc79qo6g==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Micha? Kazior <kazikcz@gmail.com> wrote:

> I've discovered a strange thing lately. My memory is being sucked out
> when doing (I suppose) _a lot_ of stat() on the file system. I got left
> once with ~30MB of ram (of 512 in total) which made my system trash
> like hell. You might try doing the following to reproduce the effect:
> 
>  $ echo 1 > /proc/sys/vm/drop_caches
>  $ vmstat                            # write down the result
>  $ du -s -x /lots/of/files           # keep it running for a minute
>  $ echo 1 > /proc/sys/vm/drop_caches
>  $ vmstat                            # write it down too

RTFM: Documentation/filesystems/proc.txt
-- 
To define recursion, we must first define recursion. 

Friﬂ, Spammer: xrju@clfD.7eggert.dyndns.org Oe8nj@Gqhh.7eggert.dyndns.org
 j@7eggert.dyndns.org k@gqg.7eggert.dyndns.org
