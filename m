Return-Path: <linux-kernel-owner+w=401wt.eu-S1753824AbYKLRG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbYKLRG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 12:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751054AbYKLRGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 12:06:50 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:39493 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbYKLRGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 12:06:50 -0500
Date: Wed, 12 Nov 2008 11:06:40 -0600
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, dustin.kirkland@gmail.com,
       sandeen@redhat.com, tchicks@us.ibm.com, shaggy@us.ibm.com
Subject: [PATCH] eCryptfs: kerneldoc for ecryptfs_parse_tag_70_packet()
Message-ID: <20081112170640.GD6842@halcrowt61p.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20081104213754.GC6675@halcrowt61p.austin.ibm.com> <20081104213908.GA6677@halcrowt61p.austin.ibm.com> <20081106141234.ba53c112.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081106141234.ba53c112.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 02:12:34PM -0800, Andrew Morton wrote:
> On Tue, 4 Nov 2008 15:39:08 -0600
> Michael Halcrow <mhalcrow@us.ibm.com> wrote:
> > +/**
> > + * parse_tag_70_packet - Parse and process FNEK-encrypted passphrase packet
> > + * @filename: This function kmalloc's the memory for the filename
> > + */
> 
> This kernedoc missed lots of the arguments.

Kerneldoc updates for ecryptfs_parse_tag_70_packet().

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/keystore.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index 71dcf0e..3c90250 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -771,6 +771,17 @@ struct ecryptfs_parse_tag_70_packet_silly_stack {
 /**
  * parse_tag_70_packet - Parse and process FNEK-encrypted passphrase packet
  * @filename: This function kmalloc's the memory for the filename
+ * @filename_size: This function sets this to the amount of memory
+ *                 kmalloc'd for the filename
+ * @packet_size: This function sets this to the the number of octets
+ *               in the packet parsed
+ * @mount_crypt_stat: The mount-wide cryptographic context
+ * @data: The memory location containing the start of the tag 70
+ *        packet
+ * @max_packet_size: The maximum legal size of the packet to be parsed
+ *                   from @data
+ *
+ * Returns zero on success; non-zero otherwise
  */
 int
 ecryptfs_parse_tag_70_packet(char **filename, size_t *filename_size,
-- 
1.5.3.7

