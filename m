Return-Path: <linux-kernel-owner+w=401wt.eu-S1752212AbXJ2MtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbXJ2MtP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 08:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbXJ2MtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 08:49:01 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33027 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750870AbXJ2Ms7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 08:48:59 -0400
Date: Mon, 29 Oct 2007 13:49:07 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] cleanup asm/scatterlist.h includes
Message-ID: <20071029124907.GI7227@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Not architecture specific code should not #include <asm/scatterlist.h>.

This patch therefore either replaces them with
#include <linux/scatterlist.h> or simply removes them if they were 
unused.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 crypto/anubis.c                      |    1 -
 crypto/blowfish.c                    |    1 -
 crypto/compress.c                    |    1 -
 crypto/crypto_null.c                 |    1 -
 crypto/khazad.c                      |    1 -
 crypto/sha1_generic.c                |    1 -
 crypto/sha256_generic.c              |    1 -
 crypto/sha512.c                      |    1 -
 crypto/tea.c                         |    1 -
 crypto/tgr192.c                      |    1 -
 crypto/wp512.c                       |    1 -
 drivers/base/dmapool.c               |    1 -
 drivers/ieee1394/sbp2.c              |    2 +-
 drivers/media/video/bt8xx/bttvp.h    |    2 +-
 drivers/mmc/core/core.c              |    1 -
 drivers/mmc/core/mmc_ops.c           |    1 -
 drivers/mmc/core/sd_ops.c            |    1 -
 drivers/mmc/core/sdio_ops.c          |    1 -
 drivers/net/meth.c                   |    1 -
 drivers/usb/core/buffer.c            |    1 -
 drivers/usb/core/hcd.c               |    1 -
 drivers/usb/core/usb.c               |    2 +-
 fs/nfsd/nfs4recover.c                |    2 +-
 include/net/esp.h                    |    2 +-
 include/rdma/ib_verbs.h              |    2 +-
 include/scsi/libsas.h                |    2 +-
 net/ieee80211/ieee80211_crypt_ccmp.c |    1 -
 net/ipv4/ah4.c                       |    1 -
 net/ipv4/ipcomp.c                    |    1 -
 net/ipv6/ah6.c                       |    1 -
 net/ipv6/ipcomp6.c                   |    1 -
 net/mac80211/aes_ccm.c               |    1 -
 net/sunrpc/auth_gss/gss_krb5_seal.c  |    1 -
 net/sunrpc/auth_gss/gss_krb5_wrap.c  |    1 -
 net/xfrm/xfrm_algo.c                 |    1 -
 35 files changed, 7 insertions(+), 35 deletions(-)

9b30a07b8412fa3ba8d4c20f9e1d2e5c398e0e1f 
diff --git a/crypto/anubis.c b/crypto/anubis.c
index 1c771f7..4ff0e1e 100644
--- a/crypto/anubis.c
+++ b/crypto/anubis.c
@@ -33,7 +33,6 @@
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <asm/byteorder.h>
-#include <asm/scatterlist.h>
 #include <linux/crypto.h>
 #include <linux/types.h>
 
diff --git a/crypto/blowfish.c b/crypto/blowfish.c
index 55238c4..80c3fd8 100644
--- a/crypto/blowfish.c
+++ b/crypto/blowfish.c
@@ -20,7 +20,6 @@
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <asm/byteorder.h>
-#include <asm/scatterlist.h>
 #include <linux/crypto.h>
 #include <linux/types.h>
 
diff --git a/crypto/compress.c b/crypto/compress.c
index 0a65700..1ee3570 100644
--- a/crypto/compress.c
+++ b/crypto/compress.c
@@ -14,7 +14,6 @@
 #include <linux/types.h>
 #include <linux/crypto.h>
 #include <linux/errno.h>
-#include <asm/scatterlist.h>
 #include <linux/string.h>
 #include "internal.h"
 
diff --git a/crypto/crypto_null.c b/crypto/crypto_null.c
index 24dbb5d..29f7747 100644
--- a/crypto/crypto_null.c
+++ b/crypto/crypto_null.c
@@ -19,7 +19,6 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mm.h>
-#include <asm/scatterlist.h>
 #include <linux/crypto.h>
 #include <linux/string.h>
 
diff --git a/crypto/khazad.c b/crypto/khazad.c
index 9fa24a2..704ebfe 100644
--- a/crypto/khazad.c
+++ b/crypto/khazad.c
@@ -23,7 +23,6 @@
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <asm/byteorder.h>
-#include <asm/scatterlist.h>
 #include <linux/crypto.h>
 #include <linux/types.h>
 
