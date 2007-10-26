Return-Path: <linux-kernel-owner+w=401wt.eu-S1763389AbXJZCMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763389AbXJZCMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 22:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760898AbXJZCMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 22:12:10 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:45158 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756649AbXJZCMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 22:12:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RyM39CSm+q6i81F4MGjWNQ8FOQIY9MJwRO/UliYNVL1/0WttWGGYTBVEpM3FuGX3w1wqUXNvQ9jZFyDhRNcd9OUa7uEcdHFMqWSLfrNeWwdWH9sRS2Tqpu0ia2mBFneONYqexRIiO0KtmeCvsdNTI3/qOnCvhnrDZHW7dVyvpIQ=
Message-ID: <386072610710251912w20115228g19d2b85bc9e23ae9@mail.gmail.com>
Date: Fri, 26 Oct 2007 10:12:07 +0800
From: "Bryan Wu" <cooloney.lkml@gmail.com>
To: "Ralf Baechle" <ralf@linux-mips.org>
Subject: Re: [PATCH] Remove inclusions of <linux/autoconf.h>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20071024145109.GA9535@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071024145109.GA9535@linux-mips.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/07, Ralf Baechle <ralf@linux-mips.org> wrote:
> Nothing should ever include this file.
>
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
>
>  arch/blackfin/mach-common/interrupt.S |    1 -
>  arch/blackfin/mm/blackfin_sram.c      |    1 -

Acked, thanks Ralf

-Bryan

