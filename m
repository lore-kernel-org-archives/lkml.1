Return-Path: <linux-kernel-owner+w=401wt.eu-S1030368AbXCCSj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030368AbXCCSj6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 13:39:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030370AbXCCSj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 13:39:58 -0500
Received: from tag.witbe.net ([81.88.96.48]:49138 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030368AbXCCSj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 13:39:56 -0500
Reply-To: <rol@as2917.net>
From: "Paul Rolland" <rol@as2917.net>
To: "'Jeff Garzik'" <jeff@garzik.org>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>
Cc: <linux-ide@vger.kernel.org>, "'LKML'" <linux-kernel@vger.kernel.org>
Subject: RE: [git patches] libata fixes
Date: Sat, 3 Mar 2007 19:39:39 +0100
Organization: AS2917.net
Message-ID: <00e201c75dc3$4da9d490$2101a8c0@donald>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <20070302020833.GA6105@havoc.gtf.org>
Thread-Index: Acdcb7DCvyn81mrNRJexEoKmhYghHABU0Mxw
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Applied this on top of 2.6.21-rc1, and I now have the following in my
logs :

ahci 0000:00:1f.2: version 2.0
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1f.2 to 64
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq led clo pio slum part 
ata1: SATA max UDMA/133 cmd 0xffffc200000b2900 ctl 0x0000000000000000 bmdma
0x0000000000000000 irq 504
ata2: SATA max UDMA/133 cmd 0xffffc200000b2980 ctl 0x0000000000000000 bmdma
0x0000000000000000 irq 504
ata3: SATA max UDMA/133 cmd 0xffffc200000b2a00 ctl 0x0000000000000000 bmdma
0x0000000000000000 irq 504
ata4: SATA max UDMA/133 cmd 0xffffc200000b2a80 ctl 0x0000000000000000 bmdma
0x0000000000000000 irq 504
scsi0 : ahci
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: Maxtor 6L250S0, BANC1G10, max UDMA/133
ata1.00: 490234752 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
scsi1 : ahci
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: qc timeout (cmd 0xec)
ata2.00: failed to IDENTIFY (I/O error, err_mask=0x104)
ata2: port is slow to respond, please be patient (Status 0x80)
ata2: port failed to respond (30 secs, Status 0x80)
ata2: COMRESET failed (device not ready)
ata2: hardreset failed, retrying in 5 secs
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: ATA-6: Config  Disk, RGL10364, max UDMA/133
ata2.00: 640 sectors, multi 1: LBA 
ata2.00: configured for UDMA/133
scsi2 : ahci
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ATA-7: Maxtor 6L250S0, BANC1G10, max UDMA/133
ata3.00: 490234752 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata3.00: configured for UDMA/133
scsi3 : ahci
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4.00: ATA-7: ST3500641AS, 3.AAB, max UDMA/133
ata4.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata4.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      Maxtor 6L250S0   BANC PQ: 0 ANSI: 5
SCSI device sda: 490234752 512-byte hdwr sectors (251000 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support
DPO or FUA
SCSI device sda: 490234752 512-byte hdwr sectors (251000 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support
DPO or FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: Attached scsi disk sda
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: Direct-Access     ATA      Config  Disk     RGL1 PQ: 0 ANSI: 5
SCSI device sdb: 640 512-byte hdwr sectors (0 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: disabled, read cache: enabled, doesn't support
DPO or FUA
SCSI device sdb: 640 512-byte hdwr sectors (0 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: disabled, read cache: enabled, doesn't support
DPO or FUA
 sdb: unknown partition table
sd 1:0:0:0: Attached scsi disk sdb
sd 1:0:0:0: Attached scsi generic sg1 type 0
scsi 2:0:0:0: Direct-Access     ATA      Maxtor 6L250S0   BANC PQ: 0 ANSI: 5
SCSI device sdc: 490234752 512-byte hdwr sectors (251000 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 3a 00 00
SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support
DPO or FUA
SCSI device sdc: 490234752 512-byte hdwr sectors (251000 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 3a 00 00
SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support
DPO or FUA
 sdc: sdc1 sdc2
sd 2:0:0:0: Attached scsi disk sdc
sd 2:0:0:0: Attached scsi generic sg2 type 0
scsi 3:0:0:0: Direct-Access     ATA      ST3500641AS      3.AA PQ: 0 ANSI: 5
SCSI device sdd: 976773168 512-byte hdwr sectors (500108 MB)
sdd: Write Protect is off
sdd: Mode Sense: 00 3a 00 00
SCSI device sdd: write cache: enabled, read cache: enabled, doesn't support
DPO or FUA
SCSI device sdd: 976773168 512-byte hdwr sectors (500108 MB)
sdd: Write Protect is off
sdd: Mode Sense: 00 3a 00 00
SCSI device sdd: write cache: enabled, read cache: enabled, doesn't support
DPO or FUA
 sdd: sdd1 sdd2 sdd3
sd 3:0:0:0: Attached scsi disk sdd
sd 3:0:0:0: Attached scsi generic sg3 type 0
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:02:00.0 to 64
ahci 0000:02:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
ahci 0000:02:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
ata5: SATA max UDMA/133 cmd 0xffffc200000bc100 ctl 0x0000000000000000 bmdma
0x0000000000000000 irq 17
ata6: SATA max UDMA/133 cmd 0xffffc200000bc180 ctl 0x0000000000000000 bmdma
0x0000000000000000 irq 17
scsi4 : ahci
ata5: SATA link down (SStatus 0 SControl 300)
scsi5 : ahci
ata6: SATA link down (SStatus 0 SControl 300)
ata_piix 0000:00:1f.1: version 2.00ac7
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1f.1 to 64
ata7: PATA max UDMA/133 cmd 0x00000000000101f0 ctl 0x00000000000103f6 bmdma
0x000000000001ffa0 irq 14
ata8: PATA max UDMA/133 cmd 0x0000000000010170 ctl 0x0000000000010376 bmdma
0x000000000001ffa8 irq 15
scsi6 : ata_piix
ACPI Error (dsopcode-0481): Attempt to CreateField of length zero [20070126]
ACPI Error (psparse-0537): Method parse/execution failed
[\_SB_.PCI0.IDE0.RATA] (Node ffff8100c7f4b490), AE_AML_OPERAND_VALUE
ACPI Error (psparse-0537): Method parse/execution failed
[\_SB_.PCI0.IDE0.CHN0.DRV0._GTF] (Node ffff8100c7f4b7f0), AE_AML_OPERAND_VALUE
ata7.00: ATA-7: Maxtor 6L200P0, BAH41E00, max UDMA/133
ata7.00: 398297088 sectors, multi 16: LBA48 
ACPI Error (dsopcode-0481): Attempt to CreateField of length zero [20070126]
ACPI Error (psparse-0537): Method parse/execution failed
[\_SB_.PCI0.IDE0.RATA] (Node ffff8100c7f4b490), AE_AML_OPERAND_VALUE
ACPI Error (psparse-0537): Method parse/execution failed
[\_SB_.PCI0.IDE0.CHN0.DRV0._GTF] (Node ffff8100c7f4b7f0), AE_AML_OPERAND_VALUE
ata7.01: ATAPI, max UDMA/33
ACPI Error (dsopcode-0481): Attempt to CreateField of length zero [20070126]
ACPI Error (psparse-0537): Method parse/execution failed
[\_SB_.PCI0.IDE0.RATA] (Node ffff8100c7f4b490), AE_AML_OPERAND_VALUE
ACPI Error (psparse-0537): Method parse/execution failed
[\_SB_.PCI0.IDE0.CHN0.DRV0._GTF] (Node ffff8100c7f4b7f0), AE_AML_OPERAND_VALUE
ata7.00: configured for UDMA/33
ACPI Error (dsopcode-0481): Attempt to CreateField of length zero [20070126]
ACPI Error (psparse-0537): Method parse/execution failed
[\_SB_.PCI0.IDE0.RATA] (Node ffff8100c7f4b490), AE_AML_OPERAND_VALUE
ACPI Error (psparse-0537): Method parse/execution failed
[\_SB_.PCI0.IDE0.CHN0.DRV0._GTF] (Node ffff8100c7f4b7f0), AE_AML_OPERAND_VALUE
ata7.01: configured for UDMA/33
scsi7 : ata_piix
ATA: abnormal status 0x7F on port 0x0000000000010177
scsi 6:0:0:0: Direct-Access     ATA      Maxtor 6L200P0   BAH4 PQ: 0 ANSI: 5
SCSI device sde: 398297088 512-byte hdwr sectors (203928 MB)
sde: Write Protect is off
sde: Mode Sense: 00 3a 00 00
SCSI device sde: write cache: enabled, read cache: enabled, doesn't support
DPO or FUA
SCSI device sde: 398297088 512-byte hdwr sectors (203928 MB)
sde: Write Protect is off
sde: Mode Sense: 00 3a 00 00
SCSI device sde: write cache: enabled, read cache: enabled, doesn't support
DPO or FUA
 sde: sde1 sde2 sde3 sde4 < sde5 sde6 >
sd 6:0:0:0: Attached scsi disk sde
sd 6:0:0:0: Attached scsi generic sg4 type 0
scsi 6:0:1:0: CD-ROM            ASUS     CRW-5232A3       1.00 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 52x/52x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 6:0:1:0: Attached scsi CD-ROM sr0
sr 6:0:1:0: Attached scsi generic sg5 type 5
PCI: Enabling device 0000:02:00.1 (0000 -> 0001)
ACPI: PCI Interrupt 0000:02:00.1[B] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:02:00.1 to 64
ata9: PATA max UDMA/100 cmd 0x0000000000019c00 ctl 0x0000000000019882 bmdma
0x0000000000019400 irq 16
ata10: PATA max UDMA/100 cmd 0x0000000000019800 ctl 0x0000000000019482 bmdma
0x0000000000019408 irq 16
scsi8 : pata_jmicron
ata9.00: ATAPI, max UDMA/66
ata9.00: qc timeout (cmd 0xef)
ata9.00: failed to set xfermode (err_mask=0x4)
ata9.00: limiting speed to UDMA/44
ata9: failed to recover some devices, retrying in 5 secs
ata9.00: qc timeout (cmd 0xef)
ata9.00: failed to set xfermode (err_mask=0x4)
ata9.00: limiting speed to PIO0
ata9: failed to recover some devices, retrying in 5 secs
ata9.00: qc timeout (cmd 0xef)
ata9.00: failed to set xfermode (err_mask=0x4)
ata9.00: disabled
scsi9 : pata_jmicron
ATA: abnormal status 0x7F on port 0x0000000000019807
....
ata1.00: exception Emask 0x2 SAct 0xffe0 SErr 0x0 action 0x2 frozen
ata1.00: (spurious completions during NCQ issue=0x0 SAct=0xffe0
FIS=004040a1:00000010)
ata1.00: cmd 60/02:28:52:ec:c4/00:00:0e:00:00/40 tag 5 cdb 0x0 data 1024 in
         res 40/00:78:66:ec:c4/00:00:0e:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/02:30:54:ec:c4/00:00:0e:00:00/40 tag 6 cdb 0x0 data 1024 in
         res 40/00:78:66:ec:c4/00:00:0e:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/02:38:56:ec:c4/00:00:0e:00:00/40 tag 7 cdb 0x0 data 1024 in
         res 40/00:78:66:ec:c4/00:00:0e:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/02:40:58:ec:c4/00:00:0e:00:00/40 tag 8 cdb 0x0 data 1024 in
         res 40/00:78:66:ec:c4/00:00:0e:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/02:48:5a:ec:c4/00:00:0e:00:00/40 tag 9 cdb 0x0 data 1024 in
         res 40/00:78:66:ec:c4/00:00:0e:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/02:50:5c:ec:c4/00:00:0e:00:00/40 tag 10 cdb 0x0 data 1024 in
         res 40/00:78:66:ec:c4/00:00:0e:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/02:58:5e:ec:c4/00:00:0e:00:00/40 tag 11 cdb 0x0 data 1024 in
         res 40/00:78:66:ec:c4/00:00:0e:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/02:60:60:ec:c4/00:00:0e:00:00/40 tag 12 cdb 0x0 data 1024 in
         res 40/00:78:66:ec:c4/00:00:0e:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/02:68:62:ec:c4/00:00:0e:00:00/40 tag 13 cdb 0x0 data 1024 in
         res 40/00:78:66:ec:c4/00:00:0e:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/02:70:64:ec:c4/00:00:0e:00:00/40 tag 14 cdb 0x0 data 1024 in
         res 40/00:78:66:ec:c4/00:00:0e:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/02:78:66:ec:c4/00:00:0e:00:00/40 tag 15 cdb 0x0 data 1024 in
         res 40/00:78:66:ec:c4/00:00:0e:00:00/40 Emask 0x2 (HSM violation)
ata1: soft resetting port
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: configured for UDMA/133
ata1: EH complete
SCSI device sda: 490234752 512-byte hdwr sectors (251000 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support
DPO or FUA

This last part was not present when booting stock 2.6.21-rc1

Any other info you may need, please ask.

Regards,
Paul


Paul Rolland, rol(at)as2917.net
ex-AS2917 Network administrator and Peering Coordinator

--

Please no HTML, I'm not a browser - Pas d'HTML, je ne suis pas un navigateur 
"Some people dream of success... while others wake up and work hard at it" 

"I worry about my child and the Internet all the time, even though she's too 
young to have logged on yet. Here's what I worry about. I worry that 10 or 15 
years from now, she will come to me and say 'Daddy, where were you when they 
took freedom of the press away from the Internet?'"
--Mike Godwin, Electronic Frontier Foundation 
  

> -----Original Message-----
> From: linux-ide-owner@vger.kernel.org 
> [mailto:linux-ide-owner@vger.kernel.org] On Behalf Of Jeff Garzik
> Sent: Friday, March 02, 2007 3:09 AM
> To: Andrew Morton; Linus Torvalds
> Cc: linux-ide@vger.kernel.org; LKML
> Subject: [git patches] libata fixes
> 
> 
> Does not include Alan's stuff, per recent email thread.
> 
> Please pull from 'upstream-linus' branch of
> master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev
> .git upstream-linus
> 
> to receive the following updates:
> 
>  drivers/ata/ahci.c          |   55 ++++++++++++++--------------
>  drivers/ata/libata-core.c   |    5 ++-
>  drivers/ata/pata_cs5520.c   |    1 -
>  drivers/ata/pata_isapnp.c   |    1 -
>  drivers/ata/pata_jmicron.c  |   51 ++++++--------------------
>  drivers/ata/pata_platform.c |    1 -
>  drivers/ata/sata_sil24.c    |    3 --
>  drivers/pci/quirks.c        |   83 
> +++++++++++++++++++++++++++---------------
>  8 files changed, 95 insertions(+), 105 deletions(-)
> 
> Tejun Heo (7):
>       libata: clear drvdata in ata_host_release(), take#2
>       sata_sil24: kill unused local variable idx in sil24_fill_sg()
>       libata: blacklist FUJITSU MHT2060BH for NCQ
>       pata_jmicron: drop unnecessary device programming in [re]init
>       jmicron ATA: reimplement jmicron ATA quirk
>       ahci/pata_jmicron: match class not function number
>       ahci: improve spurious SDB FIS handling
> 
> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
> index 6d93240..1539734 100644
> --- a/drivers/ata/ahci.c
> +++ b/drivers/ata/ahci.c
> @@ -200,6 +200,7 @@ struct ahci_port_priv {
>  	/* for NCQ spurious interrupt analysis */
>  	unsigned int		ncq_saw_d2h:1;
>  	unsigned int		ncq_saw_dmas:1;
> +	unsigned int		ncq_saw_sdb:1;
>  };
>  
>  static u32 ahci_scr_read (struct ata_port *ap, unsigned int sc_reg);
> @@ -384,12 +385,9 @@ static const struct pci_device_id 
> ahci_pci_tbl[] = {
>  	{ PCI_VDEVICE(INTEL, 0x294d), board_ahci_pi }, /* ICH9 */
>  	{ PCI_VDEVICE(INTEL, 0x294e), board_ahci_pi }, /* ICH9M */
>  
> -	/* JMicron */
> -	{ PCI_VDEVICE(JMICRON, 0x2360), board_ahci_ign_iferr }, 
> /* JMB360 */
> -	{ PCI_VDEVICE(JMICRON, 0x2361), board_ahci_ign_iferr }, 
> /* JMB361 */
> -	{ PCI_VDEVICE(JMICRON, 0x2363), board_ahci_ign_iferr }, 
> /* JMB363 */
> -	{ PCI_VDEVICE(JMICRON, 0x2365), board_ahci_ign_iferr }, 
> /* JMB365 */
> -	{ PCI_VDEVICE(JMICRON, 0x2366), board_ahci_ign_iferr }, 
> /* JMB366 */
> +	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
> +	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
> +	  PCI_CLASS_STORAGE_SATA_AHCI, 0xffffff, board_ahci_ign_iferr },
>  
>  	/* ATI */
>  	{ PCI_VDEVICE(ATI, 0x4380), board_ahci }, /* ATI SB600 
> non-raid */
> @@ -1160,23 +1158,31 @@ static void ahci_host_intr(struct 
> ata_port *ap)
>  	}
>  
>  	if (status & PORT_IRQ_SDB_FIS) {
> -		/* SDB FIS containing spurious completions might be
> -		 * dangerous, whine and fail commands with HSM
> -		 * violation.  EH will turn off NCQ after several such
> -		 * failures.
> -  		 */
>  		const __le32 *f = pp->rx_fis + RX_FIS_SDB;
>  
> -		ata_ehi_push_desc(ehi, "spurious completion during NCQ "
> -				  "issue=0x%x SAct=0x%x FIS=%08x:%08x",
> -				  readl(port_mmio + PORT_CMD_ISSUE),
> -				  readl(port_mmio + PORT_SCR_ACT),
> -				  le32_to_cpu(f[0]), le32_to_cpu(f[1]));
> -
> -		ehi->err_mask |= AC_ERR_HSM;
> -		ehi->action |= ATA_EH_SOFTRESET;
> -		ata_port_freeze(ap);
> -
> +		if (le32_to_cpu(f[1])) {
> +			/* SDB FIS containing spurious completions
> +			 * might be dangerous, whine and fail commands
> +			 * with HSM violation.  EH will turn off NCQ
> +			 * after several such failures.
> +			 */
> +			ata_ehi_push_desc(ehi,
> +				"spurious completions during NCQ "
> +				"issue=0x%x SAct=0x%x FIS=%08x:%08x",
> +				readl(port_mmio + PORT_CMD_ISSUE),
> +				readl(port_mmio + PORT_SCR_ACT),
> +				le32_to_cpu(f[0]), le32_to_cpu(f[1]));
> +			ehi->err_mask |= AC_ERR_HSM;
> +			ehi->action |= ATA_EH_SOFTRESET;
> +			ata_port_freeze(ap);
> +		} else {
> +			if (!pp->ncq_saw_sdb)
> +				ata_port_printk(ap, KERN_INFO,
> +					"spurious SDB FIS 
> %08x:%08x during NCQ, "
> +					"this message won't be 
> printed again\n",
> +					le32_to_cpu(f[0]), 
> le32_to_cpu(f[1]));
> +			pp->ncq_saw_sdb = 1;
> +		}
>  		known_irq = 1;
>  	}
>  
> @@ -1665,13 +1671,6 @@ static int ahci_init_one(struct 
> pci_dev *pdev, const struct pci_device_id *ent)
>  	if (!printed_version++)
>  		dev_printk(KERN_DEBUG, &pdev->dev, "version " 
> DRV_VERSION "\n");
>  
> -	if (pdev->vendor == PCI_VENDOR_ID_JMICRON) {
> -		/* Function 1 is the PATA controller except on 
> the 368, where
> -		   we are not AHCI anyway */
> -		if (PCI_FUNC(pdev->devfn))
> -			return -ENODEV;
> -	}
> -
>  	rc = pcim_enable_device(pdev);
>  	if (rc)
>  		return rc;
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index c8d44a7..ac3d120 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -3346,6 +3346,8 @@ static const struct ata_blacklist_entry 
> ata_device_blacklist [] = {
>  	/* Devices where NCQ should be avoided */
>  	/* NCQ is slow */
>          { "WDC WD740ADFD-00",   NULL,		
> ATA_HORKAGE_NONCQ },
> +	/* http://thread.gmane.org/gmane.linux.ide/14907 */
> +	{ "FUJITSU MHT2060BH",	NULL,		ATA_HORKAGE_NONCQ },
>  
>  	/* Devices with NCQ limits */
>  
> @@ -5680,6 +5682,8 @@ static void ata_host_release(struct 
> device *gendev, void *res)
>  
>  	if (host->ops->host_stop)
>  		host->ops->host_stop(host);
> +
> +	dev_set_drvdata(gendev, NULL);
>  }
>  
>  /**
> @@ -5902,7 +5906,6 @@ int ata_device_add(const struct 
> ata_probe_ent *ent)
>  
>   err_out:
>  	devres_release_group(dev, ata_device_add);
> -	dev_set_drvdata(dev, NULL);
>  	VPRINTK("EXIT, returning %d\n", rc);
>  	return 0;
>  }
> diff --git a/drivers/ata/pata_cs5520.c b/drivers/ata/pata_cs5520.c
> index c1334c6..8ff2d58 100644
> --- a/drivers/ata/pata_cs5520.c
> +++ b/drivers/ata/pata_cs5520.c
> @@ -306,7 +306,6 @@ static void __devexit 
> cs5520_remove_one(struct pci_dev *pdev)
>  	struct ata_host *host = dev_get_drvdata(dev);
>  
>  	ata_host_detach(host);
> -	dev_set_drvdata(dev, NULL);
>  }
>  
>  /**
> diff --git a/drivers/ata/pata_isapnp.c b/drivers/ata/pata_isapnp.c
> index d5f2e85..1a61cc8 100644
> --- a/drivers/ata/pata_isapnp.c
> +++ b/drivers/ata/pata_isapnp.c
> @@ -128,7 +128,6 @@ static void isapnp_remove_one(struct 
> pnp_dev *idev)
>  	struct ata_host *host = dev_get_drvdata(dev);
>  
>  	ata_host_detach(host);
> -	dev_set_drvdata(dev, NULL);
>  }
>  
>  static struct pnp_device_id isapnp_devices[] = {
> diff --git a/drivers/ata/pata_jmicron.c b/drivers/ata/pata_jmicron.c
> index 7a635dd..47d0f94 100644
> --- a/drivers/ata/pata_jmicron.c
> +++ b/drivers/ata/pata_jmicron.c
> @@ -202,49 +202,20 @@ static int jmicron_init_one (struct 
> pci_dev *pdev, const struct pci_device_id *i
>  	};
>  	struct ata_port_info *port_info[2] = { &info, &info };
>  
> -	u32 reg;
> -
> -	/* PATA controller is fn 1, AHCI is fn 0 */
> -	if (id->driver_data != 368 && PCI_FUNC(pdev->devfn) != 1)
> -		return -ENODEV;
> -
> -	/* The 365/66 have two PATA channels, redirect the second */
> -	if (id->driver_data == 365 || id->driver_data == 366) {
> -		pci_read_config_dword(pdev, 0x80, &reg);
> -		reg |= (1 << 24);	/* IDE1 to PATA IDE secondary */
> -		pci_write_config_dword(pdev, 0x80, reg);
> -	}
> -
>  	return ata_pci_init_one(pdev, port_info, 2);
>  }
>  
> -static int jmicron_reinit_one(struct pci_dev *pdev)
> -{
> -	u32 reg;
> -
> -	switch(pdev->device) {
> -		case PCI_DEVICE_ID_JMICRON_JMB368:
> -			break;
> -		case PCI_DEVICE_ID_JMICRON_JMB365:
> -		case PCI_DEVICE_ID_JMICRON_JMB366:
> -			/* Restore mapping or disks swap and 
> boy does it get ugly */
> -			pci_read_config_dword(pdev, 0x80, &reg);
> -			reg |= (1 << 24);	/* IDE1 to PATA 
> IDE secondary */
> -			pci_write_config_dword(pdev, 0x80, reg);
> -			/* Fall through */
> -		default:
> -			/* Make sure AHCI is turned back on */
> -			pci_write_config_byte(pdev, 0x41, 0xa1);
> -	}
> -	return ata_pci_device_resume(pdev);
> -}
> -
>  static const struct pci_device_id jmicron_pci_tbl[] = {
> -	{ PCI_VDEVICE(JMICRON, PCI_DEVICE_ID_JMICRON_JMB361), 361},
> -	{ PCI_VDEVICE(JMICRON, PCI_DEVICE_ID_JMICRON_JMB363), 363},
> -	{ PCI_VDEVICE(JMICRON, PCI_DEVICE_ID_JMICRON_JMB365), 365},
> -	{ PCI_VDEVICE(JMICRON, PCI_DEVICE_ID_JMICRON_JMB366), 366},
> -	{ PCI_VDEVICE(JMICRON, PCI_DEVICE_ID_JMICRON_JMB368), 368},
> +	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB361,
> +	  PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_STORAGE_IDE << 8, 
> 0xffff00, 361 },
> +	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB363,
> +	  PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_STORAGE_IDE << 8, 
> 0xffff00, 363 },
> +	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB365,
> +	  PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_STORAGE_IDE << 8, 
> 0xffff00, 365 },
> +	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB366,
> +	  PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_STORAGE_IDE << 8, 
> 0xffff00, 366 },
> +	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB368,
> +	  PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_STORAGE_IDE << 8, 
> 0xffff00, 368 },
>  
>  	{ }	/* terminate list */
>  };
> @@ -255,7 +226,7 @@ static struct pci_driver jmicron_pci_driver = {
>  	.probe			= jmicron_init_one,
>  	.remove			= ata_pci_remove_one,
>  	.suspend		= ata_pci_device_suspend,
> -	.resume			= jmicron_reinit_one,
> +	.resume			= ata_pci_device_resume,
>  };
>  
>  static int __init jmicron_init(void)
> diff --git a/drivers/ata/pata_platform.c b/drivers/ata/pata_platform.c
> index 02ea95f..4b82a54 100644
> --- a/drivers/ata/pata_platform.c
> +++ b/drivers/ata/pata_platform.c
> @@ -228,7 +228,6 @@ static int __devexit 
> pata_platform_remove(struct platform_device *pdev)
>  	struct ata_host *host = dev_get_drvdata(dev);
>  
>  	ata_host_detach(host);
> -	dev_set_drvdata(dev, NULL);
>  
>  	return 0;
>  }
> diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
> index 5d083f4..b1bab82 100644
> --- a/drivers/ata/sata_sil24.c
> +++ b/drivers/ata/sata_sil24.c
> @@ -647,7 +647,6 @@ static inline void sil24_fill_sg(struct 
> ata_queued_cmd *qc,
>  				 struct sil24_sge *sge)
>  {
>  	struct scatterlist *sg;
> -	unsigned int idx = 0;
>  
>  	ata_for_each_sg(sg, qc) {
>  		sge->addr = cpu_to_le64(sg_dma_address(sg));
> @@ -656,9 +655,7 @@ static inline void sil24_fill_sg(struct 
> ata_queued_cmd *qc,
>  			sge->flags = cpu_to_le32(SGE_TRM);
>  		else
>  			sge->flags = 0;
> -
>  		sge++;
> -		idx++;
>  	}
>  }
>  
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 1e6eda2..1bf5482 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -1218,45 +1218,68 @@ 
> DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_VIA,	
> PCI_DEVICE_ID_VIA_8237, asus_hides_a
>   *	do this early on to make the additional device appear during
>   *	the PCI scanning.
>   */
> -
> -static void quirk_jmicron_dualfn(struct pci_dev *pdev)
> +static void quirk_jmicron_ata(struct pci_dev *pdev)
>  {
> -	u32 conf;
> +	u32 conf1, conf5, class;
>  	u8 hdr;
>  
>  	/* Only poke fn 0 */
>  	if (PCI_FUNC(pdev->devfn))
>  		return;
>  
> -	switch(pdev->device) {
> -		case PCI_DEVICE_ID_JMICRON_JMB365:
> -		case PCI_DEVICE_ID_JMICRON_JMB366:
> -			/* Redirect IDE second PATA port to the 
> right spot */
> -			pci_read_config_dword(pdev, 0x80, &conf);
> -			conf |= (1 << 24);
> -			/* Fall through */
> -			pci_write_config_dword(pdev, 0x80, conf);
> -		case PCI_DEVICE_ID_JMICRON_JMB361:
> -		case PCI_DEVICE_ID_JMICRON_JMB363:
> -			pci_read_config_dword(pdev, 0x40, &conf);
> -			/* Enable dual function mode, AHCI on 
> fn 0, IDE fn1 */
> -			/* Set the class codes correctly and 
> then direct IDE 0 */
> -			conf &= ~0x000FF200; /* Clear bit 9 and 12-19 */
> -			conf |=  0x00C2A102; /* Set 1, 8, 13, 
> 15, 17, 22, 23 */
> -			pci_write_config_dword(pdev, 0x40, conf);
> -
> -			/* Reconfigure so that the PCI scanner 
> discovers the
> -			   device is now multifunction */
> -
> -			pci_read_config_byte(pdev, 
> PCI_HEADER_TYPE, &hdr);
> -			pdev->hdr_type = hdr & 0x7f;
> -			pdev->multifunction = !!(hdr & 0x80);
> +	pci_read_config_dword(pdev, 0x40, &conf1);
> +	pci_read_config_dword(pdev, 0x80, &conf5);
>  
> -			break;
> +	conf1 &= ~0x00CFF302; /* Clear bit 1, 8, 9, 12-19, 22, 23 */
> +	conf5 &= ~(1 << 24);  /* Clear bit 24 */
> +
> +	switch (pdev->device) {
> +	case PCI_DEVICE_ID_JMICRON_JMB360:
> +		/* The controller should be in single function 
> ahci mode */
> +		conf1 |= 0x0002A100; /* Set 8, 13, 15, 17 */
> +		break;
> +
> +	case PCI_DEVICE_ID_JMICRON_JMB365:
> +	case PCI_DEVICE_ID_JMICRON_JMB366:
> +		/* Redirect IDE second PATA port to the right spot */
> +		conf5 |= (1 << 24);
> +		/* Fall through */
> +	case PCI_DEVICE_ID_JMICRON_JMB361:
> +	case PCI_DEVICE_ID_JMICRON_JMB363:
> +		/* Enable dual function mode, AHCI on fn 0, IDE fn1 */
> +		/* Set the class codes correctly and then 
> direct IDE 0 */
> +		conf1 |= 0x00C2A102; /* Set 1, 8, 13, 15, 17, 22, 23 */
> +		break;
> +
> +	case PCI_DEVICE_ID_JMICRON_JMB368:
> +		/* The controller should be in single function 
> IDE mode */
> +		conf1 |= 0x00C00000; /* Set 22, 23 */
> +		break;
>  	}
> -}
> -DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, 
> quirk_jmicron_dualfn);
> -DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, 
> quirk_jmicron_dualfn);
> +
> +	pci_write_config_dword(pdev, 0x40, conf1);
> +	pci_write_config_dword(pdev, 0x80, conf5);
> +
> +	/* Update pdev accordingly */
> +	pci_read_config_byte(pdev, PCI_HEADER_TYPE, &hdr);
> +	pdev->hdr_type = hdr & 0x7f;
> +	pdev->multifunction = !!(hdr & 0x80);
> +
> +	pci_read_config_dword(pdev, PCI_CLASS_REVISION, &class);
> +	pdev->class = class >> 8;
> +}
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_JMICRON, 
> PCI_DEVICE_ID_JMICRON_JMB360, quirk_jmicron_ata);
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_JMICRON, 
> PCI_DEVICE_ID_JMICRON_JMB361, quirk_jmicron_ata);
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_JMICRON, 
> PCI_DEVICE_ID_JMICRON_JMB363, quirk_jmicron_ata);
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_JMICRON, 
> PCI_DEVICE_ID_JMICRON_JMB365, quirk_jmicron_ata);
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_JMICRON, 
> PCI_DEVICE_ID_JMICRON_JMB366, quirk_jmicron_ata);
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_JMICRON, 
> PCI_DEVICE_ID_JMICRON_JMB368, quirk_jmicron_ata);
> +DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_JMICRON, 
> PCI_DEVICE_ID_JMICRON_JMB360, quirk_jmicron_ata);
> +DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_JMICRON, 
> PCI_DEVICE_ID_JMICRON_JMB361, quirk_jmicron_ata);
> +DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_JMICRON, 
> PCI_DEVICE_ID_JMICRON_JMB363, quirk_jmicron_ata);
> +DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_JMICRON, 
> PCI_DEVICE_ID_JMICRON_JMB365, quirk_jmicron_ata);
> +DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_JMICRON, 
> PCI_DEVICE_ID_JMICRON_JMB366, quirk_jmicron_ata);
> +DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_JMICRON, 
> PCI_DEVICE_ID_JMICRON_JMB368, quirk_jmicron_ata);
>  
>  #endif
>  
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

