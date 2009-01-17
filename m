Return-Path: <linux-kernel-owner+w=401wt.eu-S1762834AbZAQPWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762834AbZAQPWU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 10:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758562AbZAQPWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 10:22:00 -0500
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:57479 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758549AbZAQPV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 10:21:59 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Linux killed Kenny, bastard!
To: Evgeniy Polyakov <zbr@ioremap.net>, David Rientjes <rientjes@google.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Reply-To: 7eggert@gmx.de
Date: Sat, 17 Jan 2009 16:21:50 +0100
References: <bTxPW-1lH-13@gated-at.bofh.it> <bTE53-5LJ-13@gated-at.bofh.it> <bTEeI-5Y0-15@gated-at.bofh.it> <bTGTe-1K5-3@gated-at.bofh.it> <bTNi6-3kb-9@gated-at.bofh.it> <bTOea-4QT-1@gated-at.bofh.it> <bTQ6f-7Qs-1@gated-at.bofh.it> <bTQpv-5o-3@gated-at.bofh.it> <bTQzd-iK-5@gated-at.bofh.it> <bTXhp-2IA-31@gated-at.bofh.it> <bTZjb-62D-25@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1LOCze-00020X-GT@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov <zbr@ioremap.net> wrote:

> The only sane way to use oom_adj is
> to disable oom killer for the task or make its score very small or very
> big, there is really no way to make a finegrained tuning, since score
> changes and userspace does not know the algorithm.

It does not need to know, it just has to tune until it's about level with
the other normal processes if it's to be a normal process, and add or
substract one or two to oom_adj if it's avery (un)important process.

