Return-Path: <linux-kernel-owner+w=401wt.eu-S1756526AbYJGBgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526AbYJGBgZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 21:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754092AbYJGBgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 21:36:17 -0400
Received: from ishtar.tlinx.org ([64.81.245.74]:50000 "EHLO ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243AbYJGBgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 21:36:16 -0400
Message-ID: <48EABD07.6030506@tlinx.org>
Date: Mon, 06 Oct 2008 18:36:07 -0700
From: Linda Walsh <smartmontools@tlinx.org>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Smartmontools Mailing List 
	<smartmontools-support@lists.sourceforge.net>,
       Bruce Allen <ballen@gravity.phys.uwm.edu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [smartmontools-support] inactive SATA drives won't stay in standby
 or sleep, PATA models did. (fwd)
References: <Pine.LNX.4.64.0809142159550.18213@gc.phys.uwm.edu> <48E1B8F8.3090205@gmail.com> <48E26BDA.8080804@tlinx.org> <48E26E61.2010705@gmail.com> <48E34BC8.3050009@tlinx.org> <48E6DE07.70706@gmail.com> <48EAAF2E.4060407@tlinx.org> <48EAB672.3010209@gmail.com>
In-Reply-To: <48EAB672.3010209@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Controller is a Promise TX4/300
Is this what you were looking for?:

Oct  6 16:59:14 ish kernel: ata2.00: exception Emask 0x0 SAct 0x0 SErr 
0x0 action 0x6 frozen
Oct  6 16:59:14 ish kernel: ata2.00: cmd 
b0/da:00:00:4f:c2/00:00:00:00:00/00 tag 0
Oct  6 16:59:14 ish kernel:          res 
40/00:01:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct  6 16:59:14 ish kernel: ata2.00: status: { DRDY }
Oct  6 16:59:20 ish kernel: ata2: link is slow to respond, please be 
patient (ready=-19)
Oct  6 16:59:24 ish kernel: ata2: COMRESET failed (errno=-16)
Oct  6 16:59:30 ish kernel: ata2: link is slow to respond, please be 
patient (ready=-19)
Oct  6 16:59:34 ish kernel: ata2: COMRESET failed (errno=-16)
Oct  6 16:59:40 ish kernel: ata2: link is slow to respond, please be 
patient (ready=-19)
Oct  6 17:00:09 ish kernel: ata2: COMRESET failed (errno=-16)
Oct  6 17:00:09 ish kernel: ata2: limiting SATA link speed to 1.5 Gbps
Oct  6 17:00:14 ish dhcpd: Forward map from ns1.sc.tlinx.org to 
192.168.3.242 FAILED: Has an A record but no DHCID, not mine.
Oct  6 17:00:15 ish kernel: ata2: COMRESET failed (errno=-16)
Oct  6 17:00:15 ish kernel: ata2: reset failed, giving up
Oct  6 17:00:15 ish kernel: ata2.00: disabled
Oct  6 17:00:15 ish kernel: ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 
action 0xe frozen t4
Oct  6 17:00:15 ish kernel: ata2: hotplug_status 0x22
Oct  6 17:00:20 ish kernel: ata2: link is slow to respond, please be 
patient (ready=-19)
Oct  6 17:00:25 ish kernel: ata2: COMRESET failed (errno=-16)
Oct  6 17:00:30 ish kernel: ata2: link is slow to respond, please be 
patient (ready=-19)
Oct  6 17:00:35 ish kernel: ata2: COMRESET failed (errno=-16)
Oct  6 17:00:40 ish kernel: ata2: link is slow to respond, please be 
patient (ready=-19)
Oct  6 17:01:10 ish kernel: ata2: COMRESET failed (errno=-16)
Oct  6 17:01:10 ish kernel: ata2: limiting SATA link speed to 1.5 Gbps
Oct  6 17:01:15 ish kernel: ata2: COMRESET failed (errno=-16)
Oct  6 17:01:15 ish kernel: ata2: reset failed, giving up
Oct  6 17:01:15 ish kernel: ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 
action 0xe frozen t3
Oct  6 17:01:15 ish kernel: ata2: hotplug_status 0x22
Oct  6 17:01:20 ish kernel: ata2: link is slow to respond, please be 
patient (ready=-19)
Oct  6 17:01:25 ish kernel: ata2: COMRESET failed (errno=-16)
Oct  6 17:01:30 ish kernel: ata2: link is slow to respond, please be 
patient (ready=-19)
Oct  6 17:01:35 ish kernel: ata2: COMRESET failed (errno=-16)
Oct  6 17:01:40 ish kernel: ata2: link is slow to respond, please be 
patient (ready=-19)
Oct  6 17:02:10 ish kernel: ata2: COMRESET failed (errno=-16)
Oct  6 17:02:10 ish kernel: ata2: limiting SATA link speed to 1.5 Gbps
Oct  6 17:02:15 ish kernel: ata2: COMRESET failed (errno=-16)
Oct  6 17:02:15 ish kernel: ata2: reset failed, giving up
Oct  6 17:02:15 ish kernel: ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 
action 0xe frozen t2
Oct  6 17:02:15 ish kernel: ata2: hotplug_status 0x22
Oct  6 17:02:21 ish kernel: ata2: link is slow to respond, please be 
patient (ready=-19)
Oct  6 17:02:25 ish kernel: ata2: COMRESET failed (errno=-16)
Oct  6 17:02:31 ish kernel: ata2: link is slow to respond, please be 
patient (ready=-19)
Oct  6 17:02:35 ish kernel: ata2: COMRESET failed (errno=-16)
Oct  6 17:02:41 ish kernel: ata2: link is slow to respond, please be 
patient (ready=-19)
Oct  6 17:03:01 ish sshd[4020]: error: channel 0: chan_read_failed for 
istate 3
Oct  6 17:03:10 ish syslog-ng[13177]: last message repeated 2 times
Oct  6 17:03:10 ish kernel: ata2: COMRESET failed (errno=-16)
Oct  6 17:03:10 ish kernel: ata2: limiting SATA link speed to 1.5 Gbps
Oct  6 17:03:15 ish kernel: ata2: COMRESET failed (errno=-16)
Oct  6 17:03:15 ish kernel: ata2: reset failed, giving up
Oct  6 17:03:15 ish kernel: ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 
action 0xe frozen t1
Oct  6 17:03:15 ish kernel: ata2: hotplug_status 0x22
Oct  6 17:03:21 ish kernel: ata2: link is slow to respond, please be 
patient (ready=-19)
Oct  6 17:03:25 ish kernel: ata2: COMRESET failed (errno=-16)
Oct  6 17:03:31 ish kernel: ata2: link is slow to respond, please be 
patient (ready=-19)
Oct  6 17:03:35 ish kernel: ata2: COMRESET failed (errno=-16)
Oct  6 17:03:41 ish kernel: ata2: link is slow to respond, please be 
patient (ready=-19)
Oct  6 17:04:10 ish kernel: ata2: COMRESET failed (errno=-16)
Oct  6 17:04:10 ish kernel: ata2: limiting SATA link speed to 1.5 Gbps
Oct  6 17:04:15 ish kernel: ata2: COMRESET failed (errno=-16)
Oct  6 17:04:15 ish kernel: ata2: reset failed, giving up
Oct  6 17:04:15 ish kernel: ata2: EH pending after 5 tries, giving up
Oct  6 17:04:15 ish kernel: sd 2:0:0:0: rejecting I/O to offline device
Oct  6 17:04:15 ish kernel: program smartctl is using a deprecated SCSI 
ioctl, please convert it to SG_IO
Oct  6 17:04:15 ish kernel: sd 2:0:0:0: [sdc] START_STOP FAILED
Oct  6 17:04:33 ish kernel: Filesystem "sdc1": xfs_log_force: error 5 
returned.
Oct  6 17:04:33 ish kernel: Filesystem "sdc1": xfs_log_force: error 5 
returned.
Oct  6 17:05:45 ish kernel: Filesystem "sdc1": xfs_log_force: error 5 
returned.
Oct  6 17:05:45 ish kernel: Filesystem "sdc1": xfs_log_force: error 5 
returned.
Oct  6 17:06:31 ish kernel: Filesystem "sdc1": xfs_log_force: error 5 
returned.
Oct  6 17:07:30 ish syslog-ng[13177]: last message repeated 2 times
Oct  6 17:07:33 ish kernel: Filesystem "sdc1": xfs_log_force: error 5 
returned.
Oct  6 17:07:33 ish kernel: Filesystem "sdc1": xfs_log_force: error 5 
returned.
Oct  6 17:08:32 ish kernel: ata1.00: exception Emask 0x0 SAct 0x0 SErr 
0x0 action 0x6 frozen
Oct  6 17:08:32 ish kernel: ata1.00: cmd 
b0/da:00:00:4f:c2/00:00:00:00:00/00 tag 0
Oct  6 17:08:32 ish kernel:          res 
40/00:01:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct  6 17:08:32 ish kernel: ata1.00: status: { DRDY }
Oct  6 17:08:38 ish kernel: ata1: link is slow to respond, please be 
patient (ready=-19)
Oct  6 17:08:42 ish kernel: ata1: COMRESET failed (errno=-16)
Oct  6 17:08:45 ish kernel: Filesystem "sdc1": xfs_log_force: error 5 
returned.
Oct  6 17:08:48 ish kernel: ata1: link is slow to respond, please be 
patient (ready=-19)
Oct  6 17:08:52 ish kernel: ata1: COMRESET failed (errno=-16)
Oct  6 17:08:58 ish kernel: ata1: link is slow to respond, please be 
patient (ready=-19)
Oct  6 17:09:21 ish kernel: Filesystem "sdc1": xfs_log_force: error 5 
returned.
Oct  6 17:09:27 ish kernel: ata1: COMRESET failed (errno=-16)
Oct  6 17:09:27 ish kernel: ata1: limiting SATA link speed to 1.5 Gbps
Oct  6 17:09:32 ish kernel: ata1: COMRESET failed (errno=-16)
Oct  6 17:09:32 ish kernel: ata1: reset failed, giving up
Oct  6 17:09:32 ish kernel: ata1.00: disabled
Oct  6 17:09:32 ish kernel: ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 
action 0xe frozen t4
Oct  6 17:09:32 ish kernel: ata1: hotplug_status 0x88
Oct  6 17:09:38 ish kernel: ata1: link is slow to respond, please be 
patient (ready=-19)
Oct  6 17:09:42 ish kernel: ata1: COMRESET failed (errno=-16)
Oct  6 17:09:48 ish kernel: ata1: link is slow to respond, please be 
patient (ready=-19)
Oct  6 17:09:52 ish kernel: ata1: COMRESET failed (errno=-16)
Oct  6 17:09:57 ish kernel: Filesystem "sdc1": xfs_log_force: error 5 
returned.
Oct  6 17:09:58 ish kernel: ata1: link is slow to respond, please be 
patient (ready=-19)
Oct  6 17:10:27 ish kernel: ata1: COMRESET failed (errno=-16)
Oct  6 17:10:27 ish kernel: ata1: limiting SATA link speed to 1.5 Gbps
Oct  6 17:10:32 ish kernel: ata1: COMRESET failed (errno=-16)
Oct  6 17:10:32 ish kernel: ata1: reset failed, giving up
Oct  6 17:10:32 ish kernel: ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 
action 0xe frozen t3
Oct  6 17:10:32 ish kernel: ata1: hotplug_status 0x88
Oct  6 17:10:33 ish kernel: Filesystem "sdc1": xfs_log_force: error 5 
returned.
Oct  6 17:10:38 ish kernel: ata1: link is slow to respond, please be 
patient (ready=-19)
Oct  6 17:10:42 ish kernel: ata1: COMRESET failed (errno=-16)
Oct  6 17:10:48 ish kernel: ata1: link is slow to respond, please be 
patient (ready=-19)
Oct  6 17:10:52 ish kernel: ata1: COMRESET failed (errno=-16)
Oct  6 17:10:58 ish kernel: ata1: link is slow to respond, please be 
patient (ready=-19)
Oct  6 17:11:09 ish kernel: Filesystem "sdc1": xfs_log_force: error 5 
returned.
Oct  6 17:11:27 ish kernel: ata1: COMRESET failed (errno=-16)
Oct  6 17:11:27 ish kernel: ata1: limiting SATA link speed to 1.5 Gbps
Oct  6 17:11:33 ish kernel: ata1: COMRESET failed (errno=-16)
Oct  6 17:11:33 ish kernel: ata1: reset failed, giving up
Oct  6 17:11:33 ish kernel: ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 
action 0xe frozen t2
Oct  6 17:11:33 ish kernel: ata1: hotplug_status 0x88
Oct  6 17:11:38 ish kernel: ata1: link is slow to respond, please be 
patient (ready=-19)
Oct  6 17:11:43 ish kernel: ata1: COMRESET failed (errno=-16)
Oct  6 17:11:45 ish kernel: Filesystem "sdc1": xfs_log_force: error 5 
returned.
Oct  6 17:11:48 ish kernel: ata1: link is slow to respond, please be 
patient (ready=-19)
Oct  6 17:11:53 ish kernel: ata1: COMRESET failed (errno=-16)
Oct  6 17:11:58 ish kernel: ata1: link is slow to respond, please be 
patient (ready=-19)
Oct  6 17:12:17 ish xinetd[2021]: Exiting...
Oct  6 17:12:17 ish kernel: nfsd: last server has exited
Oct  6 17:12:17 ish kernel: nfsd: unexporting all filesystems
Oct  6 17:12:17 ish apcupsd[1989]: apcupsd exiting, signal 15
Oct  6 17:12:17 ish apcupsd[1989]: apcupsd shutdown succeeded
Oct  6 17:12:17 ish rpc.statd[2074]: Caught signal 15, un-registering 
and exiting.
Oct  6 17:12:17 ish mountd[2075]: Caught signal 15, un-registering and 
exiting.
Oct  6 17:12:21 ish kernel: Filesystem "sdc1": xfs_log_force: error 5 
returned.
Tejun Heo wrote:
> Linda Walsh wrote:
>   
>> So the real problem is why issuing a smart command isn't re-starting
>> the drive -- or bringing it back from standby.  Whereas a "normal" disk
>> read seems to bring it back to normal functioning just fine (and can
>> then do the smart-test).
>>
>> Does this give anyone ideas about where the problem might be?  Also
>> sorta explains why my hangs have been infrequent, because I've been
>> periodically polling the temps of all the drives -- and only when I stop
>> the polling would the drive timeout, then die the next morning when
>> smartd tried to run a short test between 1 and 2 am.
>>     
>
> Sounds like a firmware problem to me.  Issuing ATA_CMD_VERIFY on block
> 0 before issuing test commands should work around the problem.  Also,
> which controller are you using?  Can you post the failing kernel log?
>
>   

