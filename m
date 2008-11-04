Return-Path: <linux-kernel-owner+w=401wt.eu-S1753977AbYKDFdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbYKDFdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 00:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbYKDFdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 00:33:03 -0500
Received: from cnmailgate04.alcatel-sbell.com.cn ([211.144.215.47]:51145 "EHLO
	cnshjsmin03.cn.alcatel-lucent.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753473AbYKDFdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 00:33:00 -0500
X-AuditID: ac189297-aa780bb000000fe5-09-490fde3f14b5
Message-ID: <490FDE57.3070104@alcatel-lucent.com>
Date: Tue, 04 Nov 2008 13:32:07 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: ipv6: disagrees about version of symbol struct_module
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Nov 2008 05:31:51.0899 (UTC) FILETIME=[A41C6AB0:01C93E3E]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm using 2.6.21 kernel. When it boots from target board, it always
complained that "ipv6: disagrees about version of symbol struct_module".
It seems the modules on target didn't matches the running kernel. I
probably need to compile all modules together with the kernel and copy
them to target board. However, I'm not sure there has any way to change
.config to resolve such kind of problems?

INIT: version 2.86 booting
Starting the hotplug events dispatcher: udevd.
Synthesizing the initial hotplug events...done.
Waiting for /dev to be fully populated...done.
Activating swap...done.
Remounting root filesystem...EXT3 FS on hdc5, internal journal
done.
/sbin/hotplug is not symlinked to /sbin/uSDE/uSDE-hotplug!
Calculating module dependencies
Loading modules:
Checking all file systems: fsck
fsck 1.40 (29-Jun-2007)
Mounting local filesystems: mount nothing was mounted
Checking SELinux contexts: selinux-basics.
Setting up networking ....
Starting network interfaces: done.
Starting hotplug subsystem:
   pci     
   pci      [success]
   usb     
   usb      [success]
   isapnp  
   isapnp   [success]
   ide     
   ide      [success]
   input   
   input    [success]
   scsi    
   scsi     [success]
done.
Starting portmap daemon....
Cleaning: /tmp /var/lock /var/run find: paths must precede expression
Usage: find [-H] [-L] [-P] [path...] [expression]
done.
Setting pseudo-terminal access permissions...done.
Updating /etc/motd...done.
INIT: Entering runlevel: 3
Starting irqbalance.
Starting system log daemon: syslogdipv6: disagrees about version of 
symbol struct_module
 klogd.
Starting auditd:
Starting NFS common utilities: statd.
Starting internet superserver: inetd.
Starting OpenBSD Secure Shell server: sshdipv6: disagrees about version 
of symbol struct_module
ipv6: disagrees about version of symbol struct_module
.
