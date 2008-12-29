Return-Path: <linux-kernel-owner+w=401wt.eu-S1753138AbYL2TYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbYL2TYg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 14:24:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbYL2TY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 14:24:28 -0500
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:51861 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752267AbYL2TY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 14:24:27 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: > I even didn't have a backtrace.
To: for.poige+linux@gmail.com, Sitsofe Wheeler <sitsofe@yahoo.com>,
       Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Mon, 29 Dec 2008 20:24:18 +0100
References: <bOpT3-2LN-13@gated-at.bofh.it> <bOpT3-2LN-15@gated-at.bofh.it> <bOpT3-2LN-11@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1LHNit-0001cP-EQ@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Igor Podlesny <for.poige+linux@gmail.com> wrote:
> 2008/12/29 Sitsofe Wheeler <sitsofe@yahoo.com>:
>> Igor Podlesny wrote:

>>>        BTW, I wonder -- can the kernel store crash related information (if
>>> any) in RAM, at certain addresses, so it can survive warm reboot and
>>> get displayed "in dmesg" on the next boot?
>>
>> Perhaps you are thinking of kdump - http://lwn.net/Articles/108595/ ?
> 
> Similar, but no exactly. I just thought that unlikely BIOS erases
> memory content during "fast checks", so kernel diagnostic could be
> left at certain addresses, probably duplicated for safety, and newly
> booted kernel could check if there were something left for it in RAM.
> That's simpler than kdump/kexec, the question is only whether memory
> is really left intact during BIOS work, at least partly.

You may want to read "ISA System Architecture
 By Tom Shanley, Don Anderson, John Swindle, MindShare, Inc"

http://books.google.com/books?id=iXE6mwUCNWQC&pg=PA110&lpg=PA112&ots=ZH_c88LEqd&dq=post+reset+flag+0072+0040&ie=ISO-8859-1&output=htmlhttp://books.google.com/books?id=iXE6mwUCNWQC&pg=PA112&lpg=PA112&dq=post+reset+flag+0072+0040&source=web&ots=ZH_c88LEqd&sig=3EbSpcxbKrPvd1ixhysJK4AuOrA&hl=en&sa=X&oi=book_result&resnum=1&ct=result

HTH.

