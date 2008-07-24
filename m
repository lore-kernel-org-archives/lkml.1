Return-Path: <linux-kernel-owner+w=401wt.eu-S1751268AbYGXXa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751268AbYGXXa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 19:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756274AbYGXXaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 19:30:01 -0400
Received: from server.drzeus.cx ([85.8.24.28]:58057 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756181AbYGXX3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 19:29:24 -0400
Date: Fri, 25 Jul 2008 01:29:16 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Alex Chiang <achiang@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: post 2.6.26 requires pciehp_slot_with_bus
Message-ID: <20080725012916.06679a6d@mjolnir.drzeus.cx>
In-Reply-To: <20080724230827.GA30302@ldl.fc.hp.com>
References: <20080724134737.4b91f30d@mjolnir.drzeus.cx>
	<200807241407.18543.jbarnes@virtuousgeek.org>
	<20080724235127.40bd0ac9@mjolnir.drzeus.cx>
	<200807241506.58973.jbarnes@virtuousgeek.org>
	<20080724222914.GG5307@ldl.fc.hp.com>
	<20080725004926.5f201c70@mjolnir.drzeus.cx>
	<20080724230827.GA30302@ldl.fc.hp.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-12611-1216942161-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-12611-1216942161-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 24 Jul 2008 17:08:27 -0600
Alex Chiang <achiang@hp.com> wrote:

> Sorry for one more round-trip, but could you turn on debugging
> for pciehp as well?
>=20

Same thing, with debugging:

[    1.247138] pcieport-driver 0000:00:01.0: found MSI capability
[    1.247203] pci_express 0000:00:01.0:pcie00: allocate port service
[    1.247316] pci_express 0000:00:01.0:pcie02: allocate port service
[    1.247425] pci_express 0000:00:01.0:pcie03: allocate port service
[    1.247655] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    1.247803] pcieport-driver 0000:00:1c.0: found MSI capability
[    1.247945] pci_express 0000:00:1c.0:pcie00: allocate port service
[    1.248058] pci_express 0000:00:1c.0:pcie02: allocate port service
[    1.248166] pci_express 0000:00:1c.0:pcie03: allocate port service
[    1.248488] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    1.248635] pcieport-driver 0000:00:1c.1: found MSI capability
[    1.248776] pci_express 0000:00:1c.1:pcie00: allocate port service
[    1.248909] pci_express 0000:00:1c.1:pcie02: allocate port service
[    1.249015] pci_express 0000:00:1c.1:pcie03: allocate port service
[    1.249344] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[    1.249492] pcieport-driver 0000:00:1c.2: found MSI capability
[    1.249633] pci_express 0000:00:1c.2:pcie00: allocate port service
[    1.249743] pci_express 0000:00:1c.2:pcie02: allocate port service
[    1.249852] pci_express 0000:00:1c.2:pcie03: allocate port service
[    1.250175] PCI: Setting latency timer of device 0000:00:1c.3 to 64
[    1.250322] pcieport-driver 0000:00:1c.3: found MSI capability
[    1.250463] pci_express 0000:00:1c.3:pcie00: allocate port service
[    1.250570] pci_express 0000:00:1c.3:pcie02: allocate port service
[    1.250680] pci_express 0000:00:1c.3:pcie03: allocate port service
[    1.251001] PCI: Setting latency timer of device 0000:00:1c.4 to 64
[    1.251148] pcieport-driver 0000:00:1c.4: found MSI capability
[    1.251289] pci_express 0000:00:1c.4:pcie00: allocate port service
[    1.251397] pci_express 0000:00:1c.4:pcie02: allocate port service
[    1.251510] pci_express 0000:00:1c.4:pcie03: allocate port service
[    1.252030] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.252940] pciehp: Hotplug Controller:
[    1.252946] pciehp:   Seg/Bus/Dev/Func/IRQ : 0000:00:01.0 IRQ 223
[    1.252951] pciehp:   Vendor ID            : 0x8086
[    1.252955] pciehp:   Device ID            : 0x2a01
[    1.252959] pciehp:   Subsystem ID         : 0x0000
[    1.252962] pciehp:   Subsystem Vendor ID  : 0x0000
[    1.252966] pciehp:   PCIe Cap offset      : 0xa0
[    1.252972] pciehp:   PCI resource [7]     : 0x1000@0x2000
[    1.252977] pciehp:   PCI resource [8]     : 0x3000000@0xd4000000
[    1.252981] pciehp:   PCI resource [9]     : 0x10000000@0xe0000000
[    1.252986] pciehp: Slot Capabilities      : 0x000c25c0
[    1.252990] pciehp:   Physical Slot Number : 1
[    1.252994] pciehp:   Attention Button     :  no
[    1.252998] pciehp:   Power Controller     :  no
[    1.253002] pciehp:   MRL Sensor           :  no
[    1.253006] pciehp:   Attention Indicator  :  no
[    1.253009] pciehp:   Power Indicator      :  no
[    1.253013] pciehp:   Hot-Plug Surprise    :  no
[    1.253017] pciehp:   EMI Present          :  no
[    1.253020] pciehp:   Comamnd Completed    :  no
[    1.253026] pciehp: Slot Status            : 0x0048
[    1.253031] pciehp: Slot Control           : 0x01c0
[    1.253103] pciehp: HPC vendor_id 8086 device_id 2a01 ss_vid 0 ss_did 0
[    1.253142] pciehp: get_power_status - physical_slot =3D 1
[    1.253149] pciehp: hpc_get_power_status: SLOTCTRL b8 value read 1e8
[    1.253154] pciehp: get_attention_status - physical_slot =3D 1
[    1.253161] pciehp: hpc_get_attention_status: SLOTCTRL b8, value read 1e8
[    1.253166] pciehp: get_latch_status - physical_slot =3D 1
[    1.253172] pciehp: get_adapter_status - physical_slot =3D 1
[    1.253179] pciehp: Registering bus=3D1 dev=3D0 hp_slot=3D0 sun=3D1 slot=
_device_offset=3D0
[    1.253187] Pid: 1, comm: swapper Not tainted 2.6.26 #110
[    1.253193]  [<c0544545>] pci_hp_register+0x25/0x4b0
[    1.253208]  [<c0545e3e>] ? get_adapter_status+0x2e/0x70
[    1.253218]  [<c054631b>] pciehp_probe+0x12b/0x3f0
[    1.253226]  [<c0542110>] pcie_port_probe_service+0x50/0x90
[    1.253235]  [<c04e9b67>] ? sysfs_create_link+0x17/0x20
[    1.253247]  [<c059f42d>] ? driver_sysfs_add+0x5d/0x90
[    1.253256]  [<c059f557>] driver_probe_device+0x87/0x1a0
[    1.253263]  [<c066f841>] ? _spin_lock_irqsave+0x21/0x40
[    1.253274]  [<c066fb66>] ? _spin_unlock_irqrestore+0x16/0x40
[    1.253282]  [<c059f6e9>] __driver_attach+0x79/0x80
[    1.253289]  [<c059ee23>] bus_for_each_dev+0x53/0x80
[    1.253296]  [<c059f3ce>] driver_attach+0x1e/0x20
[    1.253303]  [<c059f670>] ? __driver_attach+0x0/0x80
[    1.253310]  [<c059e7e7>] bus_add_driver+0x1b7/0x230
[    1.253318]  [<c059f8be>] driver_register+0x6e/0x150
[    1.253325]  [<c059f8be>] ? driver_register+0x6e/0x150
[    1.253332]  [<c054202f>] pcie_port_service_register+0x3f/0x50
[    1.253340]  [<c07a7b52>] pcied_init+0x16/0x83
[    1.253350]  [<c07a7b38>] ? pci_hotplug_init+0x1f/0x23
[    1.253359]  [<c078b417>] kernel_init+0x1ad/0x2b8
[    1.253368]  [<c04ae774>] ? sys_select+0x44/0x1a0
[    1.253378]  [<c07a7b3c>] ? pcied_init+0x0/0x83
[    1.253387]  [<c042337f>] ? schedule_tail+0x1f/0x50
[    1.253396]  [<c0403e72>] ? ret_from_fork+0x6/0x1c
[    1.253405]  [<c078b26a>] ? kernel_init+0x0/0x2b8
[    1.253413]  [<c078b26a>] ? kernel_init+0x0/0x2b8
[    1.253421]  [<c0404b9b>] kernel_thread_helper+0x7/0x10
[    1.253429]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[    1.253543] hpdriver 0000:00:01.0:pcie02: service driver hpdriver loaded
[    1.254331] pciehp: Hotplug Controller:
[    1.254337] pciehp:   Seg/Bus/Dev/Func/IRQ : 0000:00:1c.0 IRQ 222
[    1.254342] pciehp:   Vendor ID            : 0x8086
[    1.254346] pciehp:   Device ID            : 0x283f
[    1.254350] pciehp:   Subsystem ID         : 0x0000
[    1.254353] pciehp:   Subsystem Vendor ID  : 0x0000
[    1.254358] pciehp:   PCIe Cap offset      : 0x40
[    1.254363] pciehp:   PCI resource [7]     : 0x1000@0x3000
[    1.254367] pciehp:   PCI resource [8]     : 0x2000000@0xfc000000
[    1.254372] pciehp:   PCI resource [9]     : 0x100000@0xf8000000
[    1.254377] pciehp: Slot Capabilities      : 0x0010a0e0
[    1.254381] pciehp:   Physical Slot Number : 2
[    1.254384] pciehp:   Attention Button     :  no
[    1.254389] pciehp:   Power Controller     :  no
[    1.254392] pciehp:   MRL Sensor           :  no
[    1.254396] pciehp:   Attention Indicator  :  no
[    1.254400] pciehp:   Power Indicator      :  no
[    1.254404] pciehp:   Hot-Plug Surprise    : yes
[    1.254408] pciehp:   EMI Present          :  no
[    1.254411] pciehp:   Comamnd Completed    : yes
[    1.254419] pciehp: Slot Status            : 0x0000
[    1.254428] pciehp: Slot Control           : 0x0000
[    1.254451] pciehp: HPC vendor_id 8086 device_id 283f ss_vid 0 ss_did 0
[    1.254513] pciehp: get_power_status - physical_slot =3D 2
[    1.254522] pciehp: hpc_get_power_status: SLOTCTRL 58 value read 38
[    1.254527] pciehp: get_attention_status - physical_slot =3D 2
[    1.254536] pciehp: hpc_get_attention_status: SLOTCTRL 58, value read 38
[    1.254541] pciehp: get_latch_status - physical_slot =3D 2
[    1.254550] pciehp: get_adapter_status - physical_slot =3D 2
[    1.254560] pciehp: Registering bus=3D2 dev=3D0 hp_slot=3D0 sun=3D2 slot=
_device_offset=3D0
[    1.254566] Pid: 1, comm: swapper Not tainted 2.6.26 #110
[    1.254571]  [<c0544545>] pci_hp_register+0x25/0x4b0
[    1.254580]  [<c0545e3e>] ? get_adapter_status+0x2e/0x70
[    1.254590]  [<c054631b>] pciehp_probe+0x12b/0x3f0
[    1.254598]  [<c0542110>] pcie_port_probe_service+0x50/0x90
[    1.254606]  [<c04e9b67>] ? sysfs_create_link+0x17/0x20
[    1.254616]  [<c059f42d>] ? driver_sysfs_add+0x5d/0x90
[    1.254624]  [<c059f557>] driver_probe_device+0x87/0x1a0
[    1.254631]  [<c066f841>] ? _spin_lock_irqsave+0x21/0x40
[    1.254641]  [<c066fb66>] ? _spin_unlock_irqrestore+0x16/0x40
[    1.254649]  [<c059f6e9>] __driver_attach+0x79/0x80
[    1.254656]  [<c059ee23>] bus_for_each_dev+0x53/0x80
[    1.254663]  [<c059f3ce>] driver_attach+0x1e/0x20
[    1.254670]  [<c059f670>] ? __driver_attach+0x0/0x80
[    1.254678]  [<c059e7e7>] bus_add_driver+0x1b7/0x230
[    1.254685]  [<c059f8be>] driver_register+0x6e/0x150
[    1.254692]  [<c059f8be>] ? driver_register+0x6e/0x150
[    1.254700]  [<c054202f>] pcie_port_service_register+0x3f/0x50
[    1.254709]  [<c07a7b52>] pcied_init+0x16/0x83
[    1.254717]  [<c07a7b38>] ? pci_hotplug_init+0x1f/0x23
[    1.254725]  [<c078b417>] kernel_init+0x1ad/0x2b8
[    1.254733]  [<c04ae774>] ? sys_select+0x44/0x1a0
[    1.254742]  [<c07a7b3c>] ? pcied_init+0x0/0x83
[    1.254751]  [<c042337f>] ? schedule_tail+0x1f/0x50
[    1.254759]  [<c0403e72>] ? ret_from_fork+0x6/0x1c
[    1.254767]  [<c078b26a>] ? kernel_init+0x0/0x2b8
[    1.254776]  [<c078b26a>] ? kernel_init+0x0/0x2b8
[    1.254784]  [<c0404b9b>] kernel_thread_helper+0x7/0x10
[    1.254792]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[    1.254909] hpdriver 0000:00:1c.0:pcie02: service driver hpdriver loaded
[    1.255694] pciehp: Hotplug Controller:
[    1.255700] pciehp:   Seg/Bus/Dev/Func/IRQ : 0000:00:1c.1 IRQ 221
[    1.255704] pciehp:   Vendor ID            : 0x8086
[    1.255709] pciehp:   Device ID            : 0x2841
[    1.255712] pciehp:   Subsystem ID         : 0x0000
[    1.255716] pciehp:   Subsystem Vendor ID  : 0x0000
[    1.255720] pciehp:   PCIe Cap offset      : 0x40
[    1.255725] pciehp:   PCI resource [7]     : 0x1000@0x4000
[    1.255730] pciehp:   PCI resource [8]     : 0x3200000@0xdc100000
[    1.255735] pciehp:   PCI resource [9]     : 0x100000@0xdfd00000
[    1.255739] pciehp: Slot Capabilities      : 0x0018a0e0
[    1.255743] pciehp:   Physical Slot Number : 3
[    1.255747] pciehp:   Attention Button     :  no
[    1.255750] pciehp:   Power Controller     :  no
[    1.255754] pciehp:   MRL Sensor           :  no
[    1.255758] pciehp:   Attention Indicator  :  no
[    1.255762] pciehp:   Power Indicator      :  no
[    1.255765] pciehp:   Hot-Plug Surprise    : yes
[    1.255769] pciehp:   EMI Present          :  no
[    1.255773] pciehp:   Comamnd Completed    : yes
[    1.255781] pciehp: Slot Status            : 0x0148
[    1.255792] pciehp: Slot Control           : 0x0000
[    1.255817] pciehp: HPC vendor_id 8086 device_id 2841 ss_vid 0 ss_did 0
[    1.255884] pciehp: get_power_status - physical_slot =3D 3
[    1.255894] pciehp: hpc_get_power_status: SLOTCTRL 58 value read 38
[    1.255899] pciehp: get_attention_status - physical_slot =3D 3
[    1.255909] pciehp: hpc_get_attention_status: SLOTCTRL 58, value read 38
[    1.255914] pciehp: get_latch_status - physical_slot =3D 3
[    1.255922] pciehp: get_adapter_status - physical_slot =3D 3
[    1.255932] pciehp: Registering bus=3D3 dev=3D0 hp_slot=3D0 sun=3D3 slot=
_device_offset=3D0
[    1.255938] Pid: 1, comm: swapper Not tainted 2.6.26 #110
[    1.255943]  [<c0544545>] pci_hp_register+0x25/0x4b0
[    1.255952]  [<c0545e3e>] ? get_adapter_status+0x2e/0x70
[    1.255962]  [<c054631b>] pciehp_probe+0x12b/0x3f0
[    1.255971]  [<c0542110>] pcie_port_probe_service+0x50/0x90
[    1.255978]  [<c04e9b67>] ? sysfs_create_link+0x17/0x20
[    1.255988]  [<c059f42d>] ? driver_sysfs_add+0x5d/0x90
[    1.255996]  [<c059f557>] driver_probe_device+0x87/0x1a0
[    1.256003]  [<c066f841>] ? _spin_lock_irqsave+0x21/0x40
[    1.256013]  [<c066fb66>] ? _spin_unlock_irqrestore+0x16/0x40
[    1.256021]  [<c059f6e9>] __driver_attach+0x79/0x80
[    1.256028]  [<c059ee23>] bus_for_each_dev+0x53/0x80
[    1.256035]  [<c059f3ce>] driver_attach+0x1e/0x20
[    1.256042]  [<c059f670>] ? __driver_attach+0x0/0x80
[    1.256050]  [<c059e7e7>] bus_add_driver+0x1b7/0x230
[    1.256057]  [<c059f8be>] driver_register+0x6e/0x150
[    1.256064]  [<c059f8be>] ? driver_register+0x6e/0x150
[    1.256072]  [<c054202f>] pcie_port_service_register+0x3f/0x50
[    1.256081]  [<c07a7b52>] pcied_init+0x16/0x83
[    1.256089]  [<c07a7b38>] ? pci_hotplug_init+0x1f/0x23
[    1.256098]  [<c078b417>] kernel_init+0x1ad/0x2b8
[    1.256105]  [<c04ae774>] ? sys_select+0x44/0x1a0
[    1.256114]  [<c07a7b3c>] ? pcied_init+0x0/0x83
[    1.256122]  [<c042337f>] ? schedule_tail+0x1f/0x50
[    1.256131]  [<c0403e72>] ? ret_from_fork+0x6/0x1c
[    1.256139]  [<c078b26a>] ? kernel_init+0x0/0x2b8
[    1.256147]  [<c078b26a>] ? kernel_init+0x0/0x2b8
[    1.256155]  [<c0404b9b>] kernel_thread_helper+0x7/0x10
[    1.256163]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[    1.256279] hpdriver 0000:00:1c.1:pcie02: service driver hpdriver loaded
[    1.257096] pciehp: Hotplug Controller:
[    1.257101] pciehp:   Seg/Bus/Dev/Func/IRQ : 0000:00:1c.2 IRQ 220
[    1.257106] pciehp:   Vendor ID            : 0x8086
[    1.257110] pciehp:   Device ID            : 0x2843
[    1.257114] pciehp:   Subsystem ID         : 0x0000
[    1.257117] pciehp:   Subsystem Vendor ID  : 0x0000
[    1.257121] pciehp:   PCIe Cap offset      : 0x40
[    1.257126] pciehp:   PCI resource [7]     : 0x1000@0x5000
[    1.257131] pciehp:   PCI resource [8]     : 0x2000000@0xd8000000
[    1.257136] pciehp:   PCI resource [9]     : 0x100000@0xdfa00000
[    1.257140] pciehp: Slot Capabilities      : 0x0020a0e0
[    1.257144] pciehp:   Physical Slot Number : 4
[    1.257148] pciehp:   Attention Button     :  no
[    1.257152] pciehp:   Power Controller     :  no
[    1.257155] pciehp:   MRL Sensor           :  no
[    1.257159] pciehp:   Attention Indicator  :  no
[    1.257163] pciehp:   Power Indicator      :  no
[    1.257166] pciehp:   Hot-Plug Surprise    : yes
[    1.257170] pciehp:   EMI Present          :  no
[    1.257173] pciehp:   Comamnd Completed    : yes
[    1.257181] pciehp: Slot Status            : 0x0000
[    1.257189] pciehp: Slot Control           : 0x0000
[    1.257213] pciehp: HPC vendor_id 8086 device_id 2843 ss_vid 0 ss_did 0
[    1.257274] pciehp: get_power_status - physical_slot =3D 4
[    1.257283] pciehp: hpc_get_power_status: SLOTCTRL 58 value read 38
[    1.257288] pciehp: get_attention_status - physical_slot =3D 4
[    1.257297] pciehp: hpc_get_attention_status: SLOTCTRL 58, value read 38
[    1.257302] pciehp: get_latch_status - physical_slot =3D 4
[    1.257311] pciehp: get_adapter_status - physical_slot =3D 4
[    1.257320] pciehp: Registering bus=3D4 dev=3D0 hp_slot=3D0 sun=3D4 slot=
_device_offset=3D0
[    1.257326] Pid: 1, comm: swapper Not tainted 2.6.26 #110
[    1.257332]  [<c0544545>] pci_hp_register+0x25/0x4b0
[    1.257341]  [<c0545e3e>] ? get_adapter_status+0x2e/0x70
[    1.257351]  [<c054631b>] pciehp_probe+0x12b/0x3f0
[    1.257360]  [<c0542110>] pcie_port_probe_service+0x50/0x90
[    1.257367]  [<c04e9b67>] ? sysfs_create_link+0x17/0x20
[    1.257377]  [<c059f42d>] ? driver_sysfs_add+0x5d/0x90
[    1.257385]  [<c059f557>] driver_probe_device+0x87/0x1a0
[    1.257392]  [<c066f841>] ? _spin_lock_irqsave+0x21/0x40
[    1.257401]  [<c066fb66>] ? _spin_unlock_irqrestore+0x16/0x40
[    1.257409]  [<c059f6e9>] __driver_attach+0x79/0x80
[    1.257417]  [<c059ee23>] bus_for_each_dev+0x53/0x80
[    1.257424]  [<c059f3ce>] driver_attach+0x1e/0x20
[    1.257430]  [<c059f670>] ? __driver_attach+0x0/0x80
[    1.257438]  [<c059e7e7>] bus_add_driver+0x1b7/0x230
[    1.257445]  [<c059f8be>] driver_register+0x6e/0x150
[    1.257452]  [<c059f8be>] ? driver_register+0x6e/0x150
[    1.257460]  [<c054202f>] pcie_port_service_register+0x3f/0x50
[    1.257469]  [<c07a7b52>] pcied_init+0x16/0x83
[    1.257477]  [<c07a7b38>] ? pci_hotplug_init+0x1f/0x23
[    1.257485]  [<c078b417>] kernel_init+0x1ad/0x2b8
[    1.257493]  [<c04ae774>] ? sys_select+0x44/0x1a0
[    1.257502]  [<c07a7b3c>] ? pcied_init+0x0/0x83
[    1.257511]  [<c042337f>] ? schedule_tail+0x1f/0x50
[    1.257519]  [<c0403e72>] ? ret_from_fork+0x6/0x1c
[    1.257527]  [<c078b26a>] ? kernel_init+0x0/0x2b8
[    1.257535]  [<c078b26a>] ? kernel_init+0x0/0x2b8
[    1.257543]  [<c0404b9b>] kernel_thread_helper+0x7/0x10
[    1.257551]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[    1.257666] hpdriver 0000:00:1c.2:pcie02: service driver hpdriver loaded
[    1.258450] pciehp: Hotplug Controller:
[    1.258455] pciehp:   Seg/Bus/Dev/Func/IRQ : 0000:00:1c.3 IRQ 219
[    1.258460] pciehp:   Vendor ID            : 0x8086
[    1.258464] pciehp:   Device ID            : 0x2845
[    1.258468] pciehp:   Subsystem ID         : 0x0000
[    1.258472] pciehp:   Subsystem Vendor ID  : 0x0000
[    1.258476] pciehp:   PCIe Cap offset      : 0x40
[    1.258480] pciehp:   PCI resource [7]     : 0x1000@0x6000
[    1.258485] pciehp:   PCI resource [8]     : 0x2000000@0xd0000000
[    1.258490] pciehp:   PCI resource [9]     : 0x100000@0xdf700000
[    1.258495] pciehp: Slot Capabilities      : 0x0028a0e0
[    1.258499] pciehp:   Physical Slot Number : 5
[    1.258502] pciehp:   Attention Button     :  no
[    1.258507] pciehp:   Power Controller     :  no
[    1.258510] pciehp:   MRL Sensor           :  no
[    1.258514] pciehp:   Attention Indicator  :  no
[    1.258517] pciehp:   Power Indicator      :  no
[    1.258521] pciehp:   Hot-Plug Surprise    : yes
[    1.258525] pciehp:   EMI Present          :  no
[    1.258528] pciehp:   Comamnd Completed    : yes
[    1.258536] pciehp: Slot Status            : 0x0000
[    1.258544] pciehp: Slot Control           : 0x0028
[    1.258568] pciehp: HPC vendor_id 8086 device_id 2845 ss_vid 0 ss_did 0
[    1.258628] pciehp: get_power_status - physical_slot =3D 5
[    1.258638] pciehp: hpc_get_power_status: SLOTCTRL 58 value read 38
[    1.258643] pciehp: get_attention_status - physical_slot =3D 5
[    1.258652] pciehp: hpc_get_attention_status: SLOTCTRL 58, value read 38
[    1.258657] pciehp: get_latch_status - physical_slot =3D 5
[    1.258665] pciehp: get_adapter_status - physical_slot =3D 5
[    1.258675] pciehp: Registering bus=3D5 dev=3D0 hp_slot=3D0 sun=3D5 slot=
_device_offset=3D0
[    1.258681] Pid: 1, comm: swapper Not tainted 2.6.26 #110
[    1.258686]  [<c0544545>] pci_hp_register+0x25/0x4b0
[    1.258696]  [<c0545e3e>] ? get_adapter_status+0x2e/0x70
[    1.258705]  [<c054631b>] pciehp_probe+0x12b/0x3f0
[    1.258713]  [<c0542110>] pcie_port_probe_service+0x50/0x90
[    1.258721]  [<c04e9b67>] ? sysfs_create_link+0x17/0x20
[    1.258730]  [<c059f42d>] ? driver_sysfs_add+0x5d/0x90
[    1.258739]  [<c059f557>] driver_probe_device+0x87/0x1a0
[    1.258746]  [<c066f841>] ? _spin_lock_irqsave+0x21/0x40
[    1.258756]  [<c066fb66>] ? _spin_unlock_irqrestore+0x16/0x40
[    1.258764]  [<c059f6e9>] __driver_attach+0x79/0x80
[    1.258772]  [<c059ee23>] bus_for_each_dev+0x53/0x80
[    1.258778]  [<c059f3ce>] driver_attach+0x1e/0x20
[    1.258785]  [<c059f670>] ? __driver_attach+0x0/0x80
[    1.258793]  [<c059e7e7>] bus_add_driver+0x1b7/0x230
[    1.258801]  [<c059f8be>] driver_register+0x6e/0x150
[    1.258808]  [<c059f8be>] ? driver_register+0x6e/0x150
[    1.258816]  [<c054202f>] pcie_port_service_register+0x3f/0x50
[    1.258824]  [<c07a7b52>] pcied_init+0x16/0x83
[    1.258832]  [<c07a7b38>] ? pci_hotplug_init+0x1f/0x23
[    1.258841]  [<c078b417>] kernel_init+0x1ad/0x2b8
[    1.258849]  [<c04ae774>] ? sys_select+0x44/0x1a0
[    1.258857]  [<c07a7b3c>] ? pcied_init+0x0/0x83
[    1.258866]  [<c042337f>] ? schedule_tail+0x1f/0x50
[    1.258874]  [<c0403e72>] ? ret_from_fork+0x6/0x1c
[    1.258883]  [<c078b26a>] ? kernel_init+0x0/0x2b8
[    1.258891]  [<c078b26a>] ? kernel_init+0x0/0x2b8
[    1.258899]  [<c0404b9b>] kernel_thread_helper+0x7/0x10
[    1.258907]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[    1.259022] hpdriver 0000:00:1c.3:pcie02: service driver hpdriver loaded
[    1.259814] pciehp: Hotplug Controller:
[    1.259820] pciehp:   Seg/Bus/Dev/Func/IRQ : 0000:00:1c.4 IRQ 218
[    1.259825] pciehp:   Vendor ID            : 0x8086
[    1.259829] pciehp:   Device ID            : 0x2847
[    1.259833] pciehp:   Subsystem ID         : 0x0000
[    1.259836] pciehp:   Subsystem Vendor ID  : 0x0000
[    1.259840] pciehp:   PCIe Cap offset      : 0x40
[    1.259845] pciehp:   PCI resource [7]     : 0x1000@0x7000
[    1.259850] pciehp:   PCI resource [8]     : 0x2000000@0xcc000000
[    1.259855] pciehp:   PCI resource [9]     : 0x100000@0xdf400000
[    1.259859] pciehp: Slot Capabilities      : 0x0010a0e0
[    1.259863] pciehp:   Physical Slot Number : 2
[    1.259867] pciehp:   Attention Button     :  no
[    1.259871] pciehp:   Power Controller     :  no
[    1.259875] pciehp:   MRL Sensor           :  no
[    1.259879] pciehp:   Attention Indicator  :  no
[    1.259883] pciehp:   Power Indicator      :  no
[    1.259886] pciehp:   Hot-Plug Surprise    : yes
[    1.259890] pciehp:   EMI Present          :  no
[    1.259893] pciehp:   Comamnd Completed    : yes
[    1.259901] pciehp: Slot Status            : 0x0000
[    1.259910] pciehp: Slot Control           : 0x0000
[    1.259933] pciehp: HPC vendor_id 8086 device_id 2847 ss_vid 0 ss_did 0
[    1.259994] pciehp: get_power_status - physical_slot =3D 2
[    1.260003] pciehp: hpc_get_power_status: SLOTCTRL 58 value read 38
[    1.260008] pciehp: get_attention_status - physical_slot =3D 2
[    1.260017] pciehp: hpc_get_attention_status: SLOTCTRL 58, value read 38
[    1.260022] pciehp: get_latch_status - physical_slot =3D 2
[    1.260031] pciehp: get_adapter_status - physical_slot =3D 2
[    1.260041] pciehp: Registering bus=3Dd dev=3D0 hp_slot=3D0 sun=3D2 slot=
_device_offset=3D0
[    1.260047] Pid: 1, comm: swapper Not tainted 2.6.26 #110
[    1.260052]  [<c0544545>] pci_hp_register+0x25/0x4b0
[    1.260061]  [<c0545e3e>] ? get_adapter_status+0x2e/0x70
[    1.260071]  [<c054631b>] pciehp_probe+0x12b/0x3f0
[    1.260079]  [<c0542110>] pcie_port_probe_service+0x50/0x90
[    1.260087]  [<c04e9b67>] ? sysfs_create_link+0x17/0x20
[    1.260096]  [<c059f42d>] ? driver_sysfs_add+0x5d/0x90
[    1.260104]  [<c059f557>] driver_probe_device+0x87/0x1a0
[    1.260111]  [<c066f841>] ? _spin_lock_irqsave+0x21/0x40
[    1.260121]  [<c066fb66>] ? _spin_unlock_irqrestore+0x16/0x40
[    1.260129]  [<c059f6e9>] __driver_attach+0x79/0x80
[    1.260137]  [<c059ee23>] bus_for_each_dev+0x53/0x80
[    1.260144]  [<c059f3ce>] driver_attach+0x1e/0x20
[    1.260151]  [<c059f670>] ? __driver_attach+0x0/0x80
[    1.260159]  [<c059e7e7>] bus_add_driver+0x1b7/0x230
[    1.260166]  [<c059f8be>] driver_register+0x6e/0x150
[    1.260174]  [<c059f8be>] ? driver_register+0x6e/0x150
[    1.260182]  [<c054202f>] pcie_port_service_register+0x3f/0x50
[    1.260191]  [<c07a7b52>] pcied_init+0x16/0x83
[    1.260199]  [<c07a7b38>] ? pci_hotplug_init+0x1f/0x23
[    1.260208]  [<c078b417>] kernel_init+0x1ad/0x2b8
[    1.260216]  [<c04ae774>] ? sys_select+0x44/0x1a0
[    1.260225]  [<c07a7b3c>] ? pcied_init+0x0/0x83
[    1.260234]  [<c042337f>] ? schedule_tail+0x1f/0x50
[    1.260242]  [<c0403e72>] ? ret_from_fork+0x6/0x1c
[    1.260250]  [<c078b26a>] ? kernel_init+0x0/0x2b8
[    1.260258]  [<c078b26a>] ? kernel_init+0x0/0x2b8
[    1.260266]  [<c0404b9b>] kernel_thread_helper+0x7/0x10
[    1.260274]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[    1.260278] pciehp: pci_hp_register failed with error -17
[    1.260412] pciehp: Failed to register slot because of name collision. T=
ry 'pciehp_slot_with_bus' module option.
[    1.260547] pciehp: pciehp: slot initialization failed
[    1.260817] pciehp: pcie_port_service_register =3D 0
[    1.260822] pciehp: PCI Express Hot Plug Controller Driver version: 0.4


--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-12611-1216942161-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkiJEE8ACgkQ7b8eESbyJLh9RgCdGoktBsh+1p125exyP5EzVDSY
7vsAoN2HhosClBjIio1kcdvlVWwx2nC7
=QPI4
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-12611-1216942161-0001-2--
