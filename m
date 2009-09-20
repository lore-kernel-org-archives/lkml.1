Return-Path: <linux-kernel-owner+w=401wt.eu-S1753732AbZITDCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732AbZITDCA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 23:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbZITDB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 23:01:59 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:57785 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbZITDB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 23:01:59 -0400
From: Max Laier <max@love2party.net>
Organization: FreeBSD
To: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: page_migration question
Date: Sun, 20 Sep 2009 05:01:58 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.30-ARCH; KDE/4.3.1; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200909200501.59164.max@love2party.net>
X-Provags-ID: V01U2FsdGVkX1/ZE+tqd1uWVAYFyW4z1etFtLIRMKG6FW7VrGx
 dJeOyB/NaVS9RnItyQVHLk77DmM8xIIe3zHwVVDPsIopLqS5P8
 PjyODU5MGDC9xfrOr4uOQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I read Documentation/vm/page_migration but couldn't find the information I'm 
looking for.  Specifically, what locks am I supposed to hold/not hold while 
calling migrate_prep() and migrate_pages()?  Currently migrate_prep() seems to 
deadlock for reasons beyond me.  Any help appreciated.

-- 
/"\  Best regards,                      | mlaier@freebsd.org
\ /  Max Laier                          | ICQ #67774661
 X   http://pf4freebsd.love2party.net/  | mlaier@EFnet
/ \  ASCII Ribbon Campaign              | Against HTML Mail and News
