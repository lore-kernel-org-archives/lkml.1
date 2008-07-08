Return-Path: <linux-kernel-owner+w=401wt.eu-S1757933AbYGHMJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933AbYGHMJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 08:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758235AbYGHMJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 08:09:32 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:25837 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757710AbYGHMJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 08:09:30 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: monstr@seznam.cz, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, vapier.adi@gmail.com,
       alan@lxorguk.ukuu.org.uk, hpa@zytor.com, lethal@linux-sh.org,
       florian@openwrt.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 11/58] microblaze_v5: Generic dts file for platforms
Date: Tue,  8 Jul 2008 13:59:11 +0200
Message-Id: <dbd9df742cdd9eb3355d7bc8e39f9dfef6c545e4.1215517976.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <f7458acb0252f72b5620d19c76104408ecc2e451.1215517976.git.monstr@monstr.eu>
References: <1215518398-5057-1-git-send-email-monstr@monstr.eu>
 <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
 <c03d29cbccaef8aed8a2911c2a259fbd79ad23d9.1215517976.git.monstr@monstr.eu>
 <58f35f498bac29e7105c589c06567e86c5a42dd5.1215517976.git.monstr@monstr.eu>
 <810775b1bb678003923039726a9153ee34fb67b4.1215517976.git.monstr@monstr.eu>
 <2a24e5bc2cfbd349613ef10c716a28f04ce24a9f.1215517976.git.monstr@monstr.eu>
 <3171c5cf21eefc79665165f4a14bc5b68dd03f95.1215517976.git.monstr@monstr.eu>
 <9be4eff2f4d015023c453eaec3b3473a44380491.1215517976.git.monstr@monstr.eu>
 <f8e331ed9432719f3c0555c840cbbb7bbc1a6322.1215517976.git.monstr@monstr.eu>
 <4409daf2ac356e902a8f091bb5908eb8a90218bc.1215517976.git.monstr@monstr.eu>
 <f7458acb0252f72b5620d19c76104408ecc2e451.1215517976.git.monstr@monstr.eu>
In-Reply-To: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
References: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Acked-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/platform/generic/system.dts |  269 +++++++++++++++++++++++++++
 1 files changed, 269 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/platform/generic/system.dts

