Return-Path: <linux-kernel-owner+w=401wt.eu-S1758791AbXF0DHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758791AbXF0DHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 23:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbXF0DHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 23:07:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54443 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754226AbXF0DHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 23:07:24 -0400
Message-ID: <4681D45F.7080309@redhat.com>
Date: Tue, 26 Jun 2007 23:07:11 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/3] MAP_NOZERO - implement sys_brk2()
References: <send-serie.davidel@xmailserver.org.29496.1182912260.2>
In-Reply-To: <send-serie.davidel@xmailserver.org.29496.1182912260.2>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi wrote:
> The following patch implements the sys_brk2() syscall, that nothing is
> other than a sys_brk() with an extra "flags" parameter. This can be used
> to pass the new MAP_NOZERO bit, to ask the kernel to hand over non-zero
> pages if possible.

Since programs can get back free()d memory after a malloc(),
with the old contents of the memory intact, surely your
MAP_NONZERO behavior could be the default for programs that
can get away with it?

Maybe we could use some magic ELF header, similar to the
way non-executable stack is handled?

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
