Return-Path: <linux-kernel-owner+w=401wt.eu-S1752646AbYLUILs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbYLUILs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 03:11:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbYLUILj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 03:11:39 -0500
Received: from ozlabs.org ([203.10.76.45]:55513 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195AbYLUILi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 03:11:38 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Define smp_call_function_many for UP
Date: Sun, 21 Dec 2008 18:41:31 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Hollis Blanchard <hollisb@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       "kvm-devel" <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org
References: <20081208160945.7535A25006E@cleopatra.tlv.redhat.com> <200812191613.57719.rusty@rustcorp.com.au> <alpine.LFD.2.00.0812190903040.14014@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0812190903040.14014@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812211841.32138.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 20 December 2008 03:33:26 Linus Torvalds wrote:
> Christmas at Rusty's house:
> 
> Dreary.

Far from!  Sure, it's Arabella's first Xmas, but a Very Kernel Christmas can
be lots of fun.  Why just this morning, we did this together!  See if you
can tell which bits are hers...

Subject: Decorate lib/rbtree.c
From: Rusty and Arabella Russell <rustabella@rustcorp.com.au>

A slight enhancement to the comments in lib/rbtree.c.

Signed-off-by: Rusty and Arabella Russell <rustabella@rustcorp.com.au>
---
 lib/rbtree.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/lib/rbtree.c b/lib/rbtree.c
index 48499c2..7848186 100644
--- a/lib/rbtree.c
+++ b/lib/rbtree.c
@@ -17,7 +17,8 @@
   along with this program; if not, write to the Free Software
   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 
-  linux/lib/rbtree.c
+  An excellent description of this algorithm can be found at:
+	http://en.wikipedia.org/wiki/Red-black_tree
 */
 
 #include <linux/rbtree.h>
@@ -291,6 +292,7 @@ EXPORT_SYMBOL(rb_erase);
 
 /*
  * This function returns the first node (in sort order) of the tree.
+ * ssdddsddddddddddddd
  */
 struct rb_node *rb_first(struct rb_root *root)
 {


