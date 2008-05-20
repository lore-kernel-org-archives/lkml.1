Return-Path: <linux-kernel-owner+w=401wt.eu-S1762573AbYETAK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762573AbYETAK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 20:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755942AbYETAKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 20:10:51 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:62504 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755651AbYETAKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 20:10:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gsz6mFuPMvOWOq/dZ1MJbUlwT00J7aLIhuTWfCV7qZ7yb3XMKdvNWEqlS43hFexlmin4R+VeWceE0da4m+2/uJKalC5OvoJLLoSC2t35kjYDYU8BpJO4YFsMhC1kNMcWrWNY7IgKJpaDerk9gWLhs/MXLOgkKh390ywGO/zeoLk=
Message-ID: <9a8748490805191710y27f5729cgb1d00de67ca79b8a@mail.gmail.com>
Date: Tue, 20 May 2008 02:10:48 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Nick Andrew" <nick@nick-andrew.net>
Subject: Re: [PATCH] Tighten up the use of loose
Cc: "Trivial Kernel Patches" <trivial@kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080422041145.4503.35934.stgit@marcab.local.tull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080422041145.4503.35934.stgit@marcab.local.tull.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/4/22 Nick Andrew <nick@nick-andrew.net>:
> Tighten up the use of loose
>
> 'Lose' is when you don't win or you've lost something, and 'loose'
> is when something isn't tight. I just want to tighten up the
> spelling a bit regarding some loose comments.
>
> Signed-off-by: Nick Andrew <nick@nick-andrew.net>

I've added this one to the trivial tree. Thanks Nick.

/Jesper Juhl


