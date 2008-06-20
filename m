Return-Path: <linux-kernel-owner+w=401wt.eu-S1755210AbYFTWAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbYFTWAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 18:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753485AbYFTWAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 18:00:25 -0400
Received: from gw.goop.org ([64.81.55.164]:56636 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479AbYFTWAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 18:00:24 -0400
Message-ID: <485C2875.2050204@goop.org>
Date: Fri, 20 Jun 2008 15:00:21 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Various x86 syscall mechanisms
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roland,

As far as I can work out, an x86_32 kernel will use "int 0x80" and 
"sysenter" for system calls.  64-bit kernel will use just "syscall" for 
64-bit processes (though you can use "int 0x80" to access the 32-bit 
syscall interface from a 64-bit process), but will allow "sysenter", 
"syscall" or "int 0x80" for 32-on-64 processes.

Why does 32-on-64 implement 32-bit syscall when native 32-bit doesn't 
seem to?  Or am I overlooking something here?  Does 32-bit also support 
syscall?

Thanks,
    J
