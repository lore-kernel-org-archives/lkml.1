Return-Path: <linux-kernel-owner+w=401wt.eu-S1754865AbYGDLL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbYGDLL3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 07:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbYGDLLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 07:11:21 -0400
Received: from mxl.seznam.cz ([77.75.72.44]:39626 "EHLO mxl.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbYGDLLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 07:11:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=beta; d=seznam.cz;
	h=To:Date:From:Received:Subject:Mime-Version:Message-Id:Content-Transfer-Encoding:Content-Type:X-Abuse:X-Seznam-User:X-QM-Mark;
	b=XtdHZlfxMLQaA16XSUUZe99EJeH0Z61t4vb+Vau2avv/pTLF7kurWTmYuFdlKH5Zv
	FLOtKhGYCukhYP5/b1PCIiguR8ycgF7LSqskOoMvqI3E4b5w5kdP3hhf2GwVhLJF206
	K6Nwoja40QEV2udMZP/Cv6BZ8XbyBLsSJ+V10mM=
To: =?us-ascii?Q?Jon=20Loelinger?= <jdl@freescale.com>,
       =?us-ascii?Q?John=20Linn?= <john.linn@xilinx.com>,
       =?us-ascii?Q?John=20Williams?= <john.williams@petalogix.com>,
       =?us-ascii?Q?Stephen=20Neuendorffer?= <stephenn@xilinx.com>,
       =?us-ascii?Q?Linux=20Kernel=20list?= <linux-kernel@vger.kernel.org>,
       =?us-ascii?Q?David=20Gibson?= <david@gibson.dropbear.id.au>
Date: Fri, 04 Jul 2008 13:10:59 +0200 (CEST)
From: =?us-ascii?Q?Michal=20Simek?= <Monstr@seznam.cz>
Subject: =?us-ascii?Q?Microblaze=20dts=5Fv1=20for=20kernel=2Eorg?=
Mime-Version: 1.0
Message-Id: <4121.6626-23519-216749357-1215169859@seznam.cz>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset="us-ascii"
X-Abuse: abuse@seznam.cz
X-Seznam-User: Monstr@seznam.cz
X-QM-Mark: email-qm1<175894170>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jon, David and others,

I made some changes in my FDT generator. Here is the output for my testing platform. 
Could you check this generated DTS file? 

I would like to push the similar file with Microblaze kernel. (I'll do more generic DTS file with generic name and remove some unsupported peripherals)

For Steve: I'll send to you these changes later.

Thanks,
Michal Simek


/dts-v1/;

/ {
	#address-cells = <1>;
	#size-cells = <1>;
	compatible = "xlnx,microblaze";
	model = "testing";
	DDR_SDRAM_32Mx16: memory@20000000 {
		device_type = "memory";
		reg = < 0x20000000 0x4000000 >;
	} ;
	chosen {
		bootargs = "console=ttyUL0,115200";
	} ;
	cpus {
		#address-cells = <1>;
		#cpus = <1>;
		#size-cells = <0>;
		microblaze_0: cpu@0 {
			clock-frequency = <50000000>;
			compatible = "xlnx,microblaze-7.00.b";
			d-cache-baseaddr = <0x20000000>;
			d-cache-highaddr = <0x21ffffff>;
			d-cache-line-size = <0x10>;
			d-cache-size = <0x4000>;
			device_type = "cpu";
			i-cache-baseaddr = <0x20000000>;
			i-cache-highaddr = <0x21ffffff>;
			i-cache-line-size = <0x10>;
			i-cache-size = <0x4000>;
			model = "microblaze,7.00.b";
			reg = <0>;
			timebase-frequency = <50000000>;
			xlnx,addr-tag-bits = <0xb>;
			xlnx,allow-dcache-wr = <0x1>;
			xlnx,allow-icache-wr = <0x1>;
			xlnx,area-optimized = <0x0>;
			xlnx,cache-byte-size = <0x4000>;
			xlnx,d-lmb = <0x1>;
			xlnx,d-opb = <0x0>;
			xlnx,d-plb = <0x1>;
			xlnx,data-size = <0x20>;
			xlnx,dcache-addr-tag = <0xb>;
			xlnx,dcache-byte-size = <0x4000>;
			xlnx,dcache-line-len = <0x4>;
			xlnx,dcache-use-fsl = <0x1>;
			xlnx,debug-enabled = <0x1>;
			xlnx,div-zero-exception = <0x1>;
			xlnx,dopb-bus-exception = <0x0>;
			xlnx,dynamic-bus-sizing = <0x1>;
			xlnx,edge-is-positive = <0x1>;
			xlnx,family = "spartan3e";
			xlnx,fpu-exception = <0x1>;
			xlnx,fsl-data-size = <0x20>;
			xlnx,fsl-exception = <0x0>;
			xlnx,fsl-links = <0x1>;
			xlnx,i-lmb = <0x1>;
			xlnx,i-opb = <0x0>;
			xlnx,i-plb = <0x1>;
			xlnx,icache-line-len = <0x4>;
			xlnx,icache-use-fsl = <0x1>;
			xlnx,ill-opcode-exception = <0x1>;
			xlnx,instance = "microblaze_0";
			xlnx,interconnect = <0x1>;
			xlnx,interrupt-is-edge = <0x0>;
			xlnx,iopb-bus-exception = <0x0>;
			xlnx,mmu-dtlb-size = <0x4>;
			xlnx,mmu-itlb-size = <0x2>;
			xlnx,mmu-tlb-access = <0x3>;
			xlnx,mmu-zones = <0x2>;
			xlnx,number-of-pc-brk = <0x3>;
			xlnx,number-of-rd-addr-brk = <0x3>;
			xlnx,number-of-wr-addr-brk = <0x3>;
			xlnx,opcode-0x0-illegal = <0x1>;
			xlnx,pvr = <0x2>;
			xlnx,pvr-user1 = <0x12>;
			xlnx,pvr-user2 = <0x12345678>;
			xlnx,reset-msr = <0x0>;
			xlnx,sco = <0x0>;
			xlnx,unaligned-exceptions = <0x1>;
			xlnx,use-barrel = <0x1>;
			xlnx,use-dcache = <0x1>;
			xlnx,use-div = <0x1>;
			xlnx,use-extended-fsl-instr = <0x0>;
			xlnx,use-fpu = <0x2>;
			xlnx,use-hw-mul = <0x2>;
			xlnx,use-icache = <0x1>;
			xlnx,use-mmu = <0x3>;
			xlnx,use-msr-instr = <0x1>;
			xlnx,use-pcmp-instr = <0x1>;
		} ;
	} ;
	mb_plb: plb@0 {
		#address-cells = <1>;
		#size-cells = <1>;
		compatible = "xlnx,plb-v46-1.00.a", "simple-bus";
		ranges ;
		Buttons_3Bit: gpio@40800000 {
			compatible = "xlnx,xps-gpio-1.00.a";
			interrupt-parent = <&xps_intc_0>;
			interrupts = < 6 0x2 >;
			reg = < 0x40800000 0x100000 >;
			xlnx,all-inputs = <0x1>;
			xlnx,all-inputs-2 = <0x0>;
			xlnx,dout-default = <0x0>;
			xlnx,dout-default-2 = <0x0>;
			xlnx,family = "spartan3e";
			xlnx,gpio-width = <0x3>;
			xlnx,interrupt-present = <0x1>;
			xlnx,is-bidir = <0x0>;
			xlnx,is-bidir-2 = <0x1>;
			xlnx,is-dual = <0x0>;
			xlnx,tri-default = <0xffffffff>;
			xlnx,tri-default-2 = <0xffffffff>;
		} ;
		Character_LCD_2x16: gpio@40900000 {
			compatible = "xlnx,xps-gpio-1.00.a";
			reg = < 0x40900000 0x100000 >;
			xlnx,all-inputs = <0x0>;
			xlnx,all-inputs-2 = <0x0>;
			xlnx,dout-default = <0x0>;
			xlnx,dout-default-2 = <0x0>;
			xlnx,family = "spartan3e";
			xlnx,gpio-width = <0x7>;
			xlnx,interrupt-present = <0x0>;
			xlnx,is-bidir = <0x1>;
			xlnx,is-bidir-2 = <0x1>;
			xlnx,is-dual = <0x0>;
			xlnx,tri-default = <0xffffffff>;
			xlnx,tri-default-2 = <0xffffffff>;
		} ;
		DIP_Switches_4Bit: gpio@40700000 {
			compatible = "xlnx,xps-gpio-1.00.a";
			interrupt-parent = <&xps_intc_0>;
			interrupts = < 7 0x2 >;
			reg = < 0x40700000 0x100000 >;
			xlnx,all-inputs = <0x1>;
			xlnx,all-inputs-2 = <0x0>;
			xlnx,dout-default = <0x0>;
			xlnx,dout-default-2 = <0x0>;
			xlnx,family = "spartan3e";
			xlnx,gpio-width = <0x4>;
			xlnx,interrupt-present = <0x1>;
			xlnx,is-bidir = <0x0>;
			xlnx,is-bidir-2 = <0x1>;
			xlnx,is-dual = <0x0>;
			xlnx,tri-default = <0xffffffff>;
			xlnx,tri-default-2 = <0xffffffff>;
		} ;
		Ethernet_MAC: ethernet@40c00000 {
			compatible = "xlnx,xps-ethernetlite-1.00.a";
			device_type = "network";
			interrupt-parent = <&xps_intc_0>;
			interrupts = < 2 0x0 >;
			local-mac-address = [ 02 00 00 00 00 00 ];
			reg = < 0x40c00000 0x100000 >;
			xlnx,duplex = <0x1>;
			xlnx,family = "spartan3e";
			xlnx,rx-ping-pong = <0x0>;
			xlnx,tx-ping-pong = <0x0>;
		} ;
		LEDs_8Bit: gpio@40600000 {
			compatible = "xlnx,xps-gpio-1.00.a";
			reg = < 0x40600000 0x100000 >;
			xlnx,all-inputs = <0x0>;
			xlnx,all-inputs-2 = <0x0>;
			xlnx,dout-default = <0x0>;
			xlnx,dout-default-2 = <0x0>;
			xlnx,family = "spartan3e";
			xlnx,gpio-width = <0x8>;
			xlnx,interrupt-present = <0x0>;
			xlnx,is-bidir = <0x0>;
			xlnx,is-bidir-2 = <0x1>;
			xlnx,is-dual = <0x0>;
			xlnx,tri-default = <0xffffffff>;
			xlnx,tri-default-2 = <0xffffffff>;
		} ;
		RS232_DCE: serial@40200000 {
			clock-frequency = <50000000>;
			compatible = "xlnx,xps-uart16550-1.00.a", "ns16550";
			current-speed = <9600>;
			device_type = "serial";
			interrupt-parent = <&xps_intc_0>;
			interrupts = < 4 0x2 >;
			reg = < 0x40200000 0x100000 >;
			reg-offset = <3>;
			reg-shift = <2>;
			xlnx,family = "spartan3e";
			xlnx,has-external-rclk = <0x0>;
			xlnx,has-external-xin = <0x0>;
			xlnx,is-a-16550 = <0x1>;
		} ;
		RS232_DTE: serial@40100000 {
			clock-frequency = <50000000>;
			compatible = "xlnx,xps-uartlite-1.00.a";
			device_type = "serial";
			interrupt-parent = <&xps_intc_0>;
			interrupts = < 3 0x0 >;
			port-number = <0>;
			reg = < 0x40100000 0x100000 >;
			xlnx,baudrate = <0x1c200>;
			xlnx,data-bits = <0x8>;
			xlnx,family = "spartan3e";
			xlnx,odd-parity = <0x0>;
			xlnx,use-parity = <0x0>;
		} ;
		SPI_FLASH: xps-spi@40a00000 {
			compatible = "xlnx,xps-spi-1.00.a";
			interrupt-parent = <&xps_intc_0>;
			interrupts = < 5 0x2 >;
			reg = < 0x40a00000 0x100000 >;
			xlnx,family = "spartan3e";
			xlnx,fifo-exist = <0x1>;
			xlnx,num-offchip-ss-bits = <0x4>;
			xlnx,num-ss-bits = <0x4>;
			xlnx,sck-ratio = <0x20>;
		} ;
		debug_module: debug@40300000 {
			compatible = "xlnx,mdm-1.00.a";
			reg = < 0x40300000 0x100000 >;
			xlnx,family = "spartan3e";
			xlnx,interconnect = <0x1>;
			xlnx,jtag-chain = <0x2>;
			xlnx,mb-dbg-ports = <0x1>;
			xlnx,uart-width = <0x8>;
			xlnx,use-uart = <0x1>;
			xlnx,write-fsl-ports = <0x1>;
		} ;
		mpmc@20000000 {
			#address-cells = <1>;
			#size-cells = <1>;
			compatible = "xlnx,mpmc-3.00.a";
		} ;
		xps_intc_0: interrupt-controller@40000000 {
			#interrupt-cells = <2>;
			compatible = "xlnx,xps-intc-1.00.a";
			interrupt-controller ;
			reg = < 0x40000000 0x100000 >;
			xlnx,kind-of-edge = <0xc>;
			xlnx,num-intr-inputs = <0x8>;
		} ;
		xps_timer_0: timer@40400000 {
			compatible = "xlnx,xps-timer-1.00.a";
			interrupt-parent = <&xps_intc_0>;
			interrupts = < 0 0x2 >;
			reg = < 0x40400000 0x100000 >;
			xlnx,count-width = <0x20>;
			xlnx,family = "spartan3e";
			xlnx,gen0-assert = <0x1>;
			xlnx,gen1-assert = <0x1>;
			xlnx,one-timer-only = <0x0>;
			xlnx,trig0-assert = <0x1>;
			xlnx,trig1-assert = <0x1>;
		} ;
		xps_timer_1: timer@40500000 {
			compatible = "xlnx,xps-timer-1.00.a";
			interrupt-parent = <&xps_intc_0>;
			interrupts = < 1 0x2 >;
			reg = < 0x40500000 0x100000 >;
			xlnx,count-width = <0x20>;
			xlnx,family = "spartan3e";
			xlnx,gen0-assert = <0x1>;
			xlnx,gen1-assert = <0x1>;
			xlnx,one-timer-only = <0x1>;
			xlnx,trig0-assert = <0x1>;
			xlnx,trig1-assert = <0x1>;
		} ;
	} ;
}  ;
