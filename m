Return-Path: <linux-kernel-owner+w=401wt.eu-S1759976AbXGOJoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759976AbXGOJoQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 05:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756864AbXGOJoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 05:44:03 -0400
Received: from smtp-out3.libero.it ([212.52.84.43]:44262 "EHLO
	smtp-out3.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756812AbXGOJoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 05:44:01 -0400
X-Scanned: with antispam and antivirus automated system at libero.it
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAAKJmUaXQKEH/2dsb2JhbAA
Subject: Increase vmalloc size on kernel >=2.4.27
From: Giampaolo Bellini <iw2lsi@ir2ip.net>
Reply-To: iw2lsi@ir2ip.net
To: linux-kernel@vger.kernel.org
Cc: iw2lsi@ir2ip.net
Content-Type: text/plain
Date: Sun, 15 Jul 2007 09:43:07 +0000
Message-Id: <1184492587.3102.9.camel@debito>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all...

is there a way to reserve more than 128MB of virtual memory on a i386
machine with kernel >=2.4.27 and 1GB of RAM ?

looking in page.h I've found a

#define VMALLOC_RESERVE (128<<20)

but changing it to 

#define VMALLOC_RESERVE (256<<20)

does not solve my problem.

thanks a lot for your time,

 Paolo

