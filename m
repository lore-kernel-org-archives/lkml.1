Return-Path: <linux-kernel-owner+w=401wt.eu-S1754394AbZCIX75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394AbZCIX75 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 19:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbZCIX7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 19:59:48 -0400
Received: from gw.goop.org ([64.81.55.164]:41108 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594AbZCIX7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 19:59:48 -0400
Message-ID: <49B5AD6A.2020101@goop.org>
Date: Mon, 09 Mar 2009 16:59:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Absolute symbols in vmlinux_64.lds.S
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why does vmlinux_64.lds.S use absolute symbols for things like 
__bss_start/stop:

  __bss_start = .;		/* BSS */
  .bss : AT(ADDR(.bss) - LOAD_OFFSET) {
	*(.bss.page_aligned)
	*(.bss)
	}
  __bss_stop = .;


vmlinux_32.lds.S puts __bss_start/stop into the .bss section itself.  Is 
there some particular reason they need to be absolute symbols (relocation?).

Thanks,
    J