> ---
> v2 - rebase against Linus' latest tree
> Yes, this is a digression.
>
>  Documentation/edac.txt            |    2 +-
>  Documentation/filesystems/hfs.txt |    2 +-
>  arch/mips/kernel/vpe.c            |    2 +-
>  arch/sh/lib64/c-checksum.c        |    4 ++--
>  drivers/char/serial167.c          |    2 +-
>  drivers/media/dvb/ttpci/av7110.c  |    2 +-
>  drivers/message/i2o/i2o_block.c   |    2 +-
>  drivers/misc/ibmasm/event.c       |    2 +-
>  drivers/net/spider_net.c          |    2 +-
>  drivers/serial/mpc52xx_uart.c     |    4 ++--
>  drivers/usb/serial/ftdi_sio.c     |    2 +-
>  fs/jffs2/fs.c                     |    2 +-
>  fs/ntfs/aops.c                    |    2 +-
>  include/linux/securebits.h        |    2 +-
>  mm/migrate.c                      |    2 +-
>  mm/slub.c                         |    4 ++--
>  net/wireless/wext.c               |    2 +-
>  17 files changed, 20 insertions(+), 20 deletions(-)
>
>
> diff --git a/Documentation/edac.txt b/Documentation/edac.txt
> index a5c3684..bad5fef 100644
> --- a/Documentation/edac.txt
> +++ b/Documentation/edac.txt
> @@ -280,7 +280,7 @@ Polling period control file:
>
>        The time period, in milliseconds, for polling for error information.
>        Too small a value wastes resources.  Too large a value might delay
> -       necessary handling of errors and might loose valuable information for
> +       necessary handling of errors and might lose valuable information for
>        locating the error.  1000 milliseconds (once each second) is the current
>        default. Systems which require all the bandwidth they can get, may
>        increase this.
> diff --git a/Documentation/filesystems/hfs.txt b/Documentation/filesystems/hfs.txt
> index bd0fa77..28f0225 100644
> --- a/Documentation/filesystems/hfs.txt
> +++ b/Documentation/filesystems/hfs.txt
> @@ -61,7 +61,7 @@ the a little strange:
>    Finder's metadata.
>  o They are however created (with default values), deleted and renamed
>    along with the corresponding data fork or directory.
> - o Copying files to a different filesystem will loose those attributes
> + o Copying files to a different filesystem will lose those attributes
>    that are essential for MacOS to work.
>
>
> diff --git a/arch/mips/kernel/vpe.c b/arch/mips/kernel/vpe.c
> index 39804c5..bbce807 100644
> --- a/arch/mips/kernel/vpe.c
> +++ b/arch/mips/kernel/vpe.c
> @@ -1121,7 +1121,7 @@ static int vpe_release(struct inode *inode, struct file *filp)
>
>        /* It's good to be able to run the SP and if it chokes have a look at
>           the /dev/rt?. But if we reset the pointer to the shared struct we
> -          loose what has happened. So perhaps if garbage is sent to the vpe
> +          lose what has happened. So perhaps if garbage is sent to the vpe
>           device, use it as a trigger for the reset. Hopefully a nice
>           executable will be along shortly. */
>        if (ret < 0)
> diff --git a/arch/sh/lib64/c-checksum.c b/arch/sh/lib64/c-checksum.c
> index 5c284e0..73c0877 100644
> --- a/arch/sh/lib64/c-checksum.c
> +++ b/arch/sh/lib64/c-checksum.c
> @@ -35,7 +35,7 @@ static inline unsigned short foldto16(unsigned long x)
>
>  static inline unsigned short myfoldto16(unsigned long long x)
>  {
> -       /* Fold down to 32-bits so we don't loose in the typedef-less
> +       /* Fold down to 32-bits so we don't lose in the typedef-less
>           network stack.  */
>        /* 64 to 33 */
>        x = (x & 0xffffffff) + (x >> 32);
> @@ -199,7 +199,7 @@ __wsum csum_tcpudp_nofold(__be32 saddr, __be32 daddr,
>        result = (__force u64) saddr + (__force u64) daddr +
>                 (__force u64) sum + ((len + proto) << 8);
>
> -       /* Fold down to 32-bits so we don't loose in the typedef-less
> +       /* Fold down to 32-bits so we don't lose in the typedef-less
>           network stack.  */
>        /* 64 to 33 */
>        result = (result & 0xffffffff) + (result >> 32);
> diff --git a/drivers/char/serial167.c b/drivers/char/serial167.c
> index df8cd0c..201eb83 100644
> --- a/drivers/char/serial167.c
> +++ b/drivers/char/serial167.c
> @@ -418,7 +418,7 @@ static irqreturn_t cd2401_rxerr_interrupt(int irq, void *dev_id)
>                                                             TTY_OVERRUN);
>                                        /*
>                                           If the flip buffer itself is
> -                                          overflowing, we still loose
> +                                          overflowing, we still lose
>                                           the next incoming character.
>                                         */
>                                        if (tty_buffer_request_room(tty, 1) !=
> diff --git a/drivers/media/dvb/ttpci/av7110.c b/drivers/media/dvb/ttpci/av7110.c
> index 0e5701b..a24fa6c 100644
> --- a/drivers/media/dvb/ttpci/av7110.c
> +++ b/drivers/media/dvb/ttpci/av7110.c
> @@ -2784,7 +2784,7 @@ static void av7110_irq(struct saa7146_dev* dev, u32 *isr)
>                 * we must do it here even though saa7146_core did it already),
>                 * and b) that if we were to disable an edge triggered irq
>                 * (like the gpio irqs sadly are) temporarily we would likely
> -                * loose some. This sucks :-(
> +                * lose some. This sucks :-(
>                 */
>                SAA7146_IER_DISABLE(av7110->dev, MASK_19);
>                SAA7146_ISR_CLEAR(av7110->dev, MASK_19);
> diff --git a/drivers/message/i2o/i2o_block.c b/drivers/message/i2o/i2o_block.c
> index a953148..704843e 100644
> --- a/drivers/message/i2o/i2o_block.c
> +++ b/drivers/message/i2o/i2o_block.c
> @@ -354,7 +354,7 @@ static inline void i2o_block_sglist_free(struct i2o_block_request *ireq)
>  *     @req: the request to prepare
>  *
>  *     Allocate the necessary i2o_block_request struct and connect it to
> - *     the request. This is needed that we not loose the SG list later on.
> + *     the request. This is needed that we not lose the SG list later on.
>  *
>  *     Returns BLKPREP_OK on success or BLKPREP_DEFER on failure.
>  */
> diff --git a/drivers/misc/ibmasm/event.c b/drivers/misc/ibmasm/event.c
> index fda6a4d..68a0a5b 100644
> --- a/drivers/misc/ibmasm/event.c
> +++ b/drivers/misc/ibmasm/event.c
> @@ -50,7 +50,7 @@ static void wake_up_event_readers(struct service_processor *sp)
>  * Store the event in the circular event buffer, wake up any sleeping
>  * event readers.
>  * There is no reader marker in the buffer, therefore readers are
> - * responsible for keeping up with the writer, or they will loose events.
> + * responsible for keeping up with the writer, or they will lose events.
>  */
>  void ibmasm_receive_event(struct service_processor *sp, void *data, unsigned int data_size)
>  {
> diff --git a/drivers/net/spider_net.c b/drivers/net/spider_net.c
> index 4776716..2fd8185 100644
> --- a/drivers/net/spider_net.c
> +++ b/drivers/net/spider_net.c
> @@ -790,7 +790,7 @@ spider_net_set_low_watermark(struct spider_net_card *card)
>  * spider_net_release_tx_chain releases the tx descriptors that spider has
>  * finished with (if non-brutal) or simply release tx descriptors (if brutal).
>  * If some other context is calling this function, we return 1 so that we're
> - * scheduled again (if we were scheduled) and will not loose initiative.
> + * scheduled again (if we were scheduled) and will not lose initiative.
>  */
>  static int
>  spider_net_release_tx_chain(struct spider_net_card *card, int brutal)
> diff --git a/drivers/serial/mpc52xx_uart.c b/drivers/serial/mpc52xx_uart.c
> index d93b357..750c820 100644
> --- a/drivers/serial/mpc52xx_uart.c
> +++ b/drivers/serial/mpc52xx_uart.c
> @@ -602,8 +602,8 @@ mpc52xx_uart_set_termios(struct uart_port *port, struct ktermios *new,
>        /* Update the per-port timeout */
>        uart_update_timeout(port, new->c_cflag, baud);
>
> -       /* Do our best to flush TX & RX, so we don't loose anything */
> -       /* But we don't wait indefinitly ! */
> +       /* Do our best to flush TX & RX, so we don't lose anything */
> +       /* But we don't wait indefinitely ! */
>        j = 5000000;    /* Maximum wait */
>        /* FIXME Can't receive chars since set_termios might be called at early
>         * boot for the console, all stuff is not yet ready to receive at that
> diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
> index 3abb3c8..1fe8293 100644
> --- a/drivers/usb/serial/ftdi_sio.c
> +++ b/drivers/usb/serial/ftdi_sio.c
> @@ -1175,7 +1175,7 @@ static int  ftdi_open (struct usb_serial_port *port, struct file *filp)
>                        priv->interface, buf, 0, WDR_TIMEOUT);
>
>        /* Termios defaults are set by usb_serial_init. We don't change
> -          port->tty->termios - this would loose speed settings, etc.
> +          port->tty->termios - this would lose speed settings, etc.
>           This is same behaviour as serial.c/rs_open() - Kuba */
>
>        /* ftdi_set_termios  will send usb control messages */
> diff --git a/fs/jffs2/fs.c b/fs/jffs2/fs.c
> index e26ea78..4c8c34a 100644
> --- a/fs/jffs2/fs.c
> +++ b/fs/jffs2/fs.c
> @@ -377,7 +377,7 @@ int jffs2_remount_fs (struct super_block *sb, int *flags, char *data)
>        /* We stop if it was running, then restart if it needs to.
>           This also catches the case where it was stopped and this
>           is just a remount to restart it.
> -          Flush the writebuffer, if neccecary, else we loose it */
> +          Flush the writebuffer, if necessary, else we lose it */
>        if (!(sb->s_flags & MS_RDONLY)) {
>                jffs2_stop_garbage_collect_thread(c);
>                down(&c->alloc_sem);
> diff --git a/fs/ntfs/aops.c b/fs/ntfs/aops.c
> index 00e9ccd..54059b5 100644
> --- a/fs/ntfs/aops.c
> +++ b/fs/ntfs/aops.c
> @@ -1298,7 +1298,7 @@ done:
>        if (unlikely(err && err != -ENOMEM)) {
>                /*
>                 * Set page error if there is only one ntfs record in the page.
> -                * Otherwise we would loose per-record granularity.
> +                * Otherwise we would lose per-record granularity.
>                 */
>                if (ni->itype.index.block_size == PAGE_CACHE_SIZE)
>                        SetPageError(page);
> diff --git a/include/linux/securebits.h b/include/linux/securebits.h
> index 5b06178..c0c430d 100644
> --- a/include/linux/securebits.h
> +++ b/include/linux/securebits.h
> @@ -14,7 +14,7 @@ extern unsigned securebits;
>  #define SECURE_NOROOT            0
>
>  /* When set, setuid to/from uid 0 does not trigger capability-"fixes"
> -   to be compatible with old programs relying on set*uid to loose
> +   to be compatible with old programs relying on set*uid to lose
>    privileges. When unset, setuid doesn't change privileges. */
>  #define SECURE_NO_SETUID_FIXUP   2
>
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 4e0eccc..5ace17b 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -523,7 +523,7 @@ static int writeout(struct address_space *mapping, struct page *page)
>        /*
>         * A dirty page may imply that the underlying filesystem has
>         * the page on some queue. So the page must be clean for
> -        * migration. Writeout may mean we loose the lock and the
> +        * migration. Writeout may mean we lose the lock and the
>         * page state is no longer what we checked for earlier.
>         * At this point we know that the migration attempt cannot
>         * be successful.
> diff --git a/mm/slub.c b/mm/slub.c
> index 7f8aaa2..5a8f052 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -727,7 +727,7 @@ static int check_object(struct kmem_cache *s, struct page *page,
>        if (!check_valid_pointer(s, page, get_freepointer(s, p))) {
>                object_err(s, page, p, "Freepointer corrupt");
>                /*
> -                * No choice but to zap it and thus loose the remainder
> +                * No choice but to zap it and thus lose the remainder
>                 * of the free objects in this slab. May cause
>                 * another error because the object count is now wrong.
>                 */
> @@ -4260,7 +4260,7 @@ static void sysfs_slab_remove(struct kmem_cache *s)
>
>  /*
>  * Need to buffer aliases during bootup until sysfs becomes
> - * available lest we loose that information.
> + * available lest we lose that information.
>  */
>  struct saved_alias {
>        struct kmem_cache *s;
> diff --git a/net/wireless/wext.c b/net/wireless/wext.c
> index 947188a..b9f982f 100644
> --- a/net/wireless/wext.c
> +++ b/net/wireless/wext.c
> @@ -64,7 +64,7 @@
>  *     o Remove spy_offset from struct iw_handler_def
>  *     o Start deprecating dev->get_wireless_stats, output a warning
>  *     o If IW_QUAL_DBM is set, show dBm values in /proc/net/wireless
> - *     o Don't loose INVALID/DBM flags when clearing UPDATED flags (iwstats)
> + *     o Don't lose INVALID/DBM flags when clearing UPDATED flags (iwstats)
>  *
>  * v8 - 17.02.06 - Jean II
>  *     o RtNetlink requests support (SET/GET)
>
>



-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please http://www.expita.com/nomime.html