diff --git a/crypto/sha1_generic.c b/crypto/sha1_generic.c
index 48a3c3e..68c62f5 100644
--- a/crypto/sha1_generic.c
+++ b/crypto/sha1_generic.c
@@ -23,7 +23,6 @@
 #include <linux/cryptohash.h>
 #include <linux/types.h>
 #include <crypto/sha.h>
-#include <asm/scatterlist.h>
 #include <asm/byteorder.h>
 
 struct sha1_ctx {
diff --git a/crypto/sha256_generic.c b/crypto/sha256_generic.c
index 5f4332e..fd3918b 100644
--- a/crypto/sha256_generic.c
+++ b/crypto/sha256_generic.c
@@ -22,7 +22,6 @@
 #include <linux/crypto.h>
 #include <linux/types.h>
 #include <crypto/sha.h>
-#include <asm/scatterlist.h>
 #include <asm/byteorder.h>
 
 struct sha256_ctx {
diff --git a/crypto/sha512.c b/crypto/sha512.c
index e736596..c39c803 100644
--- a/crypto/sha512.c
+++ b/crypto/sha512.c
@@ -19,7 +19,6 @@
 #include <linux/types.h>
 #include <crypto/sha.h>
 
-#include <asm/scatterlist.h>
 #include <asm/byteorder.h>
 
 struct sha512_ctx {
diff --git a/crypto/tea.c b/crypto/tea.c
index 1c54e26..6893b3f 100644
--- a/crypto/tea.c
+++ b/crypto/tea.c
@@ -23,7 +23,6 @@
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <asm/byteorder.h>
-#include <asm/scatterlist.h>
 #include <linux/crypto.h>
 #include <linux/types.h>
 
diff --git a/crypto/tgr192.c b/crypto/tgr192.c
index a0fadf3..2e7ea16 100644
--- a/crypto/tgr192.c
+++ b/crypto/tgr192.c
@@ -25,7 +25,6 @@
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <asm/byteorder.h>
-#include <asm/scatterlist.h>
 #include <linux/crypto.h>
 #include <linux/types.h>
 
diff --git a/crypto/wp512.c b/crypto/wp512.c
index 727d05a..f746952 100644
--- a/crypto/wp512.c
+++ b/crypto/wp512.c
@@ -23,7 +23,6 @@
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <asm/byteorder.h>
-#include <asm/scatterlist.h>
 #include <linux/crypto.h>
 #include <linux/types.h>
 
diff --git a/drivers/base/dmapool.c b/drivers/base/dmapool.c
index 5beddc3..b5034dc 100644
--- a/drivers/base/dmapool.c
+++ b/drivers/base/dmapool.c
@@ -2,7 +2,6 @@
 #include <linux/device.h>
 #include <linux/mm.h>
 #include <asm/io.h>		/* Needed for i386 to build */
-#include <asm/scatterlist.h>	/* Needed for i386 to build */
 #include <linux/dma-mapping.h>
 #include <linux/dmapool.h>
 #include <linux/slab.h>
diff --git a/drivers/ieee1394/sbp2.c b/drivers/ieee1394/sbp2.c
index d5dfe11..b83d254 100644
--- a/drivers/ieee1394/sbp2.c
+++ b/drivers/ieee1394/sbp2.c
@@ -71,11 +71,11 @@
 #include <linux/types.h>
 #include <linux/wait.h>
 #include <linux/workqueue.h>
+#include <linux/scatterlist.h>
 
 #include <asm/byteorder.h>
 #include <asm/errno.h>
 #include <asm/param.h>
-#include <asm/scatterlist.h>
 #include <asm/system.h>
 #include <asm/types.h>
 
diff --git a/drivers/media/video/bt8xx/bttvp.h b/drivers/media/video/bt8xx/bttvp.h
index 0b92c35..d4ac4c4 100644
--- a/drivers/media/video/bt8xx/bttvp.h
+++ b/drivers/media/video/bt8xx/bttvp.h
@@ -36,7 +36,7 @@
 #include <linux/pci.h>
 #include <linux/input.h>
 #include <linux/mutex.h>
-#include <asm/scatterlist.h>
+#include <linux/scatterlist.h>
 #include <asm/io.h>
 #include <media/v4l2-common.h>
 
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 09435e0..b966674 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -19,7 +19,6 @@
 #include <linux/pagemap.h>
 #include <linux/err.h>
 #include <linux/leds.h>
-#include <asm/scatterlist.h>
 #include <linux/scatterlist.h>
 
 #include <linux/mmc/card.h>
diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
index 7471d49..64b05c6 100644
--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -10,7 +10,6 @@
  */
 
 #include <linux/types.h>
-#include <asm/scatterlist.h>
 #include <linux/scatterlist.h>
 
 #include <linux/mmc/host.h>
diff --git a/drivers/mmc/core/sd_ops.c b/drivers/mmc/core/sd_ops.c
index a6dafe6..0d96080 100644
--- a/drivers/mmc/core/sd_ops.c
+++ b/drivers/mmc/core/sd_ops.c
@@ -10,7 +10,6 @@
  */
 
 #include <linux/types.h>
-#include <asm/scatterlist.h>
 #include <linux/scatterlist.h>
 
 #include <linux/mmc/host.h>
diff --git a/drivers/mmc/core/sdio_ops.c b/drivers/mmc/core/sdio_ops.c
index 4d289b2..e1fca58 100644
--- a/drivers/mmc/core/sdio_ops.c
+++ b/drivers/mmc/core/sdio_ops.c
@@ -9,7 +9,6 @@
  * your option) any later version.
  */
 
-#include <asm/scatterlist.h>
 #include <linux/scatterlist.h>
 
 #include <linux/mmc/host.h>
diff --git a/drivers/net/meth.c b/drivers/net/meth.c
index e25dbab..0c89b02 100644
--- a/drivers/net/meth.c
+++ b/drivers/net/meth.c
@@ -33,7 +33,6 @@
 #include <asm/ip32/ip32_ints.h>
 
 #include <asm/io.h>
-#include <asm/scatterlist.h>
 
 #include "meth.h"
 
diff --git a/drivers/usb/core/buffer.c b/drivers/usb/core/buffer.c
index ead2475..28d4972 100644
--- a/drivers/usb/core/buffer.c
+++ b/drivers/usb/core/buffer.c
@@ -11,7 +11,6 @@
 #include <linux/device.h>
 #include <linux/mm.h>
 #include <asm/io.h>
-#include <asm/scatterlist.h>
 #include <linux/dma-mapping.h>
 #include <linux/dmapool.h>
 #include <linux/usb.h>
diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 3dd997d..fea8256 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -30,7 +30,6 @@
 #include <linux/utsname.h>
 #include <linux/mm.h>
 #include <asm/io.h>
-#include <asm/scatterlist.h>
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
 #include <linux/mutex.h>
diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
index 69aa682..c4a6f10 100644
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -36,7 +36,7 @@
 #include <linux/workqueue.h>
 
 #include <asm/io.h>
-#include <asm/scatterlist.h>
+#include <linux/scatterlist.h>
 #include <linux/mm.h>
 #include <linux/dma-mapping.h>
 
diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index 6f03918..1602cd0 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -43,7 +43,7 @@
 #include <linux/file.h>
 #include <linux/namei.h>
 #include <asm/uaccess.h>
-#include <asm/scatterlist.h>
+#include <linux/scatterlist.h>
 #include <linux/crypto.h>
 #include <linux/sched.h>
 
diff --git a/include/net/esp.h b/include/net/esp.h
index c1bc529..c05f529 100644
--- a/include/net/esp.h
+++ b/include/net/esp.h
@@ -3,7 +3,7 @@
 
 #include <linux/crypto.h>
 #include <net/xfrm.h>
-#include <asm/scatterlist.h>
+#include <linux/scatterlist.h>
 
 #define ESP_NUM_FAST_SG		4
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 4bea182..11f3960 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -48,9 +48,9 @@
 #include <linux/kref.h>
 #include <linux/list.h>
 #include <linux/rwsem.h>
+#include <linux/scatterlist.h>
 
 #include <asm/atomic.h>
-#include <asm/scatterlist.h>
 #include <asm/uaccess.h>
 
 union ib_gid {
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 8dda2d6..a466c2c 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -36,7 +36,7 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_transport_sas.h>
-#include <asm/scatterlist.h>
+#include <linux/scatterlist.h>
 
 struct block_device;
 
diff --git a/net/ieee80211/ieee80211_crypt_ccmp.c b/net/ieee80211/ieee80211_crypt_ccmp.c
index 0936a3e..c6d760d 100644
--- a/net/ieee80211/ieee80211_crypt_ccmp.c
+++ b/net/ieee80211/ieee80211_crypt_ccmp.c
@@ -25,7 +25,6 @@
 #include <net/ieee80211.h>
 
 #include <linux/crypto.h>
-#include <asm/scatterlist.h>
 
 MODULE_AUTHOR("Jouni Malinen");
 MODULE_DESCRIPTION("Host AP crypt: CCMP");
diff --git a/net/ipv4/ah4.c b/net/ipv4/ah4.c
index 4e8e3b0..5fc346d 100644
--- a/net/ipv4/ah4.c
+++ b/net/ipv4/ah4.c
@@ -8,7 +8,6 @@
 #include <linux/spinlock.h>
 #include <net/icmp.h>
 #include <net/protocol.h>
-#include <asm/scatterlist.h>
 
 
 /* Clear mutable options and find final destination to substitute
diff --git a/net/ipv4/ipcomp.c b/net/ipv4/ipcomp.c
index 0bfeb02..ca1b5fd 100644
--- a/net/ipv4/ipcomp.c
+++ b/net/ipv4/ipcomp.c
@@ -14,7 +14,6 @@
  *   - Adaptive compression.
  */
 #include <linux/module.h>
-#include <asm/scatterlist.h>
 #include <asm/semaphore.h>
 #include <linux/crypto.h>
 #include <linux/pfkeyv2.h>
diff --git a/net/ipv6/ah6.c b/net/ipv6/ah6.c
index 66a9139..4eaf550 100644
--- a/net/ipv6/ah6.c
+++ b/net/ipv6/ah6.c
@@ -35,7 +35,6 @@
 #include <net/ipv6.h>
 #include <net/protocol.h>
 #include <net/xfrm.h>
-#include <asm/scatterlist.h>
 
 static int zero_out_mutable_opts(struct ipv6_opt_hdr *opthdr)
 {
diff --git a/net/ipv6/ipcomp6.c b/net/ipv6/ipcomp6.c
index 80ef2a1..85eb479 100644
--- a/net/ipv6/ipcomp6.c
+++ b/net/ipv6/ipcomp6.c
@@ -34,7 +34,6 @@
 #include <net/ip.h>
 #include <net/xfrm.h>
 #include <net/ipcomp.h>
-#include <asm/scatterlist.h>
 #include <asm/semaphore.h>
 #include <linux/crypto.h>
 #include <linux/pfkeyv2.h>
diff --git a/net/mac80211/aes_ccm.c b/net/mac80211/aes_ccm.c
index bf7ba12..e62fe55 100644
--- a/net/mac80211/aes_ccm.c
+++ b/net/mac80211/aes_ccm.c
@@ -11,7 +11,6 @@
 #include <linux/types.h>
 #include <linux/crypto.h>
 #include <linux/err.h>
-#include <asm/scatterlist.h>
 
 #include <net/mac80211.h>
 #include "ieee80211_key.h"
diff --git a/net/sunrpc/auth_gss/gss_krb5_seal.c b/net/sunrpc/auth_gss/gss_krb5_seal.c
index a0d9faa..1c6eda5 100644
--- a/net/sunrpc/auth_gss/gss_krb5_seal.c
+++ b/net/sunrpc/auth_gss/gss_krb5_seal.c
@@ -63,7 +63,6 @@
 #include <linux/jiffies.h>
 #include <linux/sunrpc/gss_krb5.h>
 #include <linux/random.h>
-#include <asm/scatterlist.h>
 #include <linux/crypto.h>
 
 #ifdef RPC_DEBUG
diff --git a/net/sunrpc/auth_gss/gss_krb5_wrap.c b/net/sunrpc/auth_gss/gss_krb5_wrap.c
index 8bd074d..3bdc527 100644
--- a/net/sunrpc/auth_gss/gss_krb5_wrap.c
+++ b/net/sunrpc/auth_gss/gss_krb5_wrap.c
@@ -4,7 +4,6 @@
 #include <linux/sunrpc/gss_krb5.h>
 #include <linux/random.h>
 #include <linux/pagemap.h>
-#include <asm/scatterlist.h>
 #include <linux/crypto.h>
 
 #ifdef RPC_DEBUG
diff --git a/net/xfrm/xfrm_algo.c b/net/xfrm/xfrm_algo.c
index 0426388..1686f64 100644
--- a/net/xfrm/xfrm_algo.c
+++ b/net/xfrm/xfrm_algo.c
@@ -21,7 +21,6 @@
 #if defined(CONFIG_INET_ESP) || defined(CONFIG_INET_ESP_MODULE) || defined(CONFIG_INET6_ESP) || defined(CONFIG_INET6_ESP_MODULE)
 #include <net/esp.h>
 #endif
-#include <asm/scatterlist.h>
 
 /*
  * Algorithms supported by IPsec.  These entries contain properties which


