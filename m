Return-Path: <linux-kernel-owner+w=401wt.eu-S1753290AbXLRUzD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbXLRUzD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 15:55:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbXLRUyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 15:54:54 -0500
Received: from hpsmtp-eml13.KPNXCHANGE.COM ([213.75.38.113]:59599 "EHLO
	hpsmtp-eml13.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751871AbXLRUyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 15:54:53 -0500
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: Re: [PATCH] finish processor.h integration
Cc: ak@suse.de, akpm@linux-foundation.org, anthony@codemonkey.ws,
       avi@qumranet.com, chrisw@sous-sol.org, ehabkost@redhat.com,
       gcosta@redhat.com, glommer@gmail.com, hpa@zytor.com, jeremy@goop.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, roland@redhat.com,
       rostedt@goodmis.org, rusty@rustcorp.com.au, tglx@linutronix.de,
       virtualization@lists.linux-foundation.org, zach@vmware.com
In-reply-To: <1198008293639-git-send-email-gcosta@redhat.com>
References: <1198008293639-git-send-email-gcosta@redhat.com>
Message-Id: <E1J4jSf-00024X-GN@faramir.fjphome.nl>
From: Frans Pop <elendil@planet.nl>
Date: Tue, 18 Dec 2007 21:54:45 +0100
X-OriginalArrivalTime: 18 Dec 2007 20:54:50.0096 (UTC) FILETIME=[3B132F00:01C841B8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa wrote:
> What's left in processor_32.h and processor_64.h cannot be cleanly
> integrated. However, it's just a couple of definitions. They are moved
> to processor.h around ifdefs, and the original files are deleted. Note
> that there's much less headers included in the final version.

Either I must be missing something or this patch was corrupted somehow.

I see:

+#ifdef CONFIG_X86_32
[...]
+#endif /* CONFIG_X86_64 */

While I'd have expected:

+#ifdef CONFIG_X86_32
[...]
+#endif /* CONFIG_X86_32 */
+
+#ifdef CONFIG_X86_64
[...]
+#endif /* CONFIG_X86_64 */

Cheers,
FJP
