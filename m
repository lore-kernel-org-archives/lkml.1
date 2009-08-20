Return-Path: <linux-kernel-owner+w=401wt.eu-S1755294AbZHTUw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294AbZHTUw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 16:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754822AbZHTUw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 16:52:58 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:62088 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbZHTUw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 16:52:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=PsBXlKQDGKzEc8Vp/lRsYSy7jq5yFG8dvUAGezDhi41kquS0nTzpapQO8hZcwNN2lI
         TehqioMm8qc1VHRk220synDK3Q2kIiAit1tXqCK6sCFdJquf1tMILexUL2q14TOB0mrN
         4UoagOCsAD3Yfmzj5q6WYemf+sN534+2GHicY=
Subject: Re: 2.6.31-rc6-git5: Reported regressions from 2.6.30
From: John Dykstra <john.dykstra1@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
In-Reply-To: <jCYznkTxcLB.A.EPH.eNIjKB@chimera>
References: <jCYznkTxcLB.A.EPH.eNIjKB@chimera>
Content-Type: text/plain
Date: Thu, 20 Aug 2009 20:52:51 +0000
Message-Id: <1250801571.7176.10.camel@Maple>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-19 at 22:20 +0200, Rafael J. Wysocki wrote:
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14002
> Subject         : WARNING: at net/ipv4/af_inet.c:154
> inet_sock_destruct+0x164/0x1c0()
> Submitter       : Ralf Hildebrandt <ralf.hildebrandt@charite.de>
> Date            : 2009-08-18 12:37 (2 days old)

That looks similar to the WARNING discussed in [1].

There was no resolution to that thread.  However, [2] points out
possible other occurrences of the problem in 2.6.27, 28 and 29.

--  John

[1]  http://www.spinics.net/lists/netdev/msg103267.html
[2]  http://www.spinics.net/lists/netdev/msg104120.html


