Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793AbYABJ14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbYABJ14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 04:27:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753306AbYABJ1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 04:27:45 -0500
Received: from smtp103.plus.mail.re1.yahoo.com ([69.147.102.66]:28464 "HELO
	smtp103.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753273AbYABJ1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 04:27:44 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:Mail-Followup-To:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:User-Agent;
  b=o0G/XLlhlcF9ue1jn1qnV20wMamjtSeOeWB6Xnncft4kPgxHxxeoFLXanN/Y+U3N08wSRLTWZZO3Z8y2Yh99l5OhB8ekHRU7ZLMQb8PltPIFWihrZj6VCN8mM4C/XlucFTyXUHUDlKIDZ9qoXjVjnCtKcKz204uxmxj5xMBf6jM=  ;
X-YMail-OSG: HkDMKwAVM1nT8uBUZwWlkBWnoM9NJ6p.WcnkOYGz63VgWFTAUWO1.Wo2nb74RqO_rRh2haxS4g--
Date: Wed, 2 Jan 2008 10:25:05 +0100
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: ide-floppy redux p1
Message-ID: <20080102092505.GA16665@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
Mail-Followup-To: bbpetkov@yahoo.de,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

here's the unfinished redux of ide-floppy which i'm sending now so that we could
sinchronize trees. There are some things left to be done which are not so
trivial and i'd like to give them a bit more thought :).


 drivers/ide/ide-floppy.c                         | 1248 +++++++---------------
 drivers/ide/ide-floppy.h                         |  351 ++++++
 include/linux/cdrom.h                            |    1 +
 4 files changed, 819 insertions(+), 845 deletions(-)

-- 
Regards/Gruﬂ,
    Boris.