diff --git a/arch/microblaze/platform/generic/system.dts b/arch/microblaze/platform/generic/system.dts
new file mode 100644
index 0000000..91b21c7
--- /dev/null
+++ b/arch/microblaze/platform/generic/system.dts
@@ -0,0 +1,269 @@
+/dts-v1/;
+
+/ {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	compatible = "xlnx,microblaze";
+	model = "testing";
+	memory: memory@20000000 {
+		device_type = "memory";
+		reg = < 0x20000000 0x2000000 >;
+	} ;
+	chosen {
+		bootargs = "console=ttyUL0,115200";
+	} ;
+	cpus {
+		#address-cells = <1>;
+		#cpus = <1>;
+		#size-cells = <0>;
+		microblaze_0: cpu@0 {
+			clock-frequency = <50000000>;
+			compatible = "xlnx,microblaze-7.00.b";
+			d-cache-baseaddr = <0x20000000>;
+			d-cache-highaddr = <0x21ffffff>;
+			d-cache-line-size = <0x10>;
+			d-cache-size = <0x4000>;
+			device_type = "cpu";
+			i-cache-baseaddr = <0x20000000>;
+			i-cache-highaddr = <0x21ffffff>;
+			i-cache-line-size = <0x10>;
+			i-cache-size = <0x4000>;
+			model = "microblaze,7.00.b";
+			reg = <0>;
+			timebase-frequency = <50000000>;
+			xlnx,addr-tag-bits = <0xb>;
+			xlnx,allow-dcache-wr = <0x1>;
+			xlnx,allow-icache-wr = <0x1>;
+			xlnx,area-optimized = <0x0>;
+			xlnx,cache-byte-size = <0x4000>;
+			xlnx,d-lmb = <0x1>;
+			xlnx,d-opb = <0x0>;
+			xlnx,d-plb = <0x1>;
+			xlnx,data-size = <0x20>;
+			xlnx,dcache-addr-tag = <0xb>;
+			xlnx,dcache-byte-size = <0x4000>;
+			xlnx,dcache-line-len = <0x4>;
+			xlnx,dcache-use-fsl = <0x1>;
+			xlnx,debug-enabled = <0x1>;
+			xlnx,div-zero-exception = <0x1>;
+			xlnx,dopb-bus-exception = <0x0>;
+			xlnx,dynamic-bus-sizing = <0x1>;
+			xlnx,edge-is-positive = <0x1>;
+			xlnx,family = "spartan3e";
+			xlnx,fpu-exception = <0x1>;
+			xlnx,fsl-data-size = <0x20>;
+			xlnx,fsl-exception = <0x0>;
+			xlnx,fsl-links = <0x1>;
+			xlnx,i-lmb = <0x1>;
+			xlnx,i-opb = <0x0>;
+			xlnx,i-plb = <0x1>;
+			xlnx,icache-line-len = <0x4>;
+			xlnx,icache-use-fsl = <0x1>;
+			xlnx,ill-opcode-exception = <0x1>;
+			xlnx,instance = "microblaze_0";
+			xlnx,interconnect = <0x1>;
+			xlnx,interrupt-is-edge = <0x0>;
+			xlnx,iopb-bus-exception = <0x0>;
+			xlnx,mmu-dtlb-size = <0x4>;
+			xlnx,mmu-itlb-size = <0x2>;
+			xlnx,mmu-tlb-access = <0x3>;
+			xlnx,mmu-zones = <0x2>;
+			xlnx,number-of-pc-brk = <0x3>;
+			xlnx,number-of-rd-addr-brk = <0x3>;
+			xlnx,number-of-wr-addr-brk = <0x3>;
+			xlnx,opcode-0x0-illegal = <0x1>;
+			xlnx,pvr = <0x2>;
+			xlnx,pvr-user1 = <0x12>;
+			xlnx,pvr-user2 = <0x12345678>;
+			xlnx,reset-msr = <0x0>;
+			xlnx,sco = <0x0>;
+			xlnx,unaligned-exceptions = <0x1>;
+			xlnx,use-barrel = <0x1>;
+			xlnx,use-dcache = <0x1>;
+			xlnx,use-div = <0x1>;
+			xlnx,use-extended-fsl-instr = <0x0>;
+			xlnx,use-fpu = <0x2>;
+			xlnx,use-hw-mul = <0x2>;
+			xlnx,use-icache = <0x1>;
+			xlnx,use-mmu = <0x3>;
+			xlnx,use-msr-instr = <0x1>;
+			xlnx,use-pcmp-instr = <0x1>;
+		} ;
+	} ;
+	mb_plb: plb@0 {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "xlnx,plb-v46-1.00.a", "simple-bus";
+		ranges ;
+		gpio_0: gpio@40800000 {
+			compatible = "xlnx,xps-gpio-1.00.a";
+			interrupt-parent = <&xps_intc_0>;
+			interrupts = < 6 0x2 >;
+			reg = < 0x40800000 0x100000 >;
+			xlnx,all-inputs = <0x1>;
+			xlnx,all-inputs-2 = <0x0>;
+			xlnx,dout-default = <0x0>;
+			xlnx,dout-default-2 = <0x0>;
+			xlnx,family = "spartan3e";
+			xlnx,gpio-width = <0x3>;
+			xlnx,interrupt-present = <0x1>;
+			xlnx,is-bidir = <0x0>;
+			xlnx,is-bidir-2 = <0x1>;
+			xlnx,is-dual = <0x0>;
+			xlnx,tri-default = <0xffffffff>;
+			xlnx,tri-default-2 = <0xffffffff>;
+		} ;
+		gpio_1: gpio@40900000 {
+			compatible = "xlnx,xps-gpio-1.00.a";
+			reg = < 0x40900000 0x100000 >;
+			xlnx,all-inputs = <0x0>;
+			xlnx,all-inputs-2 = <0x0>;
+			xlnx,dout-default = <0x0>;
+			xlnx,dout-default-2 = <0x0>;
+			xlnx,family = "spartan3e";
+			xlnx,gpio-width = <0x7>;
+			xlnx,interrupt-present = <0x0>;
+			xlnx,is-bidir = <0x1>;
+			xlnx,is-bidir-2 = <0x1>;
+			xlnx,is-dual = <0x0>;
+			xlnx,tri-default = <0xffffffff>;
+			xlnx,tri-default-2 = <0xffffffff>;
+		} ;
+		gpio_2: gpio@40700000 {
+			compatible = "xlnx,xps-gpio-1.00.a";
+			interrupt-parent = <&xps_intc_0>;
+			interrupts = < 7 0x2 >;
+			reg = < 0x40700000 0x100000 >;
+			xlnx,all-inputs = <0x1>;
+			xlnx,all-inputs-2 = <0x0>;
+			xlnx,dout-default = <0x0>;
+			xlnx,dout-default-2 = <0x0>;
+			xlnx,family = "spartan3e";
+			xlnx,gpio-width = <0x4>;
+			xlnx,interrupt-present = <0x1>;
+			xlnx,is-bidir = <0x0>;
+			xlnx,is-bidir-2 = <0x1>;
+			xlnx,is-dual = <0x0>;
+			xlnx,tri-default = <0xffffffff>;
+			xlnx,tri-default-2 = <0xffffffff>;
+		} ;
+		gpio_3: gpio@40600000 {
+			compatible = "xlnx,xps-gpio-1.00.a";
+			reg = < 0x40600000 0x100000 >;
+			xlnx,all-inputs = <0x0>;
+			xlnx,all-inputs-2 = <0x0>;
+			xlnx,dout-default = <0x0>;
+			xlnx,dout-default-2 = <0x0>;
+			xlnx,family = "spartan3e";
+			xlnx,gpio-width = <0x8>;
+			xlnx,interrupt-present = <0x0>;
+			xlnx,is-bidir = <0x0>;
+			xlnx,is-bidir-2 = <0x1>;
+			xlnx,is-dual = <0x0>;
+			xlnx,tri-default = <0xffffffff>;
+			xlnx,tri-default-2 = <0xffffffff>;
+		} ;
+		emaclite: ethernet@40c00000 {
+			compatible = "xlnx,xps-ethernetlite-1.00.a";
+			device_type = "network";
+			interrupt-parent = <&xps_intc_0>;
+			interrupts = < 2 0x0 >;
+			local-mac-address = [ 02 00 00 00 00 00 ];
+			reg = < 0x40c00000 0x100000 >;
+			xlnx,duplex = <0x1>;
+			xlnx,family = "spartan3e";
+			xlnx,rx-ping-pong = <0x0>;
+			xlnx,tx-ping-pong = <0x0>;
+		} ;
+		uart16550: serial@40200000 {
+			clock-frequency = <50000000>;
+			compatible = "xlnx,xps-uart16550-1.00.a", "ns16550";
+			current-speed = <9600>;
+			device_type = "serial";
+			interrupt-parent = <&xps_intc_0>;
+			interrupts = < 4 0x2 >;
+			reg = < 0x40200000 0x100000 >;
+			reg-offset = <3>;
+			reg-shift = <2>;
+			xlnx,family = "spartan3e";
+			xlnx,has-external-rclk = <0x0>;
+			xlnx,has-external-xin = <0x0>;
+			xlnx,is-a-16550 = <0x1>;
+		} ;
+		uartlite: serial@40100000 {
+			clock-frequency = <50000000>;
+			compatible = "xlnx,xps-uartlite-1.00.a";
+			device_type = "serial";
+			interrupt-parent = <&xps_intc_0>;
+			interrupts = < 3 0x0 >;
+			port-number = <0>;
+			reg = < 0x40100000 0x100000 >;
+			xlnx,baudrate = <0x1c200>;
+			xlnx,data-bits = <0x8>;
+			xlnx,family = "spartan3e";
+			xlnx,odd-parity = <0x0>;
+			xlnx,use-parity = <0x0>;
+		} ;
+		spi: xps-spi@40a00000 {
+			compatible = "xlnx,xps-spi-1.00.a";
+			interrupt-parent = <&xps_intc_0>;
+			interrupts = < 5 0x2 >;
+			reg = < 0x40a00000 0x100000 >;
+			xlnx,family = "spartan3e";
+			xlnx,fifo-exist = <0x1>;
+			xlnx,num-offchip-ss-bits = <0x4>;
+			xlnx,num-ss-bits = <0x4>;
+			xlnx,sck-ratio = <0x20>;
+		} ;
+		mdm: debug@40300000 {
+			compatible = "xlnx,mdm-1.00.a";
+			reg = < 0x40300000 0x100000 >;
+			xlnx,family = "spartan3e";
+			xlnx,interconnect = <0x1>;
+			xlnx,jtag-chain = <0x2>;
+			xlnx,mb-dbg-ports = <0x1>;
+			xlnx,uart-width = <0x8>;
+			xlnx,use-uart = <0x1>;
+			xlnx,write-fsl-ports = <0x1>;
+		} ;
+		mpmc@20000000 {
+			#address-cells = <1>;
+			#size-cells = <1>;
+			compatible = "xlnx,mpmc-3.00.a";
+		} ;
+		intc_0: interrupt-controller@40000000 {
+			#interrupt-cells = <2>;
+			compatible = "xlnx,xps-intc-1.00.a";
+			interrupt-controller ;
+			reg = < 0x40000000 0x100000 >;
+			xlnx,kind-of-edge = <0>;
+			xlnx,num-intr-inputs = <0x8>;
+		} ;
+		timer_0: timer@40400000 {
+			compatible = "xlnx,xps-timer-1.00.a";
+			interrupt-parent = <&xps_intc_0>;
+			interrupts = < 0 0x2 >;
+			reg = < 0x40400000 0x100000 >;
+			xlnx,count-width = <0x20>;
+			xlnx,family = "spartan3e";
+			xlnx,gen0-assert = <0x1>;
+			xlnx,gen1-assert = <0x1>;
+			xlnx,one-timer-only = <0x0>;
+			xlnx,trig0-assert = <0x1>;
+			xlnx,trig1-assert = <0x1>;
+		} ;
+		timer_1: timer@40500000 {
+			compatible = "xlnx,xps-timer-1.00.a";
+			interrupt-parent = <&xps_intc_0>;
+			interrupts = < 1 0x2 >;
+			reg = < 0x40500000 0x100000 >;
+			xlnx,count-width = <0x20>;
+			xlnx,family = "spartan3e";
+			xlnx,gen0-assert = <0x1>;
+			xlnx,gen1-assert = <0x1>;
+			xlnx,one-timer-only = <0x1>;
+			xlnx,trig0-assert = <0x1>;
+			xlnx,trig1-assert = <0x1>;
+		} ;
+	} ;
+}  ;
-- 
1.5.4.GIT

