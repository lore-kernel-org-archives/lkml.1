Return-Path: <linux-kernel-owner+w=401wt.eu-S1756290AbYEYCkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290AbYEYCkP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 22:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbYEYCkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 22:40:04 -0400
Received: from defg500.nifty.com ([202.248.238.127]:25045 "EHLO
	defg500.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbYEYCkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 22:40:03 -0400
X-Greylist: delayed 750 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 May 2008 22:40:02 EDT
DomainKey-Signature: a=rsa-sha1; s=userg501; d=nifty.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:x-mailer:mime-version:
	content-type:content-transfer-encoding;
	b=XNQn2Iq2j/VgY5x/BsxsdBLu64EVoKVnUGQzYuyvYemjWmebRuaDz/VznjlNK6Od+
	vXUbnGojpGjM6TCYoIzKA==
X-Nifty-SrcIP: [220.145.30.125]
Date: Sun, 25 May 2008 11:23:08 +0900
From: Komuro <komurojun-mbn@nifty.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
Subject: [PLEASE REVERT]  "Add a WARN_ON_ONCE" at  net/sched/sch_generic.c:
Message-Id: <20080525112308.03a5fda7.komurojun-mbn@nifty.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please revert the patch "Add a WARN_ON_ONCE() to
 the transmit timeout function".

The transmit timeout sometimes happens on normal operation.
This message annoys me.


>net: Add a WARN_ON_ONCE() to the transmit timeout function
>
>WARN_ON_ONCE() gives a stack trace including the full module list.
>Having this in the kernel dump for the timeout case in the
>generic netdev watchdog will help us see quicker which driver
>is involved. It also allows us to collect statistics
>and patterns in terms of which drivers have this event occuring.
>
>Suggested by Andrew Morton
>
>Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
>Signed-off-by: David S. Miller <davem@davemloft.net>

Best Regards
Komuro

