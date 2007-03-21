Return-Path: <linux-kernel-owner+w=401wt.eu-S933770AbXCUTak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933770AbXCUTak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 15:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933814AbXCUTak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 15:30:40 -0400
Received: from tag.witbe.net ([81.88.96.48]:39044 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933770AbXCUTaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 15:30:39 -0400
Reply-To: <rol@as2917.net>
From: "Paul Rolland" <rol@as2917.net>
To: <Valdis.Kletnieks@vt.edu>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>
Subject: RE: Why is /dev on a different filesystem ? [Kernel 2.6.20.3]
Date: Wed, 21 Mar 2007 20:30:42 +0100
Organization: AS2917.net
Message-ID: <050701c76bef$6d4c2110$4b00a8c0@donald>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
In-Reply-To: <200703211920.l2LJKI1K019114@turing-police.cc.vt.edu>
Thread-Index: Acdr7gCcqiKbl1IURYqTAFEg0UzugwAAULQw
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Might want to 'cat /proc/mounts', and ponder the fact that a 
> filesystem
> can be mounted and not listed in /etc/mtab, and then see if 
> your system
> has 'udev' installed and enabled.

Damn ! You're right :
cat /proc/mounts | grep dev
none /dev tmpfs rw 0 0

and no, I don't have any udev running, still can't stand it ;)

Thx for the pointer, I was too much trusting df :(

Regards,
Paul
 

