Return-Path: <linux-kernel-owner+w=401wt.eu-S1422891AbXDRLmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422891AbXDRLmO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 07:42:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422890AbXDRLmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 07:42:14 -0400
Received: from mail.clusterfs.com ([206.168.112.78]:49363 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422891AbXDRLmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 07:42:13 -0400
From: Nikita Danilov <nikita@clusterfs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17958.1037.284688.350035@gargle.gargle.HOWL>
Date: Wed, 18 Apr 2007 15:42:05 +0400
To: Pavel Emelianov <xemul@sw.ru>
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Kirill Korotaev <dev@openvz.org>
Subject: Re: [PATCH] Introduce a handy list_first_entry macro
Newsgroups: gmane.linux.kernel
In-Reply-To: <4624AD20.6050009@sw.ru>
References: <4624AD20.6050009@sw.ru>
X-Mailer: VM 7.17 under 21.5 (patch 17) "chayote" (+CVS-20040321) XEmacs Lucid
X-SystemSpamProbe: GOOD 0.0000626 deb17e0d9699f0d29eb3b691d31450bb
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelianov writes:
 > There are many places in the kernel where the construction like
 > 
 >    foo = list_entry(head->next, struct foo_struct, list);
 > 
 > are used. 
 > The code might look more descriptive and neat if using the macro
 > 
 >    list_first_entry(head, type, member) \
 >              list_entry((head)->next, type, member)

Won't list_next_entry() be more descriptive name for that?

Nikita.