>  arch/m68knommu/lib/memcpy.c           |    1 -
>  arch/mips/au1000/common/gpio.c        |    1 -
>  drivers/char/mxser.c                  |    1 -
>  drivers/char/mxser_new.c              |    1 -
>  drivers/firmware/dmi-id.c             |    1 -
>  drivers/ide/pci/delkin_cb.c           |    1 -
>  drivers/misc/asus-laptop.c            |    1 -
>  drivers/misc/fujitsu-laptop.c         |    1 -
>  drivers/misc/msi-laptop.c             |    1 -
>  drivers/spi/spi.c                     |    1 -
>  12 files changed, 0 insertions(+), 12 deletions(-)
>
> diff --git a/arch/blackfin/mach-common/interrupt.S b/arch/blackfin/mach-common/interrupt.S
> index c6b32fe..4de3764 100644
> --- a/arch/blackfin/mach-common/interrupt.S
> +++ b/arch/blackfin/mach-common/interrupt.S
> @@ -30,7 +30,6 @@
>
>  #include <asm/blackfin.h>
>  #include <asm/mach/irq.h>
> -#include <linux/autoconf.h>
>  #include <linux/linkage.h>
>  #include <asm/entry.h>
>  #include <asm/asm-offsets.h>
> diff --git a/arch/blackfin/mm/blackfin_sram.c b/arch/blackfin/mm/blackfin_sram.c
> index b99ea88..e41f0e8 100644
> --- a/arch/blackfin/mm/blackfin_sram.c
> +++ b/arch/blackfin/mm/blackfin_sram.c
> @@ -27,7 +27,6 @@
>   * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>
> -#include <linux/autoconf.h>
>  #include <linux/module.h>
>  #include <linux/kernel.h>
>  #include <linux/types.h>
> diff --git a/arch/m68knommu/lib/memcpy.c b/arch/m68knommu/lib/memcpy.c
> index 0d55775..b50dbca 100644
> --- a/arch/m68knommu/lib/memcpy.c
> +++ b/arch/m68knommu/lib/memcpy.c
> @@ -1,6 +1,5 @@
>
>  #include <linux/types.h>
> -#include <linux/autoconf.h>
>
>  void * memcpy(void * to, const void * from, size_t n)
>  {
> diff --git a/arch/mips/au1000/common/gpio.c b/arch/mips/au1000/common/gpio.c
> index 8527856..0b658f1 100644
> --- a/arch/mips/au1000/common/gpio.c
> +++ b/arch/mips/au1000/common/gpio.c
> @@ -27,7 +27,6 @@
>   *     others have a second one : GPIO2
>   */
>
> -#include <linux/autoconf.h>
>  #include <linux/init.h>
>  #include <linux/io.h>
>  #include <linux/types.h>
> diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
> index fd0abef..4742078 100644
> --- a/drivers/char/mxser.c
> +++ b/drivers/char/mxser.c
> @@ -37,7 +37,6 @@
>
>
>  #include <linux/module.h>
> -#include <linux/autoconf.h>
>  #include <linux/errno.h>
>  #include <linux/signal.h>
>  #include <linux/sched.h>
> diff --git a/drivers/char/mxser_new.c b/drivers/char/mxser_new.c
> index 081c84c..bf1bee4 100644
> --- a/drivers/char/mxser_new.c
> +++ b/drivers/char/mxser_new.c
> @@ -20,7 +20,6 @@
>   */
>
>  #include <linux/module.h>
> -#include <linux/autoconf.h>
>  #include <linux/errno.h>
>  #include <linux/signal.h>
>  #include <linux/sched.h>
> diff --git a/drivers/firmware/dmi-id.c b/drivers/firmware/dmi-id.c
> index b6e1eb7..dbbda9a 100644
> --- a/drivers/firmware/dmi-id.c
> +++ b/drivers/firmware/dmi-id.c
> @@ -11,7 +11,6 @@
>  #include <linux/init.h>
>  #include <linux/dmi.h>
>  #include <linux/device.h>
> -#include <linux/autoconf.h>
>
>  struct dmi_device_attribute{
>         struct device_attribute dev_attr;
> diff --git a/drivers/ide/pci/delkin_cb.c b/drivers/ide/pci/delkin_cb.c
> index 8382908..f51b36c 100644
> --- a/drivers/ide/pci/delkin_cb.c
> +++ b/drivers/ide/pci/delkin_cb.c
> @@ -18,7 +18,6 @@
>   *  License.  See the file COPYING in the main directory of this archive for
>   *  more details.
>   */
> -#include <linux/autoconf.h>
>  #include <linux/types.h>
>  #include <linux/module.h>
>  #include <linux/mm.h>
> diff --git a/drivers/misc/asus-laptop.c b/drivers/misc/asus-laptop.c
> index 7dce318..0846c33 100644
> --- a/drivers/misc/asus-laptop.c
> +++ b/drivers/misc/asus-laptop.c
> @@ -33,7 +33,6 @@
>   *  Sam Lin        - GPS support
>   */
>
> -#include <linux/autoconf.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/init.h>
> diff --git a/drivers/misc/fujitsu-laptop.c b/drivers/misc/fujitsu-laptop.c
> index d366a6c..981eb13 100644
> --- a/drivers/misc/fujitsu-laptop.c
> +++ b/drivers/misc/fujitsu-laptop.c
> @@ -50,7 +50,6 @@
>  #include <linux/dmi.h>
>  #include <linux/backlight.h>
>  #include <linux/platform_device.h>
> -#include <linux/autoconf.h>
>
>  #define FUJITSU_DRIVER_VERSION "0.3"
>
> diff --git a/drivers/misc/msi-laptop.c b/drivers/misc/msi-laptop.c
> index 83679c7..de898c6 100644
> --- a/drivers/misc/msi-laptop.c
> +++ b/drivers/misc/msi-laptop.c
> @@ -58,7 +58,6 @@
>  #include <linux/dmi.h>
>  #include <linux/backlight.h>
>  #include <linux/platform_device.h>
> -#include <linux/autoconf.h>
>
>  #define MSI_DRIVER_VERSION "0.5"
>
> diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
> index 89769ce..b95eb1a 100644
> --- a/drivers/spi/spi.c
> +++ b/drivers/spi/spi.c
> @@ -18,7 +18,6 @@
>   * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>   */
>
> -#include <linux/autoconf.h>
>  #include <linux/kernel.h>
>  #include <linux/device.h>
>  #include <linux/init.h>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
