Return-Path: <linux-kernel-owner+w=401wt.eu-S1753865AbYAXPMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbYAXPMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 10:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbYAXPMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 10:12:10 -0500
Received: from cweiske.de ([80.237.146.62]:35777 "EHLO mail.cweiske.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407AbYAXPMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 10:12:09 -0500
X-Greylist: delayed 1370 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Jan 2008 10:12:09 EST
Message-Id: <106F876A-E2D6-4880-B850-5C5FE383D75F@kix.in>
From: Anant Narayanan <anant@kix.in>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: Programmed Exception Handling
Date: Thu, 24 Jan 2008 20:18:45 +0530
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good day,

I'm trying to implement a binary format loader for a foreign  
executable format, and have a few questions regarding the same:

1) The executable format is static, and thus, there's no dynamic/ 
shared library loading involved. Is it ok to leave `load_shlib' of  
`linux_binfmt' unimplemented?

2) During execution of the foreign executable, system calls are  
notified via an interrupt (or programmed exception in intel  
terminology)  - 0x64. This is different from the interrupt raised by  
linux for system calls - 0x80. Thus, I'd like to be able to intercept  
these interrupts and handle them gracefully (eg: call a real linux  
system call via INT 0x80 instead). I think using `set_system_gate()'  
is the way to do that, is it possible to call that function in a  
kernel module to register my interrupt handler?

3) Is there a method by which the kernel manages allocation of  
programmed exceptions? What happens when another module which also  
wants to intercept INT 0x64 is loaded?

I'm not subscribed to the list, and would appreciate it if you could  
CC me on any replies.

Thank you for your time.

--
Anant
