Return-Path: <linux-kernel-owner+w=401wt.eu-S1751696AbZLMIQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696AbZLMIQu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 03:16:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbZLMIQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 03:16:49 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:65235 "HELO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751583AbZLMIQs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 03:16:48 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 13 Dec 2009 01:16:27 -0700
X-Google-Sender-Auth: 2fba27301529e87d
Message-ID: <fa686aa40912130016j517349c8wbc3da6ec1a1339b5@mail.gmail.com>
Subject: [git pull] SPI changes for 2.6.33
To: Linus Torvalds <torvalds@linux-foundation.org>,
       spi-devel-general@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Wearing my shiny new SPI maintainer hat, here's a pull request for the
SPI patches that I've gathered for 2.6.33.

The following changes since commit f40542532e96dda5506eb76badea322f2ae4731c:
  Linus Torvalds (1):
        Merge branch 'ixp4xx' of git://git.kernel.org/.../chris/linux-2.6

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 next-spi

Cory Maccarrone (1):
      Add OMAP spi100k driver

Daniel Mack (1):
      spi/i.mx: drain MXC SPI transfer buffer when probing device

Florian Fainelli (1):
      spi: fix spidev compilation failure when VERBOSE is defined

Grant Likely (3):
      spi/xilinx_spi: fix incorrect casting
      MAINTAINERS: add SPI co-maintainer.
      spi: fix probe/remove section markings

Jan Nikitenko (1):
      spi/au1550_spi: fix setupxfer not to override cfg with zeros

John Ogness (1):
      spi/i.MX: fix broken error handling for gpio_request

Luotao Fu (3):
      mpc52xx_spi: fix clearing status register
      mpc52xx_spi: add missing mode_bits definition
      mpc52xx_spi: add gpio chipselect

Magnus Damm (1):
      spi: SuperH MSIOF SPI Master driver V2

Richard Röjfors (4):
      xilinx_spi: Split into of driver and generic part.
      xilinx_spi: Switch to iomem functions and support little endian.
      xilinx_spi: add support for the DS570 IP.
      xilinx_spi: add a platform driver using the xilinx_spi common module.

Sascha Hauer (1):
      spi-imx: Add mx25 support

Uwe Kleine-König (4):
      spi/mpc8xxx: don't use __exit_p to wrap plat_mpc8xxx_spi_remove
      spi-imx: correct check for platform_get_irq failing
      spi-imx: use positive logic to distinguish cpu variants
      spi-imx: don't access struct device directly but use dev_get_platdata

Wan ZongShun (1):
      ARM: NUC900: Add spi driver support for nuc900

Wolfram Sang (1):
      spi/mpc52xx-spi: minor cleanups

 MAINTAINERS                                     |    1 +
 arch/arm/mach-w90x900/include/mach/nuc900_spi.h |   35 ++
 drivers/spi/Kconfig                             |   40 ++-
 drivers/spi/Makefile                            |    5 +
 drivers/spi/au1550_spi.c                        |   10 +-
 drivers/spi/mpc52xx_spi.c                       |   86 +++-
 drivers/spi/omap_spi_100k.c                     |  635 +++++++++++++++++++++
 drivers/spi/spi_imx.c                           |   35 +-
 drivers/spi/spi_mpc8xxx.c                       |    2 +-
 drivers/spi/spi_nuc900.c                        |  504 +++++++++++++++++
 drivers/spi/spi_sh_msiof.c                      |  691 +++++++++++++++++++++++
 drivers/spi/spidev.c                            |    6 +-
 drivers/spi/xilinx_spi.c                        |  355 ++++++------
 drivers/spi/xilinx_spi.h                        |   32 +
 drivers/spi/xilinx_spi_of.c                     |  134 +++++
 drivers/spi/xilinx_spi_pltfm.c                  |  102 ++++
 include/linux/spi/mpc52xx_spi.h                 |   10 -
 include/linux/spi/sh_msiof.h                    |   10 +
 include/linux/spi/xilinx_spi.h                  |   20 +
 19 files changed, 2484 insertions(+), 229 deletions(-)
 create mode 100644 arch/arm/mach-w90x900/include/mach/nuc900_spi.h
 create mode 100644 drivers/spi/omap_spi_100k.c
 create mode 100644 drivers/spi/spi_nuc900.c
 create mode 100644 drivers/spi/spi_sh_msiof.c
 create mode 100644 drivers/spi/xilinx_spi.h
 create mode 100644 drivers/spi/xilinx_spi_of.c
 create mode 100644 drivers/spi/xilinx_spi_pltfm.c
 delete mode 100644 include/linux/spi/mpc52xx_spi.h
 create mode 100644 include/linux/spi/sh_msiof.h
 create mode 100644 include/linux/spi/xilinx_spi.h


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
