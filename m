Return-Path: <linux-kernel-owner+w=401wt.eu-S1759816AbYJIOVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759816AbYJIOVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 10:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbYJIOVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 10:21:21 -0400
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3991 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbYJIOVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 10:21:20 -0400
Date: Thu, 9 Oct 2008 16:21:16 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: linux-kernel@vger.kernel.org
Subject: [2.6.25 Power5 64bit] Unable to handle kernel paging request
Message-ID: <20081009142115.GD28224@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Reply-By: Fri Oct 10 14:44:58 CEST 2008
X-Message-Flag: www.unixexpert.nl
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Same server as previous message: power5 with debian running in an lpar,
8 virtual processors (4 physical), 4GB ram.

[1472694.280673] Unable to handle kernel paging request for data at address 0x7fa4eb7838a01103
[1472694.280700] Faulting instruction address: 0xc00000000007aa0c
[1472694.280715] Oops: Kernel access of bad area, sig: 11 [#1]
[1472694.280725] SMP NR_CPUS=32 NUMA pSeries
[1472694.280743] Modules linked in: windfarm_cpufreq_clamp(+) i2c_powermac windfarm_max6690_sensor isofs nls_base windfarm_pid zlib_inflate windfarm_lm75_sensor sr_mod atkbd libps2 ibmveth ipv6 dm_mod serio ext3 jbd mbcache cdrom sd_mod ibmvscsic scsi_transport_srp scsi_tgt scsi_mod windfarm_smu_sat windfarm_core [last unloaded: dm_mirror]
[1472694.280915] NIP: c00000000007aa0c LR: c00000000007b030 CTR: c0000000002c0144
[1472694.280929] REGS: c0000000fc3a3840 TRAP: 0300   Not tainted  (2.6.25-2-powerpc64)
[1472694.280944] MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 22022424  XER: 20000001
[1472694.280986] DAR: 7fa4eb7838a01103, DSISR: 0000000040000000
[1472694.281005] TASK = c0000000fbfd4ad0[9291] 'modprobe' THREAD: c0000000fc3a0000 CPU: 4
[1472694.281022] GPR00: 0000000000000000 c0000000fc3a3ac0 c000000000549a30 d00000000002cf30
[1472694.281065] GPR04: d0000000000daf28 c000000002b96172 ffffffffffffffff 0000000000000001
[1472694.281095] GPR08: c000000000495130 000000007c601b79 c000000002b98151 7fa4eb7838a010f3
[1472694.281124] GPR12: d0000000000da380 c0000000004a2c80 d00000000004b340 0000000000000000
[1472694.281193] GPR16: d00000000004b300 0000000000000009 000000000000003a d0000000000da728
[1472694.281246] GPR20: d00000000004ab04 000000000000003a 0000000000000000 d000000000049000
[1472694.281246] GPR24: 000000000000001e d00000000004ac00 000000000000001f d0000000000daf80
[1472694.281246] GPR28: c0000000004cc1f0 c0000000004cc208 c0000000004e89d8 d0000000000daf28
[1472694.281246] NIP [c00000000007aa0c] .notifier_chain_register+0x8/0x38
[1472694.281246] LR [c00000000007b030] .blocking_notifier_chain_register+0x74/0xa8
[1472694.281246] Call Trace:
[1472694.281246] [c0000000fc3a3ac0] [c00000000007b020] .blocking_notifier_chain_register+0x64/0xa8 (unreliable)
[1472694.281246] [c0000000fc3a3b50] [c0000000002c0194] .cpufreq_register_notifier+0x50/0x68
[1472694.281246] [c0000000fc3a3bd0] [d0000000000da1c8] .wf_cpufreq_clamp_init+0x80/0x298 [windfarm_cpufreq_clamp]
[1472694.281246] [c0000000fc3a3c50] [c0000000000899ec] .sys_init_module+0x1960/0x1b38
[1472694.281246] [c0000000fc3a3e30] [c00000000000872c] syscall_exit+0x0/0x40
[1472694.281246] Instruction dump:
[1472694.281246] f87d0008 3003ffff 7c000110 7803efa6 78631f64 e8010010 eba1ffe8 ebc1fff0
[1472694.281246] 7c0803a6 4e800020 48000018 80040010 <812b0010> 7f804800 419d0014 386b0008
[1472694.285256] ---[ end trace 98c094827db1c6bd ]---


Folkert van Heusden

-- 

Multitail - gibkaja utilita po sledovaniju log-fajlov i vyvoda
kommand. Fil'trovanie, raskrašivanie, slijanie, vizual'noe sravnenie,
i t.d.  http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
