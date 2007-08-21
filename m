Return-Path: <linux-kernel-owner+w=401wt.eu-S1762748AbXHURPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762748AbXHURPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 13:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760526AbXHURPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 13:15:24 -0400
Received: from hapkido.dreamhost.com ([66.33.216.122]:48694 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760438AbXHURPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 13:15:22 -0400
Subject: PROBLEM: DVD Burning with Asus M2NPV mainboard
From: Marco Aicardi <marco@aicardi.org>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Tue, 21 Aug 2007 19:12:53 +0200
Message-Id: <1187716373.27251.10.camel@rolly>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[1.] One line summary of the problem:    

        Unable to burn DVD with the Asus M2NPV mainboard

[2.] Full description of the problem/report:

        I have recently changed my mainboard to a Asus M2NPV-VM one; nothing else was changed in the PC setup. From that moment on, I am unable to burn DVDs.
        Both k3b and growisofs fail wih a generic input/output error.
        
        The same issue does not happen when mastering with other OSes.

[3.] Keywords (i.e., modules, networking, kernel):

[4.] Kernel version (from /proc/version):

        2.6.20-16 and 2.6.22-9

[5.] Output of Oops.. message (if applicable) with symbolic information 
     resolved (see Documentation/oops-tracing.txt)

        root@rolly:~# growisofs -dvd-compat -Z /dev/dvd=test.iso
        Executing 'builtin_dd if=test.iso of=/dev/dvd obs=32k seek=0'
        /dev/dvd: FEATURE 21h is not on, engaging DAO...
        /dev/dvd: reserving 2256139 blocks
        /dev/dvd: "Current Write Speed" is 4.1x1352KBps.
                  0/4620572672 ( 0.0%) @0x, remaining ??:?? RBU 100.0% UBU   0.0%
        :-? the LUN appears to be stuck writing LBA=0h, keep retrying in 5ms
                  0/4620572672 ( 0.0%) @0x, remaining ??:?? RBU 100.0% UBU   0.0%
                  0/4620572672 ( 0.0%) @0x, remaining ??:?? RBU 100.0% UBU   0.0%
        :-? the LUN appears to be stuck writing LBA=0h, keep retrying in 5ms
                  0/4620572672 ( 0.0%) @0x, remaining ??:?? RBU 100.0% UBU   0.0%
                  0/4620572672 ( 0.0%) @0x, remaining ??:?? RBU 100.0% UBU   0.0%
        :-? the LUN appears to be stuck writing LBA=0h, keep retrying in 5ms
           14516224/4620572672 ( 0.3%) @3.1x, remaining 116:20 RBU  97.2% UBU   3.2%
           33587200/4620572672 ( 0.7%) @4.1x, remaining 56:54 RBU  90.5% UBU  90.3%
           52658176/4620572672 ( 1.1%) @4.1x, remaining 41:55 RBU 100.0% UBU  90.3%
           71729152/4620572672 ( 1.6%) @4.1x, remaining 33:49 RBU  97.1% UBU  90.3%
           90800128/4620572672 ( 2.0%) @4.1x, remaining 29:06 RBU 100.0% UBU  90.3%
        :-[ WRITE@LBA=bab0h failed with SK=4h/ASC=08h/ACQ=03h]: Input/output error
        :-( write failed: Input/output error
        /dev/dvd: flushing cache
        
        
        root@rolly:~# hdparm -i /dev/hdd
        
        /dev/hdd:
        
         Model=Optiarc DVD RW AD-7173A, FwRev=1-01, SerialNo=
         Config={ Fixed Removeable DTR<=5Mbs DTR>10Mbs nonMagnetic }
         RawCHS=0/0/0, TrkSize=0, SectSize=0, ECCbytes=0
         BuffType=unknown, BuffSize=0kB, MaxMultSect=0
         (maybe): CurCHS=0/0/0, CurSects=0, LBA=yes, LBAsects=0
         IORDY=yes, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
         PIO modes:  pio0 pio1 pio2 pio3 pio4
         DMA modes:  mdma0 mdma1 mdma2
         UDMA modes: udma0 udma1 udma2 udma3 *udma4 udma3 *udma4
         AdvancedPM=no
        
         * signifies the current active mode


[6.] A small shell script or example program which triggers the
     problem (if possible)

        growisofs -dvd-compat -Z /dev/dvd=test.iso
        
[7.] Environment
[7.1.] Software (add the output of the ver_linux script here)
[7.2.] Processor information (from /proc/cpuinfo):

        processor       : 0
        vendor_id       : AuthenticAMD
        cpu family      : 15
        model           : 75
        model name      : AMD Athlon(tm) 64 X2 Dual Core Processor 4200+
        stepping        : 2
        cpu MHz         : 2204.621
        cache size      : 512 KB
        physical id     : 0
        siblings        : 2
        core id         : 0
        cpu cores       : 2
        fdiv_bug        : no
        hlt_bug         : no
        f00f_bug        : no
        coma_bug        : no
        fpu             : yes
        fpu_exception   : yes
        cpuid level     : 1
        wp              : yes
        flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fx                     sr sse sse2 ht syscall nx mmxext fxsr_opt lm 3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm cr8legacy ts                      fid vid ttp tm stc
        bogomips        : 4412.89
        clflush size    : 64
        
        processor       : 1
        vendor_id       : AuthenticAMD
        cpu family      : 15
        model           : 75
        model name      : AMD Athlon(tm) 64 X2 Dual Core Processor 4200+
        stepping        : 2
        cpu MHz         : 2204.621
        cache size      : 512 KB
        physical id     : 0
        siblings        : 2
        core id         : 1
        cpu cores       : 2
        fdiv_bug        : no
        hlt_bug         : no
        f00f_bug        : no
        coma_bug        : no
        fpu             : yes
        fpu_exception   : yes
        cpuid level     : 1
        wp              : yes
        flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fx                     sr sse sse2 ht syscall nx mmxext fxsr_opt lm 3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm cr8legacy ts                      fid vid ttp tm stc
        bogomips        : 4409.26
        clflush size    : 64

[7.3.] Module information (from /proc/modules):

        isofs 36284 0 - Live 0xf8ffd000
        binfmt_misc 12680 1 - Live 0xf8e9a000
        rfcomm 40856 0 - Live 0xf8fdf000
        l2cap 25856 5 rfcomm, Live 0xf8fd7000
        nfs 240876 0 - Live 0xf90b3000
        vmnet 39076 12 - Live 0xf8de6000 (P)
        nfsd 218992 17 - Live 0xf9034000
        exportfs 6912 1 nfsd, Live 0xf8dbd000
        lockd 64904 3 nfs,nfsd, Live 0xf8fec000
        vboxdrv 44552 0 - Live 0xf8dda000
        vmmon 113836 0 - Live 0xf8f81000 (P)
        sunrpc 161340 12 nfs,nfsd,lockd, Live 0xf8fae000
        ppdev 10116 0 - Live 0xf8db9000
        tun 12032 1 - Live 0xf8db5000
        sony_acpi 6284 0 - Live 0xf8da0000
        pcc_acpi 13184 0 - Live 0xf8bdf000
        dev_acpi 12292 0 - Live 0xf8d9b000
        tc1100_wmi 8068 0 - Live 0xf8d8e000
        ac 6020 0 - Live 0xf8d08000
        asus_acpi 17308 0 - Live 0xf8d95000
        dock 10268 0 - Live 0xf8d8a000
        button 8720 0 - Live 0xf8d10000
        backlight 7040 1 asus_acpi, Live 0xf8d05000
        sbs 15652 0 - Live 0xf8d0b000
        container 5248 0 - Live 0xf8cfb000
        i2c_ec 6016 1 sbs, Live 0xf8cf8000
        video 16388 0 - Live 0xf8cff000
        cpufreq_powersave 2688 0 - Live 0xf8a4c000
        battery 10756 0 - Live 0xf8be4000
        cpufreq_ondemand 9228 0 - Live 0xf8b53000
        cpufreq_conservative 8200 0 - Live 0xf8bdb000
        cpufreq_userspace 5408 0 - Live 0xf8bd8000
        cpufreq_stats 7360 0 - Live 0xf8bd5000
        freq_table 5792 2 cpufreq_ondemand,cpufreq_stats, Live 0xf8bd2000
        af_packet 23816 0 - Live 0xf8bb6000
        loop 17800 0 - Live 0xf8bbd000
        xfs 562008 3 - Live 0xf8df4000
        dm_crypt 14856 0 - Live 0xf8b95000
        dm_mod 59084 1 dm_crypt, Live 0xf8c51000
        lp 12452 0 - Live 0xf8b9a000
        fuse 46612 3 - Live 0xf8bc5000
        ipv6 268960 22 - Live 0xf8d16000
        nls_cp437 6784 0 - Live 0xf8b57000
        snd_hda_intel 21912 4 - Live 0xf8b88000
        snd_hda_codec 205056 1 snd_hda_intel, Live 0xf8c93000
        snd_pcm_oss 44544 0 - Live 0xf8b72000
        snd_mixer_oss 17408 1 snd_pcm_oss, Live 0xf8a4e000
        snd_pcm 79876 4 snd_hda_intel,snd_hda_codec,snd_pcm_oss, Live 0xf8ba1000
        snd_seq_dummy 4740 0 - Live 0xf8a7e000
        snd_seq_oss 32896 0 - Live 0xf8b7e000
        snd_seq_midi 9600 0 - Live 0xf8b39000
        snd_rawmidi 25472 1 snd_seq_midi, Live 0xf8b5c000
        snd_seq_midi_event 8448 2 snd_seq_oss,snd_seq_midi, Live 0xf8b35000
        snd_seq 52592 6 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event, Live 0xf8b64000
        snd_timer 23684 3 snd_pcm,snd_seq, Live 0xf8abe000
        snd_seq_device 9100 5 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq, Live 0xf8b31000
        parport_pc 36388 1 - Live 0xf8b49000
        parport 36936 3 ppdev,lp,parport_pc, Live 0xf8b3e000
        ov51x_jpeg 153208 0 - Live 0xf8c2a000
        hci_usb 18204 2 - Live 0xf8ac5000
        nvidia 6837140 32 - Live 0xf92f5000 (P)
        snd 54020 16 snd_hda_intel,snd_hda_codec,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device, Live 0xf8aeb000
        videodev 28160 1 ov51x_jpeg, Live 0xf8ae3000
        v4l2_common 25216 1 videodev, Live 0xf8adb000
        v4l1_compat 15236 1 videodev, Live 0xf8ab9000
        bluetooth 55908 7 rfcomm,l2cap,hci_usb, Live 0xf8acc000
        soundcore 8672 1 snd, Live 0xf8a91000
        usblp 14848 0 - Live 0xf8a81000
        i2c_nforce2 6784 0 - Live 0xf8a5b000
        k8temp 6656 0 - Live 0xf8a0e000
        agpgart 35400 1 nvidia, Live 0xf8a87000
        pcspkr 4224 0 - Live 0xf8a11000
        i2c_core 22656 3 i2c_ec,nvidia,i2c_nforce2, Live 0xf8a54000
        psmouse 38920 0 - Live 0xf8a70000
        snd_page_alloc 10888 2 snd_hda_intel,snd_pcm, Live 0xf8a22000
        serio_raw 7940 0 - Live 0xf8a06000
        nls_utf8 3072 12 - Live 0xf885a000
        cifs 217080 12 - Live 0xf8afb000
        evdev 11008 4 - Live 0xf8a1e000
        tsdev 8768 0 - Live 0xf8a1a000
        ext3 133128 1 - Live 0xf8a97000
        jbd 59816 1 ext3, Live 0xf8a60000
        mbcache 9604 1 ext3, Live 0xf89fb000
        sg 36252 0 - Live 0xf8a42000
        sd_mod 23428 5 - Live 0xf8a3b000
        ide_cd 32672 0 - Live 0xf8a32000
        cdrom 37664 1 ide_cd, Live 0xf8a27000
        ide_disk 17024 4 - Live 0xf8a14000
        generic 5124 0 [permanent], Live 0xf8a03000
        amd74xx 15260 0 [permanent], Live 0xf8a09000
        ata_generic 9092 0 - Live 0xf89ff000
        raid10 26240 0 - Live 0xf8961000
        floppy 59524 0 - Live 0xf8975000
        ohci1394 36528 0 - Live 0xf8957000
        ieee1394 299448 1 ohci1394, Live 0xf89a6000
        ohci_hcd 22532 0 - Live 0xf88ea000
        ehci_hcd 34188 0 - Live 0xf893f000
        sata_nv 20868 3 - Live 0xf88d6000
        forcedeth 46728 0 - Live 0xf88dd000
        libata 125720 2 ata_generic,sata_nv, Live 0xf891f000
        scsi_mod 142348 3 sg,sd_mod,libata, Live 0xf88fb000
        usbcore 134280 6 ov51x_jpeg,hci_usb,usblp,ohci_hcd,ehci_hcd, Live 0xf888c000
        raid456 126480 0 - Live 0xf88ae000
        xor 16648 1 raid456, Live 0xf8886000
        raid1 25600 0 - Live 0xf8869000
        raid0 9600 0 - Live 0xf885c000
        multipath 9856 0 - Live 0xf882b000
        linear 7296 0 - Live 0xf884d000
        md_mod 79764 7 raid10,raid456,raid1,raid0,multipath,linear, Live 0xf8871000
        thermal 14856 0 - Live 0xf8853000
        processor 31048 1 thermal, Live 0xf8838000
        fan 5636 0 - Live 0xf8835000
        fbcon 42656 0 - Live 0xf8841000
        tileblit 3584 1 fbcon, Live 0xf8833000
        font 9216 1 fbcon, Live 0xf882f000
        bitblit 6912 1 fbcon, Live 0xf8826000
        softcursor 3200 1 bitblit, Live 0xf8829000
        vesafb 9220 0 - Live 0xf8806000
        capability 5896 0 - Live 0xf880d000
        commoncap 8192 1 capability, Live 0xf880a000
        
[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)

        0000-001f : dma1
        0020-0021 : pic1
        0040-0043 : timer0
        0050-0053 : timer1
        0060-006f : keyboard
        0070-0077 : rtc
        0080-008f : dma page reg
        00a0-00a1 : pic2
        00c0-00df : dma2
        00f0-00ff : fpu
        0170-0177 : 0000:00:0d.0
          0170-0177 : ide1
        01f0-01f7 : 0000:00:0d.0
          01f0-01f7 : ide0
        02f8-02ff : serial
        0376-0376 : 0000:00:0d.0
          0376-0376 : ide1
        0378-037a : parport0
        037b-037f : parport0
        03c0-03df : vga+
        03f2-03f5 : floppy
        03f6-03f6 : 0000:00:0d.0
          03f6-03f6 : ide0
        03f7-03f7 : floppy DIR
        03f8-03ff : serial
        0960-0967 : 0000:00:0f.0
          0960-0967 : sata_nv
        0970-0977 : 0000:00:0e.0
          0970-0977 : sata_nv
        09e0-09e7 : 0000:00:0f.0
          09e0-09e7 : sata_nv
        09f0-09f7 : 0000:00:0e.0
          09f0-09f7 : sata_nv
        0b60-0b63 : 0000:00:0f.0
          0b60-0b63 : sata_nv
        0b70-0b73 : 0000:00:0e.0
          0b70-0b73 : sata_nv
        0be0-0be3 : 0000:00:0f.0
          0be0-0be3 : sata_nv
        0bf0-0bf3 : 0000:00:0e.0
          0bf0-0bf3 : sata_nv
        0cf8-0cff : PCI conf1
        2000-207f : motherboard
          2000-207f : pnp 00:01
        2080-20ff : motherboard
          2080-20ff : pnp 00:01
        4000-407f : motherboard
          4000-4003 : ACPI PM1a_EVT_BLK
          4004-4005 : ACPI PM1a_CNT_BLK
          4008-400b : ACPI PM_TMR
          401c-401c : ACPI PM2_CNT_BLK
          4020-4027 : ACPI GPE0_BLK
        4080-40ff : motherboard
          4080-40ff : pnp 00:01
        4400-447f : motherboard
          4400-447f : pnp 00:01
        4480-44ff : motherboard
          44a0-44af : ACPI GPE1_BLK
        4800-487f : motherboard
          4800-487f : pnp 00:01
        4880-48ff : motherboard
          4880-48ff : pnp 00:01
        4c00-4c3f : 0000:00:0a.1
          4c00-4c3f : nForce2_smbus
        4c40-4c7f : 0000:00:0a.1
          4c40-4c7f : nForce2_smbus
        b000-bfff : PCI Bus #01
        c800-c807 : 0000:00:14.0
          c800-c807 : forcedeth
        cc00-cc0f : 0000:00:0f.0
          cc00-cc0f : sata_nv
        e000-e00f : 0000:00:0e.0
          e000-e00f : sata_nv
        f400-f40f : 0000:00:0d.0
          f400-f407 : ide0
          f408-f40f : ide1
        
[7.5.] PCI information ('lspci -vvv' as root)

        00:00.0 RAM memory: nVidia Corporation C51 Host Bridge (rev a2)
                Subsystem: ASUSTeK Computer Inc. Unknown device 81c0
                Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
                Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
                Latency: 0
                Capabilities: [44] HyperTransport: Slave or Primary Interface
                        Command: BaseUnitID=0 UnitCnt=15 MastHost- DefDir- DUL-
                        Link Control 0: CFlE+ CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
                        Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
                        Link Control 1: CFlE+ CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- LSEn+ ExtCTL- 64b-
                        Link Config 1: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=8bit DwFcInEn- LWO=8bit DwFcOutEn-
                        Revision ID: 1.03
                        Link Frequency 0: 1.0GHz
                        Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
                        Link Frequency Capability 0: 200MHz+ 300MHz+ 400MHz+ 500MHz+ 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
                        Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
                        Link Frequency 1: 800MHz
                        Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
                        Link Frequency Capability 1: 200MHz+ 300MHz+ 400MHz+ 500MHz+ 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
                        Error Handling: PFlE+ OFlE+ PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF- RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
                        Prefetchable memory behind bridge Upper: 00-00
                        Bus Number: 00
                Capabilities: [e0] HyperTransport: MSI Mapping
        
        00:00.1 RAM memory: nVidia Corporation C51 Memory Controller 0 (rev a2)
                Subsystem: ASUSTeK Computer Inc. Unknown device 81c0
                Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
                Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR+ <PERR-
        
        00:00.2 RAM memory: nVidia Corporation C51 Memory Controller 1 (rev a2)
                Subsystem: ASUSTeK Computer Inc. Unknown device 81c0
                Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
                Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        
        00:00.3 RAM memory: nVidia Corporation C51 Memory Controller 5 (rev a2)
                Subsystem: ASUSTeK Computer Inc. Unknown device 81c0
                Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
                Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        
        00:00.4 RAM memory: nVidia Corporation C51 Memory Controller 4 (rev a2)
                Subsystem: ASUSTeK Computer Inc. Unknown device 81c0
                Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
                Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
                Latency: 0
        
        00:00.5 RAM memory: nVidia Corporation C51 Host Bridge (rev a2)
                Subsystem: ASUSTeK Computer Inc. Unknown device 81c0
                Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
                Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
                Latency: 0
                Capabilities: [44] #00 [00fe]
                Capabilities: [fc] #00 [0000]
        
        00:00.6 RAM memory: nVidia Corporation C51 Memory Controller 3 (rev a2)
                Subsystem: ASUSTeK Computer Inc. Unknown device 81c0
                Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
                Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        
        00:00.7 RAM memory: nVidia Corporation C51 Memory Controller 2 (rev a2)
                Subsystem: ASUSTeK Computer Inc. Unknown device 81c0
                Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
                Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        
        00:05.0 VGA compatible controller: nVidia Corporation C51PV [GeForce 6150] (rev a2) (prog-if 00 [VGA])
                Subsystem: ASUSTeK Computer Inc. Unknown device 81cd
                Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
                Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
                Latency: 0
                Interrupt: pin A routed to IRQ 21
                Region 0: Memory at fc000000 (32-bit, non-prefetchable) [size=16M]
                Region 1: Memory at d0000000 (64-bit, prefetchable) [size=256M]
                Region 3: Memory at fb000000 (64-bit, non-prefetchable) [size=16M]
                [virtual] Expansion ROM at 88000000 [disabled] [size=128K]
                Capabilities: [48] Power Management version 2
                        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
                Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
                        Address: 0000000000000000  Data: 0000
        
        00:09.0 RAM memory: nVidia Corporation MCP51 Host Bridge (rev a2)
                Subsystem: ASUSTeK Computer Inc. Unknown device 81c0
                Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
                Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
                Latency: 0
                Capabilities: [44] HyperTransport: Slave or Primary Interface
                        Command: BaseUnitID=9 UnitCnt=15 MastHost- DefDir- DUL-
                        Link Control 0: CFlE+ CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- LSEn+ ExtCTL- 64b-
                        Link Config 0: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit DwFcInEn- LWO=8bit DwFcOutEn-
                        Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
                        Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit DwFcInEn- LWO=8bit DwFcOutEn-
                        Revision ID: 1.03
                        Link Frequency 0: 800MHz
                        Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
                        Link Frequency Capability 0: 200MHz+ 300MHz+ 400MHz+ 500MHz+ 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
                        Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
                        Link Frequency 1: 200MHz
                        Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
                        Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 600MHz- 800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
                        Error Handling: PFlE+ OFlE+ PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF- RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
                        Prefetchable memory behind bridge Upper: 00-00
                        Bus Number: 00
                Capabilities: [e0] HyperTransport: MSI Mapping
        
        00:0a.0 ISA bridge: nVidia Corporation MCP51 LPC Bridge (rev a3)
                Subsystem: ASUSTeK Computer Inc. Unknown device 81c0
                Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
                Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
                Latency: 0
        
        00:0a.1 SMBus: nVidia Corporation MCP51 SMBus (rev a3)
                Subsystem: ASUSTeK Computer Inc. Unknown device 81c0
                Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
                Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
                Interrupt: pin A routed to IRQ 5
                Region 4: I/O ports at 4c00 [size=64]
                Region 5: I/O ports at 4c40 [size=64]
                Capabilities: [44] Power Management version 2
                        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
                        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        
        00:0a.2 RAM memory: nVidia Corporation MCP51 Memory Controller 0 (rev a3)
                Subsystem: ASUSTeK Computer Inc. Unknown device 81c0
                Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
                Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        
        00:0b.0 USB Controller: nVidia Corporation MCP51 USB Controller (rev a3) (prog-if 10 [OHCI])
                Subsystem: ASUSTeK Computer Inc. Unknown device 81c0
                Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
                Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
                Latency: 0 (750ns min, 250ns max)
                Interrupt: pin A routed to IRQ 17
                Region 0: Memory at fe02f000 (32-bit, non-prefetchable) [size=4K]
                Capabilities: [44] Power Management version 2
                        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        
        00:0b.1 USB Controller: nVidia Corporation MCP51 USB Controller (rev a3) (prog-if 20 [EHCI])
                Subsystem: ASUSTeK Computer Inc. Unknown device 81c0
                Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
                Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
                Latency: 0 (750ns min, 250ns max)
                Interrupt: pin B routed to IRQ 19
                Region 0: Memory at fe02e000 (32-bit, non-prefetchable) [size=256]
                Capabilities: [44] Debug port
                Capabilities: [80] Power Management version 2
                        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                        Status: D0 PME-Enable- DSel=0 DScale=0 PME+
        
        00:0d.0 IDE interface: nVidia Corporation MCP51 IDE (rev a1) (prog-if 8a [Master SecP PriP])
                Subsystem: ASUSTeK Computer Inc. Unknown device 81c0
                Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
                Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
                Latency: 0 (750ns min, 250ns max)
                Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=8]
                Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=1]
                Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=8]
                Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=1]
                Region 4: I/O ports at f400 [size=16]
                Capabilities: [44] Power Management version 2
                        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        
        00:0e.0 IDE interface: nVidia Corporation MCP51 Serial ATA Controller (rev a1) (prog-if 85 [Master SecO PriO])
                Subsystem: ASUSTeK Computer Inc. Unknown device 81c0
                Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
                Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
                Latency: 0 (750ns min, 250ns max)
                Interrupt: pin A routed to IRQ 20
                Region 0: I/O ports at 09f0 [size=8]
                Region 1: I/O ports at 0bf0 [size=4]
                Region 2: I/O ports at 0970 [size=8]
                Region 3: I/O ports at 0b70 [size=4]
                Region 4: I/O ports at e000 [size=16]
                Region 5: Memory at fe02d000 (32-bit, non-prefetchable) [size=4K]
                Capabilities: [44] Power Management version 2
                        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
                Capabilities: [b0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/2 Enable-
                        Address: 0000000000000000  Data: 0000
                Capabilities: [cc] HyperTransport: MSI Mapping
        
        00:0f.0 IDE interface: nVidia Corporation MCP51 Serial ATA Controller (rev a1) (prog-if 85 [Master SecO PriO])
                Subsystem: ASUSTeK Computer Inc. Unknown device 81c0
                Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
                Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
                Latency: 0 (750ns min, 250ns max)
                Interrupt: pin A routed to IRQ 16
                Region 0: I/O ports at 09e0 [size=8]
                Region 1: I/O ports at 0be0 [size=4]
                Region 2: I/O ports at 0960 [size=8]
                Region 3: I/O ports at 0b60 [size=4]
                Region 4: I/O ports at cc00 [size=16]
                Region 5: Memory at fe02c000 (32-bit, non-prefetchable) [size=4K]
                Capabilities: [44] Power Management version 2
                        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
                Capabilities: [b0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/2 Enable-
                        Address: 0000000000000000  Data: 0000
                Capabilities: [cc] HyperTransport: MSI Mapping
        
        00:10.0 PCI bridge: nVidia Corporation MCP51 PCI Bridge (rev a2) (prog-if 01 [Subtractive decode])
                Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
                Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
                Latency: 0
                Bus: primary=00, secondary=01, subordinate=01, sec-latency=128
                I/O behind bridge: 0000b000-0000bfff
                Memory behind bridge: fdd00000-fddfffff
                Prefetchable memory behind bridge: fde00000-fdefffff
                Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR+
                BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
                Capabilities: [b8] Subsystem: Gammagraphx, Inc. Unknown device 0000
                Capabilities: [8c] HyperTransport: MSI Mapping
        
        00:10.1 Audio device: nVidia Corporation MCP51 High Definition Audio (rev a2)
                Subsystem: ASUSTeK Computer Inc. Unknown device 81cb
                Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
                Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
                Latency: 0 (500ns min, 1250ns max)
                Interrupt: pin B routed to IRQ 17
                Region 0: Memory at fe024000 (32-bit, non-prefetchable) [size=16K]
                Capabilities: [44] Power Management version 2
                        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
                        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
                Capabilities: [50] Message Signalled Interrupts: Mask+ 64bit+ Queue=0/0 Enable-
                        Address: 0000000000000000  Data: 0000
                        Masking: 00000000  Pending: 00000000
                Capabilities: [6c] HyperTransport: MSI Mapping
        
        00:14.0 Bridge: nVidia Corporation MCP51 Ethernet Controller (rev a3)
                Subsystem: ASUSTeK Computer Inc. Unknown device 816a
                Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
                Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
                Latency: 0 (250ns min, 5000ns max)
                Interrupt: pin A routed to IRQ 16
                Region 0: Memory at fe02b000 (32-bit, non-prefetchable) [size=4K]
                Region 1: I/O ports at c800 [size=8]
                Capabilities: [44] Power Management version 2
                        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                        Status: D0 PME-Enable+ DSel=0 DScale=0 PME-
        
        00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
                Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
                Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
                Capabilities: [80] HyperTransport: Host or Secondary Interface
                        !!! Possibly incomplete decoding
                        Command: WarmRst+ DblEnd-
                        Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
                        Link Config: MLWI=16bit MLWO=16bit LWI=16bit LWO=16bit
                        Revision ID: 1.02
        
        00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
                Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
                Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        
        00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
                Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
                Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        
        00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
                Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
                Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
                Capabilities: [f0] #0f [0010]
        
        01:05.0 FireWire (IEEE 1394): Texas Instruments TSB43AB22/A IEEE-1394a-2000 Controller (PHY/Link) (prog-if 10 [OHCI])
                Subsystem: ASUSTeK Computer Inc. K8N4-E Mainboard
                Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
                Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
                Latency: 32 (500ns min, 1000ns max), Cache Line Size: 32 bytes
                Interrupt: pin A routed to IRQ 18
                Region 0: Memory at fddff000 (32-bit, non-prefetchable) [size=2K]
                Region 1: Memory at fddf8000 (32-bit, non-prefetchable) [size=16K]
                Capabilities: [44] Power Management version 2
                        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
                        Status: D0 PME-Enable- DSel=0 DScale=0 PME+
        
[7.6.] SCSI information (from /proc/scsi/scsi)

        Attached devices:
        Host: scsi0 Channel: 00 Id: 00 Lun: 00
          Vendor: ATA      Model: Maxtor 6V320F0   Rev: VA11
          Type:   Direct-Access                    ANSI SCSI revision: 05
        Host: scsi1 Channel: 00 Id: 00 Lun: 00
          Vendor: ATA      Model: Maxtor 6V320F0   Rev: VA11
          Type:   Direct-Access                    ANSI SCSI revision: 05
        
[7.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):

