Return-Path: <linux-kernel-owner+w=401wt.eu-S1759075AbYGPNut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759075AbYGPNut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 09:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757723AbYGPNuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 09:50:39 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:58687 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758557AbYGPNui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 09:50:38 -0400
Date: Wed, 16 Jul 2008 17:53:58 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] coredump: make the coredumping process visible to oom kill
Message-ID: <20080716135358.GA1213@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On top of coredump-kill-mm-core_done.patch.

The last patches which change the coredump "thread management", the next
step is to make coredump interruptible.

I am worried the recent changes can break elf_fdpic_core_dump(), I can't
test it. Hopefully, in that case the fixes should be trivial.

Oleg.

