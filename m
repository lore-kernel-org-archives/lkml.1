Return-Path: <linux-kernel-owner+w=401wt.eu-S934541AbZKYH3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934541AbZKYH3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 02:29:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933499AbZKYH3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 02:29:36 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48979 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbZKYH3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 02:29:35 -0500
Date: Wed, 25 Nov 2009 18:29:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       =?UTF-8?B?IlV3ZSBLbGVpbmUtS8O2bmlnIg==?= 
	<u.kleine-koenig@pengutronix.de>,
       Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the trivial tree with the arm tree
Message-Id: <20091125182938.330219af.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
arch/arm/plat-mxc/include/mach/mx2x.h between commit
b9fc90a48a3d1794443e095d8585dcaeafb2195f ("imx: add namespace prefixes
for symbols in mx2x.h") from the arm tree and commit
324bea84dda5e6ddea9464cdd957cb8cf94552d9 ("tree-wide: fix typos "offest"
-> "offset"") from the trivial tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/plat-mxc/include/mach/mx2x.h
index 1766c7c,728f31c..0000000
--- a/arch/arm/plat-mxc/include/mach/mx2x.h
+++ b/arch/arm/plat-mxc/include/mach/mx2x.h
@@@ -25,49 -25,51 +25,49 @@@
  
  /* The following addresses are common between i.MX21 and i.MX27 */
  
- /* Register offests */
+ /* Register offsets */
 -#define AIPI_BASE_ADDR          0x10000000
 -#define AIPI_BASE_ADDR_VIRT     0xF4000000
 -#define AIPI_SIZE               SZ_1M
 -
 -#define DMA_BASE_ADDR           (AIPI_BASE_ADDR + 0x01000)
 -#define WDOG_BASE_ADDR          (AIPI_BASE_ADDR + 0x02000)
 -#define GPT1_BASE_ADDR          (AIPI_BASE_ADDR + 0x03000)
 -#define GPT2_BASE_ADDR          (AIPI_BASE_ADDR + 0x04000)
 -#define GPT3_BASE_ADDR          (AIPI_BASE_ADDR + 0x05000)
 -#define PWM_BASE_ADDR           (AIPI_BASE_ADDR + 0x06000)
 -#define RTC_BASE_ADDR           (AIPI_BASE_ADDR + 0x07000)
 -#define KPP_BASE_ADDR           (AIPI_BASE_ADDR + 0x08000)
 -#define OWIRE_BASE_ADDR         (AIPI_BASE_ADDR + 0x09000)
 -#define UART1_BASE_ADDR         (AIPI_BASE_ADDR + 0x0A000)
 -#define UART2_BASE_ADDR         (AIPI_BASE_ADDR + 0x0B000)
 -#define UART3_BASE_ADDR         (AIPI_BASE_ADDR + 0x0C000)
 -#define UART4_BASE_ADDR         (AIPI_BASE_ADDR + 0x0D000)
 -#define CSPI1_BASE_ADDR         (AIPI_BASE_ADDR + 0x0E000)
 -#define CSPI2_BASE_ADDR         (AIPI_BASE_ADDR + 0x0F000)
 -#define SSI1_BASE_ADDR          (AIPI_BASE_ADDR + 0x10000)
 -#define SSI2_BASE_ADDR          (AIPI_BASE_ADDR + 0x11000)
 -#define I2C_BASE_ADDR           (AIPI_BASE_ADDR + 0x12000)
 -#define SDHC1_BASE_ADDR         (AIPI_BASE_ADDR + 0x13000)
 -#define SDHC2_BASE_ADDR         (AIPI_BASE_ADDR + 0x14000)
 -#define GPIO_BASE_ADDR          (AIPI_BASE_ADDR + 0x15000)
 -#define AUDMUX_BASE_ADDR        (AIPI_BASE_ADDR + 0x16000)
 -#define CSPI3_BASE_ADDR         (AIPI_BASE_ADDR + 0x17000)
 -#define LCDC_BASE_ADDR          (AIPI_BASE_ADDR + 0x21000)
 -#define SLCDC_BASE_ADDR         (AIPI_BASE_ADDR + 0x22000)
 -#define USBOTG_BASE_ADDR        (AIPI_BASE_ADDR + 0x24000)
 -#define EMMA_PP_BASE_ADDR       (AIPI_BASE_ADDR + 0x26000)
 -#define EMMA_PRP_BASE_ADDR      (AIPI_BASE_ADDR + 0x26400)
 -#define CCM_BASE_ADDR           (AIPI_BASE_ADDR + 0x27000)
 -#define SYSCTRL_BASE_ADDR       (AIPI_BASE_ADDR + 0x27800)
 -#define JAM_BASE_ADDR           (AIPI_BASE_ADDR + 0x3E000)
 -#define MAX_BASE_ADDR           (AIPI_BASE_ADDR + 0x3F000)
 -
 -#define AVIC_BASE_ADDR          0x10040000
 -
 -#define SAHB1_BASE_ADDR         0x80000000
 -#define SAHB1_BASE_ADDR_VIRT    0xF4100000
 -#define SAHB1_SIZE              SZ_1M
 -
 -#define CSI_BASE_ADDR           (SAHB1_BASE_ADDR + 0x0000)
 +#define MX2x_AIPI_BASE_ADDR		0x10000000
 +#define MX2x_AIPI_BASE_ADDR_VIRT	0xf4000000
 +#define MX2x_AIPI_SIZE			SZ_1M
 +#define MX2x_DMA_BASE_ADDR			(MX2x_AIPI_BASE_ADDR + 0x01000)
 +#define MX2x_WDOG_BASE_ADDR			(MX2x_AIPI_BASE_ADDR + 0x02000)
 +#define MX2x_GPT1_BASE_ADDR			(MX2x_AIPI_BASE_ADDR + 0x03000)
 +#define MX2x_GPT2_BASE_ADDR			(MX2x_AIPI_BASE_ADDR + 0x04000)
 +#define MX2x_GPT3_BASE_ADDR			(MX2x_AIPI_BASE_ADDR + 0x05000)
 +#define MX2x_PWM_BASE_ADDR			(MX2x_AIPI_BASE_ADDR + 0x06000)
 +#define MX2x_RTC_BASE_ADDR			(MX2x_AIPI_BASE_ADDR + 0x07000)
 +#define MX2x_KPP_BASE_ADDR			(MX2x_AIPI_BASE_ADDR + 0x08000)
 +#define MX2x_OWIRE_BASE_ADDR			(MX2x_AIPI_BASE_ADDR + 0x09000)
 +#define MX2x_UART1_BASE_ADDR			(MX2x_AIPI_BASE_ADDR + 0x0a000)
 +#define MX2x_UART2_BASE_ADDR			(MX2x_AIPI_BASE_ADDR + 0x0b000)
 +#define MX2x_UART3_BASE_ADDR			(MX2x_AIPI_BASE_ADDR + 0x0c000)
 +#define MX2x_UART4_BASE_ADDR			(MX2x_AIPI_BASE_ADDR + 0x0d000)
 +#define MX2x_CSPI1_BASE_ADDR			(MX2x_AIPI_BASE_ADDR + 0x0e000)
 +#define MX2x_CSPI2_BASE_ADDR			(MX2x_AIPI_BASE_ADDR + 0x0f000)
 +#define MX2x_SSI1_BASE_ADDR			(MX2x_AIPI_BASE_ADDR + 0x10000)
 +#define MX2x_SSI2_BASE_ADDR			(MX2x_AIPI_BASE_ADDR + 0x11000)
 +#define MX2x_I2C_BASE_ADDR			(MX2x_AIPI_BASE_ADDR + 0x12000)
 +#define MX2x_SDHC1_BASE_ADDR			(MX2x_AIPI_BASE_ADDR + 0x13000)
 +#define MX2x_SDHC2_BASE_ADDR			(MX2x_AIPI_BASE_ADDR + 0x14000)
 +#define MX2x_GPIO_BASE_ADDR			(MX2x_AIPI_BASE_ADDR + 0x15000)
 +#define MX2x_AUDMUX_BASE_ADDR			(MX2x_AIPI_BASE_ADDR + 0x16000)
 +#define MX2x_CSPI3_BASE_ADDR			(MX2x_AIPI_BASE_ADDR + 0x17000)
 +#define MX2x_LCDC_BASE_ADDR			(MX2x_AIPI_BASE_ADDR + 0x21000)
 +#define MX2x_SLCDC_BASE_ADDR			(MX2x_AIPI_BASE_ADDR + 0x22000)
 +#define MX2x_USBOTG_BASE_ADDR			(MX2x_AIPI_BASE_ADDR + 0x24000)
 +#define MX2x_EMMA_PP_BASE_ADDR			(MX2x_AIPI_BASE_ADDR + 0x26000)
 +#define MX2x_EMMA_PRP_BASE_ADDR			(MX2x_AIPI_BASE_ADDR + 0x26400)
 +#define MX2x_CCM_BASE_ADDR			(MX2x_AIPI_BASE_ADDR + 0x27000)
 +#define MX2x_SYSCTRL_BASE_ADDR			(MX2x_AIPI_BASE_ADDR + 0x27800)
 +#define MX2x_JAM_BASE_ADDR			(MX2x_AIPI_BASE_ADDR + 0x3e000)
 +#define MX2x_MAX_BASE_ADDR			(MX2x_AIPI_BASE_ADDR + 0x3f000)
 +
 +#define MX2x_AVIC_BASE_ADDR		0x10040000
 +
 +#define MX2x_SAHB1_BASE_ADDR		0x80000000
 +#define MX2x_SAHB1_BASE_ADDR_VIRT	0xf4100000
 +#define MX2x_SAHB1_SIZE			SZ_1M
 +#define MX2x_CSI_BASE_ADDR			(MX2x_SAHB1_BASE_ADDR + 0x0000)
  
  /*
   * This macro defines the physical to virtual address mapping for all the
