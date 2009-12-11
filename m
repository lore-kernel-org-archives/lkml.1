Return-Path: <linux-kernel-owner+w=401wt.eu-S1761536AbZLKVjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761536AbZLKVjI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 16:39:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758502AbZLKVjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 16:39:04 -0500
Received: from mail.fem.tu-ilmenau.de ([141.24.101.79]:38201 "EHLO
	mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758218AbZLKVjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 16:39:04 -0500
From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: K8 ECC error with linux-2.6.32
Date: Fri, 11 Dec 2009 22:39:04 +0100
User-Agent: KMail/1.13.0 (Linux/2.6.32-fglrx; KDE/4.3.80; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <200912112202.48173.johannes.hirte@fem.tu-ilmenau.de> <20091211211938.GB6246@liondog.tnic>
In-Reply-To: <20091211211938.GB6246@liondog.tnic>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200912112239.05446.johannes.hirte@fem.tu-ilmenau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 11 Dezember 2009 22:19:38 schrieb Borislav Petkov:
> On Fri, Dec 11, 2009 at 10:02:47PM +0100, Johannes Hirte wrote:
> > With kernel 2.6.32 I get now:
> >
> > Dec 11 21:26:37 datengrab kernel: Northbridge Error, node 0, core: -1
> > Dec 11 21:26:37 datengrab kernel: K8 ECC error.
> 
> Is that all, i.e. do you have anything else in the logs. For example, a
> line which contains "MC?_STATUS: ..." or similar. 

No, nothing else. 

> Please send the whole
> dmesg.

It's the log from syslog-ng, but with all dmesg log captured.

An example with radeon + KMS:

Dec  8 01:10:01 datengrab cron[26215]: (root) CMD (test -x /usr/sbin/run-crons 
&& /usr/sbin/run-crons )
Dec  8 01:18:27 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 01:18:27 datengrab kernel: K8 ECC error.
Dec  8 01:20:01 datengrab cron[26305]: (root) CMD (test -x /usr/sbin/run-crons 
&& /usr/sbin/run-crons )
Dec  8 01:20:14 datengrab smartd[2455]: Device: /dev/sdb, Temperature changed 
-1 Celsius to 36 Celsius (Min/Max 36!/43)
Dec  8 01:21:14 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 01:21:14 datengrab kernel: K8 ECC error.
Dec  8 01:21:15 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 01:21:15 datengrab kernel: K8 ECC error.
Dec  8 01:21:30 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 01:21:30 datengrab kernel: K8 ECC error.
Dec  8 01:30:02 datengrab cron[27612]: (root) CMD (test -x /usr/sbin/run-crons 
&& /usr/sbin/run-crons )
Dec  8 01:40:01 datengrab cron[27664]: (root) CMD (test -x /usr/sbin/run-crons 
&& /usr/sbin/run-crons )
Dec  8 01:45:48 datengrab su[1187]: Successful su for root by puck
Dec  8 01:45:48 datengrab su[1187]: + /dev/pts/2 puck:root
Dec  8 01:45:48 datengrab su[1187]: pam_unix(su:session): session opened for 
user root by puck(uid=1002)
Dec  8 01:50:01 datengrab cron[5949]: (root) CMD (test -x /usr/sbin/run-crons 
&& /usr/sbin/run-crons )
Dec  8 01:50:13 datengrab smartd[2455]: Device: /dev/sdb, Temperature changed 
-1 Celsius to 35 Celsius (Min/Max 35!/43)
Dec  8 01:52:27 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 01:52:27 datengrab kernel: K8 ECC error.
Dec  8 01:52:29 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 01:52:29 datengrab kernel: K8 ECC error.
Dec  8 01:52:30 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 01:52:30 datengrab kernel: K8 ECC error.
Dec  8 01:52:31 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 01:52:31 datengrab kernel: K8 ECC error.
Dec  8 01:52:33 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 01:52:33 datengrab kernel: K8 ECC error.
Dec  8 01:52:35 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 01:52:35 datengrab kernel: K8 ECC error.
Dec  8 01:52:36 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 01:52:36 datengrab kernel: K8 ECC error.
Dec  8 01:52:37 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 01:52:37 datengrab kernel: K8 ECC error.
Dec  8 01:52:39 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 01:52:39 datengrab kernel: K8 ECC error.
Dec  8 01:52:40 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 01:52:40 datengrab kernel: K8 ECC error.
Dec  8 01:52:42 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 01:52:42 datengrab kernel: K8 ECC error.
Dec  8 01:52:43 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 01:52:43 datengrab kernel: K8 ECC error.
Dec  8 01:52:44 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 01:52:44 datengrab kernel: K8 ECC error.
Dec  8 01:52:47 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 01:52:47 datengrab kernel: K8 ECC error.
Dec  8 01:52:48 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 01:52:48 datengrab kernel: K8 ECC error.
Dec  8 01:52:51 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 01:52:51 datengrab kernel: K8 ECC error.
Dec  8 01:52:53 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 01:52:53 datengrab kernel: K8 ECC error.
Dec  8 01:52:56 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 01:52:56 datengrab kernel: K8 ECC error.
Dec  8 01:52:57 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 01:52:57 datengrab kernel: K8 ECC error.
Dec  8 01:52:58 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 01:52:58 datengrab kernel: K8 ECC error.
Dec  8 01:53:00 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 01:53:00 datengrab kernel: K8 ECC error.
Dec  8 01:53:01 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 01:53:01 datengrab kernel: K8 ECC error.
Dec  8 01:53:29 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 01:53:29 datengrab kernel: K8 ECC error.
Dec  8 01:53:30 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 01:53:30 datengrab kernel: K8 ECC error.
Dec  8 01:55:13 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 01:55:13 datengrab kernel: K8 ECC error.
Dec  8 01:57:38 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 01:57:38 datengrab kernel: K8 ECC error.
Dec  8 01:58:05 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 01:58:05 datengrab kernel: K8 ECC error.
Dec  8 01:58:06 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 01:58:06 datengrab kernel: K8 ECC error.
Dec  8 01:58:36 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 01:58:36 datengrab kernel: K8 ECC error.
Dec  8 01:58:37 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 01:58:37 datengrab kernel: K8 ECC error.
Dec  8 01:58:38 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 01:58:38 datengrab kernel: K8 ECC error.
Dec  8 01:59:11 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 01:59:11 datengrab kernel: K8 ECC error.
Dec  8 01:59:36 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 01:59:36 datengrab kernel: K8 ECC error.
Dec  8 01:59:48 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 01:59:48 datengrab kernel: K8 ECC error.
Dec  8 02:00:01 datengrab cron[13736]: (root) CMD (rm -f 
/var/spool/cron/lastrun/cron.hourly)
Dec  8 02:00:01 datengrab cron[13737]: (root) CMD (test -x /usr/sbin/run-crons 
&& /usr/sbin/run-crons )
Dec  8 02:00:20 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 02:00:20 datengrab kernel: K8 ECC error.
Dec  8 02:00:26 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 02:00:26 datengrab kernel: K8 ECC error.
Dec  8 02:00:29 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 02:00:29 datengrab kernel: K8 ECC error.
Dec  8 02:00:36 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 02:00:36 datengrab kernel: K8 ECC error.
Dec  8 02:00:58 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 02:00:58 datengrab kernel: K8 ECC error.
Dec  8 02:01:04 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 02:01:04 datengrab kernel: K8 ECC error.
Dec  8 02:01:26 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 02:01:26 datengrab kernel: K8 ECC error.
Dec  8 02:01:28 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 02:01:28 datengrab kernel: K8 ECC error.
Dec  8 02:01:29 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 02:01:29 datengrab kernel: K8 ECC error.
Dec  8 02:01:32 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 02:01:32 datengrab kernel: K8 ECC error.
Dec  8 02:01:35 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 02:01:35 datengrab kernel: K8 ECC error.
Dec  8 02:01:43 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 02:01:43 datengrab kernel: K8 ECC error.
Dec  8 02:01:48 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 02:01:48 datengrab kernel: K8 ECC error.
Dec  8 02:01:53 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 02:01:53 datengrab kernel: K8 ECC error.
Dec  8 02:02:05 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 02:02:05 datengrab kernel: K8 ECC error.
Dec  8 02:02:09 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 02:02:09 datengrab kernel: K8 ECC error.
Dec  8 02:02:10 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 02:02:10 datengrab kernel: K8 ECC error.
Dec  8 02:02:21 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 02:02:21 datengrab kernel: K8 ECC error.
Dec  8 02:02:26 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 02:02:26 datengrab kernel: K8 ECC error.
Dec  8 02:02:44 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 02:02:44 datengrab kernel: K8 ECC error.
Dec  8 02:03:19 datengrab kernel: Northbridge Error, node 0, core: -1
Dec  8 02:03:19 datengrab kernel: K8 ECC error.
Dec  8 02:09:36 datengrab su[7764]: pam_unix(su:session): session closed for 
user root
Dec  8 02:09:37 datengrab su[1187]: pam_unix(su:session): session closed for 
user root
Dec  8 02:09:46 datengrab kdm: :0[7528]: pam_unix(kde:session): session closed 
for user puck
Dec  8 02:09:47 datengrab acpid: client 7525[0:0] has disconnected
Dec  8 02:09:47 datengrab acpid: client connected from 7525[0:0]
Dec  8 02:09:47 datengrab acpid: 1 client rule loaded
Dec  8 02:09:51 datengrab kernel: Unpin not necessary for ffff880045e68200 !
Dec  8 02:10:01 datengrab cron[14051]: (root) CMD (test -x /usr/sbin/run-crons 
&& /usr/sbin/run-crons )
Dec  8 02:10:16 datengrab ntpd[2264]: synchronized to 217.79.182.184, stratum 
2
Dec  8 02:10:20 datengrab shutdown[14063]: shutting down for system reboot
Dec  8 02:10:24 datengrab init: Switching to runlevel: 6
Dec  8 02:10:27 datengrab sshd[2474]: Received signal 15; terminating.
Dec  8 02:10:27 datengrab smartd[2455]: smartd received signal 15: Terminated
Dec  8 02:10:27 datengrab smartd[2455]: smartd is exiting (exit status 0)
Dec  8 02:10:31 datengrab kernel: nfsd: last server has exited, flushing export 
cache
Dec  8 02:10:31 datengrab mountd[2410]: Caught signal 15, un-registering and 
exiting.
Dec  8 02:10:31 datengrab rpc.statd[2361]: Caught signal 15, un-registering 
and exiting.
Dec  8 02:10:32 datengrab ntpd[2264]: ntpd exiting on signal 15
Dec  8 02:10:33 datengrab acpid: exiting
Dec  8 02:10:34 datengrab syslog-ng[1971]: Termination requested via signal, 
terminating;
Dec  8 02:10:34 datengrab syslog-ng[1971]: syslog-ng shutting down; 
version='3.0.4'

and an example with fgrlx:

Dec 11 21:18:01 datengrab acpid: 1 client rule loaded
Dec 11 21:18:02 datengrab kernel: [fglrx] AGP detected, AgpState   = 
0x1f000b3b (hardware caps of chipset)
Dec 11 21:18:02 datengrab kernel: [fglrx] [agp] enabling AGP with 
mode=0x1f000b3a
Dec 11 21:18:02 datengrab kernel: agpgart-amd64 0000:00:00.0: AGP 3.0 bridge
Dec 11 21:18:02 datengrab kernel: agpgart-amd64 0000:00:00.0: putting AGP V3 
device into 8x mode
Dec 11 21:18:02 datengrab kernel: pci 0000:01:00.0: putting AGP V3 device into 
8x mode
Dec 11 21:18:02 datengrab kernel: [fglrx] AGP enabled,  AgpCommand = 
0x1f000312 (selected caps)
Dec 11 21:18:02 datengrab kernel: [fglrx] Setup AGP aperture
Dec 11 21:18:02 datengrab kernel: Northbridge Error, node 0, core: -1
Dec 11 21:18:02 datengrab kernel: K8 ECC error.
Dec 11 21:18:03 datengrab kernel: [fglrx] Could not enable MSI; System 
prevented initialization
Dec 11 21:18:03 datengrab kernel: [fglrx] Firegl kernel thread PID: 2556
Dec 11 21:18:04 datengrab kernel: [fglrx] Gart cacheable size:1316 M.
Dec 11 21:18:04 datengrab kernel: [fglrx] Reserved FB block: Shared offset:0, 
size:1000000
Dec 11 21:18:04 datengrab kernel: [fglrx] Reserved FB block: Unshared 
offset:fd0b000, size:2f5000
Dec 11 21:18:04 datengrab kernel: [fglrx] Reserved FB block: Unshared 
offset:1fffb000, size:5000
Dec 11 21:18:15 datengrab kdm: :0[2558]: pam_unix(kde:session): session opened 
for user puck by (uid=0)
Dec 11 21:20:01 datengrab kdm: :0[2558]: pam_unix(kde:session): session closed 
for user puck
Dec 11 21:20:01 datengrab cron[2779]: (root) CMD (test -x /usr/sbin/run-crons 
&& /usr/sbin/run-crons )
Dec 11 21:20:02 datengrab acpid: client 2553[0:0] has disconnected
Dec 11 21:20:02 datengrab acpid: client connected from 2553[0:0]
Dec 11 21:20:02 datengrab acpid: 1 client rule loaded
Dec 11 21:20:09 datengrab shutdown[2807]: shutting down for system reboot
Dec 11 21:20:12 datengrab init: Switching to runlevel: 6
Dec 11 21:20:16 datengrab sshd[2458]: Received signal 15; terminating.
Dec 11 21:20:16 datengrab smartd[2444]: smartd received signal 15: Terminated
Dec 11 21:20:16 datengrab smartd[2444]: smartd is exiting (exit status 0)
Dec 11 21:20:16 datengrab ntpd[2255]: ntpd exiting on signal 15
Dec 11 21:20:19 datengrab mountd[2399]: Caught signal 15, un-registering and 
exiting.
Dec 11 21:20:20 datengrab kernel: nfsd: last server has exited, flushing export 
cache
Dec 11 21:20:20 datengrab rpc.statd[2350]: Caught signal 15, un-registering 
and exiting.
Dec 11 21:20:21 datengrab acpid: exiting
Dec 11 21:20:21 datengrab syslog-ng[1963]: Termination requested via signal, 
terminating;
Dec 11 21:20:21 datengrab syslog-ng[1963]: syslog-ng shutting down; 
version='3.0.4'


regards,
  Johannes
