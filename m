Return-Path: <linux-kernel-owner+w=401wt.eu-S1756443Ab0AMVPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab0AMVPF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 16:15:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755784Ab0AMVPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 16:15:04 -0500
Received: from lider.pardus.org.tr ([193.140.100.216]:36289 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755599Ab0AMVPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 16:15:03 -0500
Message-ID: <4B4E37D7.3010706@pardus.org.tr>
Date: Wed, 13 Jan 2010 23:15:03 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Thomas Voegtle <tv@lio96.de>, Jan Kara <jack@suse.cz>,
       "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org, dmonakhov@openvz.org
Subject: Re: Linux 2.6.31.10
References: <20100106234533.GC1960@kroah.com> <alpine.LNX.2.00.1001071522480.5426@er-systems.de> <20100107180449.GA17495@suse.de> <alpine.LNX.2.00.1001072033301.26784@er-systems.de> <20100107194131.GA22983@suse.de> <alpine.LNX.2.00.1001072125040.26784@er-systems.de> <alpine.LNX.2.00.1001072141340.26784@er-systems.de> <20100107220213.GA24882@suse.de>
In-Reply-To: <20100107220213.GA24882@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Jan 07, 2010 at 09:42:52PM +0100, Thomas Voegtle wrote:
>> On Thu, 7 Jan 2010, Thomas Voegtle wrote:
>>


>> ------------[ cut here ]------------
>> kernel BUG at fs/quota/dquot.c:1350!
>> invalid opcode: 0000 [#1]
>> last sysfs file: /sys/devices/pci0000:00/0000:00:1f.5/modalias
>>
>> Pid: 3061, comm: rpm Not tainted 2.6.33-rc3-BIG #73 P3TSSA/P3TSSA
>> EIP: 0060:[<c10c05d8>] EFLAGS: 00010246 CPU: 0
>> EIP is at inode_reserved_space+0x13/0x1b
>> EAX: cf25b5c4 EBX: cf25b5c4 ECX: 00000000 EDX: 00000000
>> ESI: cf25b5c4 EDI: 00000000 EBP: d3536ebc ESP: d3536ebc
>>  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
>> Process rpm (pid: 3061, ti=d3536000 task=d5c50000 task.ti=d3536000)
>> Stack:
>>  d3536f1c c10c246a d79a4b00 d3536edc c10a4884 d3536ef4 c10c1fea 00000000
>> <0> 00000000 00000000 00000064 cf25b5c4 cf25b5c4 d701c800 d3536f1c 00000000
>> <0> d766b000 00000000 00000000 d766b0a0 0000b140 cf25b5c4 d3536f58 ffffff86
>> Call Trace:
>>  [<c10c246a>] ? dquot_transfer+0xf2/0x48b
>>  [<c10a4884>] ? mntput_no_expire+0x19/0x6c
>>  [<c10c1fea>] ? dqget+0x210/0x260
>>  [<c10c05aa>] ? vfs_dq_transfer+0x5f/0x7a
>>  [<c10a2edd>] ? notify_change+0x177/0x25e
>>  [<c10930c8>] ? chown_common+0x5e/0x70
>>  [<c10931fe>] ? sys_lchown+0x3d/0x58
>>  [<c10212a7>] ? sysenter_do_call+0x12/0x2c
>> Code: c0 0f b6 c0 eb 02 31 c0 5b 5e 5d c3 a8 08 75 b0 eb f4 a8 08 75 c9 eb 
>> d5 55 8b 90 90 00 00 00 89 e5 8b 52 24 8b 52 44 85 d2 75 04 <0f> 0b eb fe 
>> ff d2 5d c3 55 89 e5 57 89 c7 56 53 83 ec 1c 8b 35
>> EIP: [<c10c05d8>] inode_reserved_space+0x13/0x1b SS:ESP 0068:d3536ebc
>> ---[ end trace 0cbcf5a4693c0845 ]---
> 
> Well, that's good, at least things are now consistant :)
> 


This causes kernel panic upon boot on one of our users' ext3 system (on 2.6.31.11) so I think 2.6.30.y deserves another
stable update to fix this critical issue.

Regards,

Ozan Caglayan
Pardus Linux -- http://www.pardus.org.tr/eng
