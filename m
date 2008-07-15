Return-Path: <linux-kernel-owner+w=401wt.eu-S1758274AbYGOWN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274AbYGOWN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 18:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758980AbYGOWNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 18:13:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50016 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755363AbYGOWNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 18:13:43 -0400
X-Greylist: delayed 2135 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jul 2008 18:12:35 EDT
Date: Tue, 15 Jul 2008 17:32:41 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, joe@perches.com, greg@kroah.com,
       nick@nick-andrew.net, randy.dunlap@oracle.com
Subject: [PATCH 2/7] dynamic debug v2 - nfs conversion
Message-ID: <20080715213241.GC23331@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-convert sunrpc debug facility

Signed-off-by: Jason Baron <jbaron@redhat.com>


---

 fs/lockd/clntlock.c                  |    1 +
 fs/lockd/clntproc.c                  |    1 +
 fs/lockd/host.c                      |    1 +
 fs/lockd/mon.c                       |    1 +
 fs/lockd/svc.c                       |    1 +
 fs/lockd/svc4proc.c                  |    1 +
 fs/lockd/svclock.c                   |    1 +
 fs/lockd/svcproc.c                   |    1 +
 fs/lockd/svcshare.c                  |    1 +
 fs/lockd/svcsubs.c                   |    1 +
 fs/lockd/xdr.c                       |    1 +
 fs/lockd/xdr4.c                      |    1 +
 fs/nfs/callback.c                    |    1 +
 fs/nfs/callback_proc.c               |    1 +
 fs/nfs/callback_xdr.c                |    1 +
 fs/nfs/client.c                      |    1 +
 fs/nfs/delegation.c                  |    1 +
 fs/nfs/dir.c                         |    1 +
 fs/nfs/direct.c                      |    1 +
 fs/nfs/file.c                        |    1 +
 fs/nfs/getroot.c                     |    1 +
 fs/nfs/idmap.c                       |    1 +
 fs/nfs/inode.c                       |    1 +
 fs/nfs/mount_clnt.c                  |    1 +
 fs/nfs/namespace.c                   |    1 +
 fs/nfs/nfs2xdr.c                     |    1 +
 fs/nfs/nfs3acl.c                     |    1 +
 fs/nfs/nfs3proc.c                    |    1 +
 fs/nfs/nfs3xdr.c                     |    1 +
 fs/nfs/nfs4namespace.c               |    1 +
 fs/nfs/nfs4proc.c                    |    1 +
 fs/nfs/nfs4renewd.c                  |    1 +
 fs/nfs/nfs4state.c                   |    1 +
 fs/nfs/nfs4xdr.c                     |    1 +
 fs/nfs/nfsroot.c                     |    1 +
 fs/nfs/pagelist.c                    |    1 +
 fs/nfs/proc.c                        |    1 +
 fs/nfs/read.c                        |    1 +
 fs/nfs/super.c                       |    1 +
 fs/nfs/symlink.c                     |    1 +
 fs/nfs/sysctl.c                      |    1 +
 fs/nfs/unlink.c                      |    1 +
 fs/nfs/write.c                       |    1 +
 fs/nfsd/auth.c                       |    1 +
 fs/nfsd/export.c                     |    1 +
 fs/nfsd/lockd.c                      |    1 +
 fs/nfsd/nfs2acl.c                    |    1 +
 fs/nfsd/nfs3acl.c                    |    1 +
 fs/nfsd/nfs3proc.c                   |    1 +
 fs/nfsd/nfs3xdr.c                    |    1 +
 fs/nfsd/nfs4acl.c                    |    1 +
 fs/nfsd/nfs4callback.c               |    1 +
 fs/nfsd/nfs4idmap.c                  |    1 +
 fs/nfsd/nfs4proc.c                   |    1 +
 fs/nfsd/nfs4recover.c                |    1 +
 fs/nfsd/nfs4state.c                  |    1 +
 fs/nfsd/nfs4xdr.c                    |    1 +
 fs/nfsd/nfscache.c                   |    1 +
 fs/nfsd/nfsctl.c                     |    1 +
 fs/nfsd/nfsfh.c                      |    1 +
 fs/nfsd/nfsproc.c                    |    1 +
 fs/nfsd/nfssvc.c                     |    1 +
 fs/nfsd/nfsxdr.c                     |    1 +
 fs/nfsd/stats.c                      |    1 +
 fs/nfsd/vfs.c                        |    1 +
 include/linux/dynamic_debug_lockd.h  |    6 ++++++
 include/linux/dynamic_debug_nfs.h    |    6 ++++++
 include/linux/dynamic_debug_nfsd.h   |    6 ++++++
 include/linux/dynamic_debug_sunrpc.h |    6 ++++++
 include/linux/lockd/debug.h          |    6 +++++-
 include/linux/nfs_fs.h               |    6 +++++-
 include/linux/nfsd/debug.h           |    6 +++++-
 include/linux/sunrpc/debug.h         |    8 +++++++-
 net/sunrpc/auth.c                    |    1 +
 net/sunrpc/auth_null.c               |    1 +
 net/sunrpc/auth_unix.c               |    1 +
 net/sunrpc/cache.c                   |    1 +
 net/sunrpc/clnt.c                    |    1 +
 net/sunrpc/rpc_pipe.c                |    1 +
 net/sunrpc/rpcb_clnt.c               |    1 +
 net/sunrpc/sched.c                   |    1 +
 net/sunrpc/socklib.c                 |    1 +
 net/sunrpc/stats.c                   |    1 +
 net/sunrpc/sunrpc_syms.c             |    1 +
 net/sunrpc/svc.c                     |    1 +
 net/sunrpc/svc_xprt.c                |    1 +
 net/sunrpc/svcauth.c                 |    1 +
 net/sunrpc/svcauth_unix.c            |    1 +
 net/sunrpc/svcsock.c                 |    1 +
 net/sunrpc/sysctl.c                  |    1 +
 net/sunrpc/timer.c                   |    1 +
 net/sunrpc/xdr.c                     |    1 +
 net/sunrpc/xprt.c                    |    1 +
 net/sunrpc/xprtsock.c                |    1 +
 94 files changed, 132 insertions(+), 4 deletions(-)
 create mode 100644 include/linux/dynamic_debug_lockd.h
 create mode 100644 include/linux/dynamic_debug_nfs.h
 create mode 100644 include/linux/dynamic_debug_nfsd.h
 create mode 100644 include/linux/dynamic_debug_sunrpc.h


diff --git a/fs/lockd/clntlock.c b/fs/lockd/clntlock.c
index 0b45fd3..d434ed9 100644
--- a/fs/lockd/clntlock.c
+++ b/fs/lockd/clntlock.c
@@ -14,6 +14,7 @@
 #include <linux/sunrpc/svc.h>
 #include <linux/lockd/lockd.h>
 #include <linux/smp_lock.h>
+#include <linux/dynamic_debug_lockd.h>
 
 #define NLMDBG_FACILITY		NLMDBG_CLIENT
 
diff --git a/fs/lockd/clntproc.c b/fs/lockd/clntproc.c
index b6b74a6..44e5348 100644
--- a/fs/lockd/clntproc.c
+++ b/fs/lockd/clntproc.c
@@ -13,6 +13,7 @@
 #include <linux/nfs_fs.h>
 #include <linux/utsname.h>
 #include <linux/freezer.h>
+#include <linux/dynamic_debug_lockd.h>
 #include <linux/sunrpc/clnt.h>
 #include <linux/sunrpc/svc.h>
 #include <linux/lockd/lockd.h>
diff --git a/fs/lockd/host.c b/fs/lockd/host.c
index f1ef49f..3620a53 100644
--- a/fs/lockd/host.c
+++ b/fs/lockd/host.c
@@ -11,6 +11,7 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/in.h>
+#include <linux/dynamic_debug_lockd.h>
 #include <linux/sunrpc/clnt.h>
 #include <linux/sunrpc/svc.h>
 #include <linux/lockd/lockd.h>
diff --git a/fs/lockd/mon.c b/fs/lockd/mon.c
index 908b23f..68c1940 100644
--- a/fs/lockd/mon.c
+++ b/fs/lockd/mon.c
@@ -9,6 +9,7 @@
 #include <linux/types.h>
 #include <linux/utsname.h>
 #include <linux/kernel.h>
+#include <linux/dynamic_debug_lockd.h>
 #include <linux/sunrpc/clnt.h>
 #include <linux/sunrpc/xprtsock.h>
 #include <linux/sunrpc/svc.h>
diff --git a/fs/lockd/svc.c b/fs/lockd/svc.c
index 1ed8bd4..e415419 100644
--- a/fs/lockd/svc.c
+++ b/fs/lockd/svc.c
@@ -36,6 +36,7 @@
 #include <linux/lockd/lockd.h>
 #include <linux/lockd/sm_inter.h>
 #include <linux/nfs.h>
+#include <linux/dynamic_debug_lockd.h>
 
 #define NLMDBG_FACILITY		NLMDBG_SVC
 #define LOCKD_BUFSIZE		(1024 + NLMSVC_XDRSIZE)
diff --git a/fs/lockd/svc4proc.c b/fs/lockd/svc4proc.c
index 385437e..78240ea 100644
--- a/fs/lockd/svc4proc.c
+++ b/fs/lockd/svc4proc.c
@@ -11,6 +11,7 @@
 #include <linux/time.h>
 #include <linux/slab.h>
 #include <linux/in.h>
+#include <linux/dynamic_debug_lockd.h>
 #include <linux/sunrpc/svc.h>
 #include <linux/sunrpc/clnt.h>
 #include <linux/nfsd/nfsd.h>
diff --git a/fs/lockd/svclock.c b/fs/lockd/svclock.c
index fe9bdb4..97b82f1 100644
--- a/fs/lockd/svclock.c
+++ b/fs/lockd/svclock.c
@@ -25,6 +25,7 @@
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/smp_lock.h>
+#include <linux/dynamic_debug_lockd.h>
 #include <linux/sunrpc/clnt.h>
 #include <linux/sunrpc/svc.h>
 #include <linux/lockd/nlm.h>
diff --git a/fs/lockd/svcproc.c b/fs/lockd/svcproc.c
index 88379cc..abe17d0 100644
--- a/fs/lockd/svcproc.c
+++ b/fs/lockd/svcproc.c
@@ -11,6 +11,7 @@
 #include <linux/time.h>
 #include <linux/slab.h>
 #include <linux/in.h>
+#include <linux/dynamic_debug_lockd.h>
 #include <linux/sunrpc/svc.h>
 #include <linux/sunrpc/clnt.h>
 #include <linux/nfsd/nfsd.h>
diff --git a/fs/lockd/svcshare.c b/fs/lockd/svcshare.c
index 068886d..0633db6 100644
--- a/fs/lockd/svcshare.c
+++ b/fs/lockd/svcshare.c
@@ -10,6 +10,7 @@
 #include <linux/unistd.h>
 #include <linux/string.h>
 #include <linux/slab.h>
+#include <linux/dynamic_debug_lockd.h>
 
 #include <linux/sunrpc/clnt.h>
 #include <linux/sunrpc/svc.h>
diff --git a/fs/lockd/svcsubs.c b/fs/lockd/svcsubs.c
index dbbefbc..7ae923d 100644
--- a/fs/lockd/svcsubs.c
+++ b/fs/lockd/svcsubs.c
@@ -11,6 +11,7 @@
 #include <linux/time.h>
 #include <linux/in.h>
 #include <linux/mutex.h>
+#include <linux/dynamic_debug_lockd.h>
 #include <linux/sunrpc/svc.h>
 #include <linux/sunrpc/clnt.h>
 #include <linux/nfsd/nfsfh.h>
diff --git a/fs/lockd/xdr.c b/fs/lockd/xdr.c
index 3e459e1..7275e0d 100644
--- a/fs/lockd/xdr.c
+++ b/fs/lockd/xdr.c
@@ -10,6 +10,7 @@
 #include <linux/sched.h>
 #include <linux/utsname.h>
 #include <linux/nfs.h>
+#include <linux/dynamic_debug_lockd.h>
 
 #include <linux/sunrpc/xdr.h>
 #include <linux/sunrpc/clnt.h>
diff --git a/fs/lockd/xdr4.c b/fs/lockd/xdr4.c
index 43ff939..50f371b 100644
--- a/fs/lockd/xdr4.c
+++ b/fs/lockd/xdr4.c
@@ -11,6 +11,7 @@
 #include <linux/sched.h>
 #include <linux/utsname.h>
 #include <linux/nfs.h>
+#include <linux/dynamic_debug_lockd.h>
 
 #include <linux/sunrpc/xdr.h>
 #include <linux/sunrpc/clnt.h>
diff --git a/fs/nfs/callback.c b/fs/nfs/callback.c
index 66648dd..33e77f6 100644
--- a/fs/nfs/callback.c
+++ b/fs/nfs/callback.c
@@ -15,6 +15,7 @@
 #include <linux/nfs_fs.h>
 #include <linux/mutex.h>
 #include <linux/freezer.h>
+#include <linux/dynamic_debug_nfs.h>
 
 #include <net/inet_sock.h>
 
diff --git a/fs/nfs/callback_proc.c b/fs/nfs/callback_proc.c
index 15f7785..37ce142 100644
--- a/fs/nfs/callback_proc.c
+++ b/fs/nfs/callback_proc.c
@@ -7,6 +7,7 @@
  */
 #include <linux/nfs4.h>
 #include <linux/nfs_fs.h>
+#include <linux/dynamic_debug_nfs.h>
 #include "nfs4_fs.h"
 #include "callback.h"
 #include "delegation.h"
diff --git a/fs/nfs/callback_xdr.c b/fs/nfs/callback_xdr.c
index 13619d2..085c272 100644
--- a/fs/nfs/callback_xdr.c
+++ b/fs/nfs/callback_xdr.c
@@ -9,6 +9,7 @@
 #include <linux/sunrpc/svc.h>
 #include <linux/nfs4.h>
 #include <linux/nfs_fs.h>
+#include <linux/dynamic_debug_nfs.h>
 #include "nfs4_fs.h"
 #include "callback.h"
 
diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index c5c0175..744bae1 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -37,6 +37,7 @@
 #include <linux/in6.h>
 #include <net/ipv6.h>
 #include <linux/nfs_xdr.h>
+#include <linux/dynamic_debug_nfs.h>
 
 #include <asm/system.h>
 
diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index 00a5e44..d7c7aeb 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -15,6 +15,7 @@
 #include <linux/nfs4.h>
 #include <linux/nfs_fs.h>
 #include <linux/nfs_xdr.h>
+#include <linux/dynamic_debug_nfs.h>
 
 #include "nfs4_fs.h"
 #include "delegation.h"
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index d9e30ac..75b57c1 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -34,6 +34,7 @@
 #include <linux/namei.h>
 #include <linux/mount.h>
 #include <linux/sched.h>
+#include <linux/dynamic_debug_nfs.h>
 
 #include "nfs4_fs.h"
 #include "delegation.h"
diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 16844f9..6f4364c 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -48,6 +48,7 @@
 #include <linux/nfs_fs.h>
 #include <linux/nfs_page.h>
 #include <linux/sunrpc/clnt.h>
+#include <linux/dynamic_debug_nfs.h>
 
 #include <asm/system.h>
 #include <asm/uaccess.h>
diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 5d2e9d9..6e078a6 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -28,6 +28,7 @@
 #include <linux/pagemap.h>
 #include <linux/smp_lock.h>
 #include <linux/aio.h>
+#include <linux/dynamic_debug_nfs.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
diff --git a/fs/nfs/getroot.c b/fs/nfs/getroot.c
index fae9719..0076048 100644
--- a/fs/nfs/getroot.c
+++ b/fs/nfs/getroot.c
@@ -32,6 +32,7 @@
 #include <linux/namei.h>
 #include <linux/mnt_namespace.h>
 #include <linux/security.h>
+#include <linux/dynamic_debug_nfs.h>
 
 #include <asm/system.h>
 #include <asm/uaccess.h>
diff --git a/fs/nfs/idmap.c b/fs/nfs/idmap.c
index 86147b0..d4cc873 100644
--- a/fs/nfs/idmap.c
+++ b/fs/nfs/idmap.c
@@ -50,6 +50,7 @@
 #include <linux/nfs_fs.h>
 
 #include <linux/nfs_idmap.h>
+#include <linux/dynamic_debug_nfs.h>
 #include "nfs4_fs.h"
 
 #define IDMAP_HASH_SZ          128
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 6f88d7c..87d715b 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -37,6 +37,7 @@
 #include <linux/vfs.h>
 #include <linux/inet.h>
 #include <linux/nfs_xdr.h>
+#include <linux/dynamic_debug_nfs.h>
 
 #include <asm/system.h>
 #include <asm/uaccess.h>
diff --git a/fs/nfs/mount_clnt.c b/fs/nfs/mount_clnt.c
index 49c7cd0..4523c33 100644
--- a/fs/nfs/mount_clnt.c
+++ b/fs/nfs/mount_clnt.c
@@ -14,6 +14,7 @@
 #include <linux/sunrpc/clnt.h>
 #include <linux/sunrpc/sched.h>
 #include <linux/nfs_fs.h>
+#include <linux/dynamic_debug_nfs.h>
 
 #ifdef RPC_DEBUG
 # define NFSDBG_FACILITY	NFSDBG_MOUNT
diff --git a/fs/nfs/namespace.c b/fs/nfs/namespace.c
index 607f6eb..edbe0e8 100644
--- a/fs/nfs/namespace.c
+++ b/fs/nfs/namespace.c
@@ -14,6 +14,7 @@
 #include <linux/string.h>
 #include <linux/sunrpc/clnt.h>
 #include <linux/vfs.h>
+#include <linux/dynamic_debug_nfs.h>
 #include "internal.h"
 
 #define NFSDBG_FACILITY		NFSDBG_VFS
diff --git a/fs/nfs/nfs2xdr.c b/fs/nfs/nfs2xdr.c
index 1f7ea67..5434f33 100644
--- a/fs/nfs/nfs2xdr.c
+++ b/fs/nfs/nfs2xdr.c
@@ -23,6 +23,7 @@
 #include <linux/nfs.h>
 #include <linux/nfs2.h>
 #include <linux/nfs_fs.h>
+#include <linux/dynamic_debug_nfs.h>
 #include "internal.h"
 
 #define NFSDBG_FACILITY		NFSDBG_XDR
diff --git a/fs/nfs/nfs3acl.c b/fs/nfs/nfs3acl.c
index 9b73625..778c6ac 100644
--- a/fs/nfs/nfs3acl.c
+++ b/fs/nfs/nfs3acl.c
@@ -4,6 +4,7 @@
 #include <linux/nfs_fs.h>
 #include <linux/posix_acl_xattr.h>
 #include <linux/nfsacl.h>
+#include <linux/dynamic_debug_nfs.h>
 
 #define NFSDBG_FACILITY	NFSDBG_PROC
 
diff --git a/fs/nfs/nfs3proc.c b/fs/nfs/nfs3proc.c
index 549dbce..1f973db 100644
--- a/fs/nfs/nfs3proc.c
+++ b/fs/nfs/nfs3proc.c
@@ -17,6 +17,7 @@
 #include <linux/nfs_page.h>
 #include <linux/lockd/bind.h>
 #include <linux/nfs_mount.h>
+#include <linux/dynamic_debug_nfs.h>
 
 #include "iostat.h"
 #include "internal.h"
diff --git a/fs/nfs/nfs3xdr.c b/fs/nfs/nfs3xdr.c
index 3917e2f..f5ad54f 100644
--- a/fs/nfs/nfs3xdr.c
+++ b/fs/nfs/nfs3xdr.c
@@ -22,6 +22,7 @@
 #include <linux/nfs3.h>
 #include <linux/nfs_fs.h>
 #include <linux/nfsacl.h>
+#include <linux/dynamic_debug_nfs.h>
 #include "internal.h"
 
 #define NFSDBG_FACILITY		NFSDBG_XDR
diff --git a/fs/nfs/nfs4namespace.c b/fs/nfs/nfs4namespace.c
index 5f9ba41..4862c2a 100644
--- a/fs/nfs/nfs4namespace.c
+++ b/fs/nfs/nfs4namespace.c
@@ -15,6 +15,7 @@
 #include <linux/sunrpc/clnt.h>
 #include <linux/vfs.h>
 #include <linux/inet.h>
+#include <linux/dynamic_debug_nfs.h>
 #include "internal.h"
 #include "nfs4_fs.h"
 
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 7ce0786..68d2080 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -48,6 +48,7 @@
 #include <linux/smp_lock.h>
 #include <linux/namei.h>
 #include <linux/mount.h>
+#include <linux/dynamic_debug_nfs.h>
 
 #include "nfs4_fs.h"
 #include "delegation.h"
diff --git a/fs/nfs/nfs4renewd.c b/fs/nfs/nfs4renewd.c
index 5e2e4af..7901a43 100644
--- a/fs/nfs/nfs4renewd.c
+++ b/fs/nfs/nfs4renewd.c
@@ -51,6 +51,7 @@
 #include <linux/nfs.h>
 #include <linux/nfs4.h>
 #include <linux/nfs_fs.h>
+#include <linux/dynamic_debug_nfs.h>
 #include "nfs4_fs.h"
 #include "delegation.h"
 
diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index b962397..09ca89a 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -48,6 +48,7 @@
 #include <linux/random.h>
 #include <linux/workqueue.h>
 #include <linux/bitops.h>
+#include <linux/dynamic_debug_nfs.h>
 
 #include "nfs4_fs.h"
 #include "callback.h"
diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index db1ed9c..265869c 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -51,6 +51,7 @@
 #include <linux/nfs4.h>
 #include <linux/nfs_fs.h>
 #include <linux/nfs_idmap.h>
+#include <linux/dynamic_debug_nfs.h>
 #include "nfs4_fs.h"
 
 #define NFSDBG_FACILITY		NFSDBG_XDR
diff --git a/fs/nfs/nfsroot.c b/fs/nfs/nfsroot.c
index 531379d..cf23835 100644
--- a/fs/nfs/nfsroot.c
+++ b/fs/nfs/nfsroot.c
@@ -87,6 +87,7 @@
 #include <linux/root_dev.h>
 #include <net/ipconfig.h>
 #include <linux/parser.h>
+#include <linux/dynamic_debug_nfs.h>
 
 /* Define this to allow debugging output */
 #undef NFSROOT_DEBUG
diff --git a/fs/nfs/pagelist.c b/fs/nfs/pagelist.c
index 7f07920..ad754d8 100644
--- a/fs/nfs/pagelist.c
+++ b/fs/nfs/pagelist.c
@@ -18,6 +18,7 @@
 #include <linux/nfs_page.h>
 #include <linux/nfs_fs.h>
 #include <linux/nfs_mount.h>
+#include <linux/dynamic_debug_nfs.h>
 
 #include "internal.h"
 
diff --git a/fs/nfs/proc.c b/fs/nfs/proc.c
index 5ccf7fa..711f860 100644
--- a/fs/nfs/proc.c
+++ b/fs/nfs/proc.c
@@ -43,6 +43,7 @@
 #include <linux/nfs_fs.h>
 #include <linux/nfs_page.h>
 #include <linux/lockd/bind.h>
+#include <linux/dynamic_debug_nfs.h>
 #include "internal.h"
 
 #define NFSDBG_FACILITY		NFSDBG_PROC
diff --git a/fs/nfs/read.c b/fs/nfs/read.c
index 5a70be5..ee05a8e 100644
--- a/fs/nfs/read.c
+++ b/fs/nfs/read.c
@@ -19,6 +19,7 @@
 #include <linux/nfs_fs.h>
 #include <linux/nfs_page.h>
 #include <linux/smp_lock.h>
+#include <linux/dynamic_debug_nfs.h>
 
 #include <asm/system.h>
 
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index f921902..ce3352e 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -50,6 +50,7 @@
 #include <linux/nfs_xdr.h>
 #include <linux/magic.h>
 #include <linux/parser.h>
+#include <linux/dynamic_debug_nfs.h>
 
 #include <asm/system.h>
 #include <asm/uaccess.h>
diff --git a/fs/nfs/symlink.c b/fs/nfs/symlink.c
index 83e865a..33334c5 100644
--- a/fs/nfs/symlink.c
+++ b/fs/nfs/symlink.c
@@ -23,6 +23,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/namei.h>
+#include <linux/dynamic_debug_nfs.h>
 
 /* Symlink caching in the page cache is even more simplistic
  * and straight-forward than readdir caching.
diff --git a/fs/nfs/sysctl.c b/fs/nfs/sysctl.c
index b62481d..1c952b2 100644
--- a/fs/nfs/sysctl.c
+++ b/fs/nfs/sysctl.c
@@ -12,6 +12,7 @@
 #include <linux/nfs4.h>
 #include <linux/nfs_idmap.h>
 #include <linux/nfs_fs.h>
+#include <linux/dynamic_debug_nfs.h>
 
 #include "callback.h"
 
diff --git a/fs/nfs/unlink.c b/fs/nfs/unlink.c
index 7574153..ae9df4d 100644
--- a/fs/nfs/unlink.c
+++ b/fs/nfs/unlink.c
@@ -13,6 +13,7 @@
 #include <linux/nfs_fs.h>
 #include <linux/sched.h>
 #include <linux/wait.h>
+#include <linux/dynamic_debug_nfs.h>
 
 #include "internal.h"
 
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index bed6341..8f7b563 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -19,6 +19,7 @@
 #include <linux/nfs_mount.h>
 #include <linux/nfs_page.h>
 #include <linux/backing-dev.h>
+#include <linux/dynamic_debug_nfs.h>
 
 #include <asm/uaccess.h>
 
diff --git a/fs/nfsd/auth.c b/fs/nfsd/auth.c
index d13403e..cb56871 100644
--- a/fs/nfsd/auth.c
+++ b/fs/nfsd/auth.c
@@ -6,6 +6,7 @@
 
 #include <linux/types.h>
 #include <linux/sched.h>
+#include <linux/dynamic_debug_nfsd.h>
 #include <linux/sunrpc/svc.h>
 #include <linux/sunrpc/svcauth.h>
 #include <linux/nfsd/nfsd.h>
diff --git a/fs/nfsd/export.c b/fs/nfsd/export.c
index 8a6f7c9..14cdf06 100644
--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -27,6 +27,7 @@
 #include <linux/hash.h>
 #include <linux/module.h>
 #include <linux/exportfs.h>
+#include <linux/dynamic_debug_nfsd.h>
 
 #include <linux/sunrpc/svc.h>
 #include <linux/nfsd/nfsd.h>
diff --git a/fs/nfsd/lockd.c b/fs/nfsd/lockd.c
index 9e4a568..bc559ff 100644
--- a/fs/nfsd/lockd.c
+++ b/fs/nfsd/lockd.c
@@ -12,6 +12,7 @@
 #include <linux/fs.h>
 #include <linux/file.h>
 #include <linux/mount.h>
+#include <linux/dynamic_debug_nfsd.h>
 #include <linux/sunrpc/clnt.h>
 #include <linux/sunrpc/svc.h>
 #include <linux/nfsd/nfsd.h>
diff --git a/fs/nfsd/nfs2acl.c b/fs/nfsd/nfs2acl.c
index 1c3b765..3888590 100644
--- a/fs/nfsd/nfs2acl.c
+++ b/fs/nfsd/nfs2acl.c
@@ -14,6 +14,7 @@
 #include <linux/nfsd/xdr3.h>
 #include <linux/posix_acl.h>
 #include <linux/nfsacl.h>
+#include <linux/dynamic_debug_nfsd.h>
 
 #define NFSDDBG_FACILITY		NFSDDBG_PROC
 #define RETURN_STATUS(st)	{ resp->status = (st); return (st); }
diff --git a/fs/nfsd/nfs3acl.c b/fs/nfsd/nfs3acl.c
index b647f2f..b133037 100644
--- a/fs/nfsd/nfs3acl.c
+++ b/fs/nfsd/nfs3acl.c
@@ -13,6 +13,7 @@
 #include <linux/nfsd/xdr3.h>
 #include <linux/posix_acl.h>
 #include <linux/nfsacl.h>
+#include <linux/dynamic_debug_nfsd.h>
 
 #define RETURN_STATUS(st)	{ resp->status = (st); return (st); }
 
diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index c721a1e..d8bd974 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -18,6 +18,7 @@
 #include <linux/unistd.h>
 #include <linux/slab.h>
 #include <linux/major.h>
+#include <linux/dynamic_debug_nfsd.h>
 
 #include <linux/sunrpc/svc.h>
 #include <linux/nfsd/nfsd.h>
diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 17d0dd9..33c4810 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -17,6 +17,7 @@
 #include <linux/namei.h>
 #include <linux/mm.h>
 #include <linux/vfs.h>
+#include <linux/dynamic_debug_nfsd.h>
 #include <linux/sunrpc/xdr.h>
 #include <linux/sunrpc/svc.h>
 #include <linux/nfsd/nfsd.h>
diff --git a/fs/nfsd/nfs4acl.c b/fs/nfsd/nfs4acl.c
index b6ed383..c2d84b2 100644
--- a/fs/nfsd/nfs4acl.c
+++ b/fs/nfsd/nfs4acl.c
@@ -46,6 +46,7 @@
 #include <linux/posix_acl.h>
 #include <linux/nfs4.h>
 #include <linux/nfs4_acl.h>
+#include <linux/dynamic_debug_nfsd.h>
 
 
 /* mode bit translations: */
diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
index aae2b29..f203384 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -47,6 +47,7 @@
 #include <linux/nfsd/state.h>
 #include <linux/sunrpc/sched.h>
 #include <linux/nfs4.h>
+#include <linux/dynamic_debug_nfsd.h>
 
 #define NFSDDBG_FACILITY                NFSDDBG_PROC
 
diff --git a/fs/nfsd/nfs4idmap.c b/fs/nfsd/nfs4idmap.c
index 996bd88..ddcc44d 100644
--- a/fs/nfsd/nfs4idmap.c
+++ b/fs/nfsd/nfs4idmap.c
@@ -36,6 +36,7 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/dynamic_debug_nfsd.h>
 
 #include <linux/mm.h>
 #include <linux/utsname.h>
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index c309c88..cdadc49 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -39,6 +39,7 @@
 #include <linux/major.h>
 #include <linux/slab.h>
 #include <linux/file.h>
+#include <linux/dynamic_debug_nfsd.h>
 
 #include <linux/sunrpc/svc.h>
 #include <linux/nfsd/nfsd.h>
diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index 145b3c8..3c9274e 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -47,6 +47,7 @@
 #include <linux/crypto.h>
 #include <linux/sched.h>
 #include <linux/mount.h>
+#include <linux/dynamic_debug_nfsd.h>
 
 #define NFSDDBG_FACILITY                NFSDDBG_PROC
 
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 81a75f3..20a6053 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -54,6 +54,7 @@
 #include <linux/mutex.h>
 #include <linux/lockd/bind.h>
 #include <linux/module.h>
+#include <linux/dynamic_debug_nfsd.h>
 
 #define NFSDDBG_FACILITY                NFSDDBG_PROC
 
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 0e6a179..87a3ea1 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -47,6 +47,7 @@
 #include <linux/fs.h>
 #include <linux/namei.h>
 #include <linux/vfs.h>
+#include <linux/dynamic_debug_nfsd.h>
 #include <linux/sunrpc/xdr.h>
 #include <linux/sunrpc/svc.h>
 #include <linux/sunrpc/clnt.h>
diff --git a/fs/nfsd/nfscache.c b/fs/nfsd/nfscache.c
index 5bfc2ac..7b02255 100644
--- a/fs/nfsd/nfscache.c
+++ b/fs/nfsd/nfscache.c
@@ -16,6 +16,7 @@
 #include <linux/string.h>
 #include <linux/spinlock.h>
 #include <linux/list.h>
+#include <linux/dynamic_debug_nfsd.h>
 
 #include <linux/sunrpc/svc.h>
 #include <linux/nfsd/nfsd.h>
diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 8516137..2929c20 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -25,6 +25,7 @@
 #include <linux/string.h>
 #include <linux/smp_lock.h>
 #include <linux/ctype.h>
+#include <linux/dynamic_debug_nfsd.h>
 
 #include <linux/nfs.h>
 #include <linux/nfsd_idmap.h>
diff --git a/fs/nfsd/nfsfh.c b/fs/nfsd/nfsfh.c
index 3e6b3f4..89cfb1e 100644
--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -17,6 +17,7 @@
 #include <linux/dcache.h>
 #include <linux/exportfs.h>
 #include <linux/mount.h>
+#include <linux/dynamic_debug_nfsd.h>
 
 #include <linux/sunrpc/clnt.h>
 #include <linux/sunrpc/svc.h>
diff --git a/fs/nfsd/nfsproc.c b/fs/nfsd/nfsproc.c
index 6cfc96a..c10ed00 100644
--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -18,6 +18,7 @@
 #include <linux/namei.h>
 #include <linux/unistd.h>
 #include <linux/slab.h>
+#include <linux/dynamic_debug_nfsd.h>
 
 #include <linux/sunrpc/clnt.h>
 #include <linux/sunrpc/svc.h>
diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 9647b0f..4277849 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -21,6 +21,7 @@
 #include <linux/smp_lock.h>
 #include <linux/freezer.h>
 #include <linux/fs_struct.h>
+#include <linux/dynamic_debug_nfsd.h>
 
 #include <linux/sunrpc/types.h>
 #include <linux/sunrpc/stats.h>
diff --git a/fs/nfsd/nfsxdr.c b/fs/nfsd/nfsxdr.c
index afd08e2..d29c6ea 100644
--- a/fs/nfsd/nfsxdr.c
+++ b/fs/nfsd/nfsxdr.c
@@ -15,6 +15,7 @@
 #include <linux/nfsd/nfsd.h>
 #include <linux/nfsd/xdr.h>
 #include <linux/mm.h>
+#include <linux/dynamic_debug_nfsd.h>
 #include "auth.h"
 
 #define NFSDDBG_FACILITY		NFSDDBG_XDR
diff --git a/fs/nfsd/stats.c b/fs/nfsd/stats.c
index 71944cd..75dbc07 100644
--- a/fs/nfsd/stats.c
+++ b/fs/nfsd/stats.c
@@ -29,6 +29,7 @@
 #include <linux/seq_file.h>
 #include <linux/stat.h>
 #include <linux/module.h>
+#include <linux/dynamic_debug_nfsd.h>
 
 #include <linux/sunrpc/svc.h>
 #include <linux/sunrpc/stats.h>
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 304bf5f..eae6524 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -55,6 +55,7 @@
 #include <linux/security.h>
 #endif /* CONFIG_NFSD_V4 */
 #include <linux/jhash.h>
+#include <linux/dynamic_debug_nfsd.h>
 
 #include <asm/uaccess.h>
 
diff --git a/include/linux/dynamic_debug_lockd.h b/include/linux/dynamic_debug_lockd.h
new file mode 100644
index 0000000..4a2603e
--- /dev/null
+++ b/include/linux/dynamic_debug_lockd.h
@@ -0,0 +1,6 @@
+#undef DYNAMIC_DEBUG_NUM_FLAGS
+#define DYNAMIC_DEBUG_NUM_FLAGS "10"
+#undef DYNAMIC_DEBUG_FLAG_NAMES
+#define DYNAMIC_DEBUG_FLAG_NAMES "NLMDBG_SVC,NLMDBG_CLIENT,NLMDBG_CLNTLOCK,NLMDBG_SVCLOCK,NLMDBG_MONITOR,NLMDBG_CLNTSUBS,NLMDBG_SVCSUBS,NLMDBG_HOSTCACHE,NLMDBG_XDR,NLMDBG_ALL"
+#undef DYNAMIC_DEBUG_TYPE
+#define DYNAMIC_DEBUG_TYPE "2"
diff --git a/include/linux/dynamic_debug_nfs.h b/include/linux/dynamic_debug_nfs.h
new file mode 100644
index 0000000..ca611b8
--- /dev/null
+++ b/include/linux/dynamic_debug_nfs.h
@@ -0,0 +1,6 @@
+#undef DYNAMIC_DEBUG_NUM_FLAGS
+#define DYNAMIC_DEBUG_NUM_FLAGS "12"
+#undef DYNAMIC_DEBUG_FLAG_NAMES
+#define DYNAMIC_DEBUG_FLAG_NAMES "NFSDBG_VFS,NFSDBG_DIRCACHE,NFSDBG_LOOKUPCACHE,NFSDBG_PAGECACHE,NFSDBG_PROC,NFSDBG_XDR,NFSDBG_FILE,NFSDBG_ROOT,NFSDBG_CALLBACK,NFSDBG_CLIENT,NFSDBG_MOUNT,NFSDBG_ALL"
+#undef DYNAMIC_DEBUG_TYPE
+#define DYNAMIC_DEBUG_TYPE "2"
diff --git a/include/linux/dynamic_debug_nfsd.h b/include/linux/dynamic_debug_nfsd.h
new file mode 100644
index 0000000..6d2f987
--- /dev/null
+++ b/include/linux/dynamic_debug_nfsd.h
@@ -0,0 +1,6 @@
+#undef DYNAMIC_DEBUG_NUM_FLAGS
+#define DYNAMIC_DEBUG_NUM_FLAGS "12"
+#undef DYNAMIC_DEBUG_FLAG_NAMES
+#define DYNAMIC_DEBUG_FLAG_NAMES "NFSDDBG_SOCK,NFSDDBG_FH,NFSDDBG_EXPORT,NFSDDBG_SVC,NFSDDBG_PROC,NFSDDBG_FILEOP,NFSDDBG_AUTH,NFSDDBG_REPCACHE,NFSDDBG_XDR,NFSDDBG_LOCKD,NFSDDBG_ALL,NFSDDBG_NOCHANGE"
+#undef DYNAMIC_DEBUG_TYPE
+#define DYNAMIC_DEBUG_TYPE "2"
diff --git a/include/linux/dynamic_debug_sunrpc.h b/include/linux/dynamic_debug_sunrpc.h
new file mode 100644
index 0000000..28163e7
--- /dev/null
+++ b/include/linux/dynamic_debug_sunrpc.h
@@ -0,0 +1,6 @@
+#undef DYNAMIC_DEBUG_NUM_FLAGS
+#define DYNAMIC_DEBUG_NUM_FLAGS "13"
+#undef DYNAMIC_DEBUG_FLAG_NAMES
+#define DYNAMIC_DEBUG_FLAG_NAMES "RPCDBG_XPRT,RPCDBG_CALL,RPCDBG_DEBUG,RPCDBG_NFS,RPCDBG_AUTH,RPCDBG_BIND,RPCDBG_SCHED,RPCDBG_TRANS,RPCDBG_SVCXPRT,RPCDBG_SVCDSP,RPCDBG_MISC,RPCDBG_CACHE,RPCDBG_ALL"
+#undef DYNAMIC_DEBUG_TYPE
+#define DYNAMIC_DEBUG_TYPE "2"
diff --git a/include/linux/lockd/debug.h b/include/linux/lockd/debug.h
index 34b2b7f..d809874 100644
--- a/include/linux/lockd/debug.h
+++ b/include/linux/lockd/debug.h
@@ -22,7 +22,11 @@
 #endif
 
 #undef ifdebug
-#if defined(RPC_DEBUG) && defined(LOCKD_DEBUG)
+# ifdef CONFIG_DYNAMIC_PRINTK_DEBUG
+#  define ifdebug(fac)          if (dynamic_dbg_enabled(TYPE_FLAG,   \
+							NLMDBG_##fac,\
+							nlm_debug))
+#elif defined(RPC_DEBUG) && defined(LOCKD_DEBUG)
 # define ifdebug(flag)		if (unlikely(nlm_debug & NLMDBG_##flag))
 #else
 # define ifdebug(flag)		if (0)
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index f4a0e4c..9beaded 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -592,7 +592,11 @@ extern void * nfs_root_data(void);
 #endif
 
 # undef ifdebug
-# ifdef NFS_DEBUG
+# ifdef CONFIG_DYNAMIC_PRINTK_DEBUG
+#  define ifdebug(fac)          if (dynamic_dbg_enabled(TYPE_FLAG,   \
+							NFSDBG_##fac,\
+							nfs_debug))
+# elif defined(NFS_DEBUG)
 #  define ifdebug(fac)		if (unlikely(nfs_debug & NFSDBG_##fac))
 # else
 #  define ifdebug(fac)		if (0)
diff --git a/include/linux/nfsd/debug.h b/include/linux/nfsd/debug.h
index ee4aa91..c053e22 100644
--- a/include/linux/nfsd/debug.h
+++ b/include/linux/nfsd/debug.h
@@ -38,7 +38,11 @@
 
 #ifdef __KERNEL__
 # undef ifdebug
-# ifdef NFSD_DEBUG
+# ifdef CONFIG_DYNAMIC_PRINTK_DEBUG
+#  define ifdebug(fac)          if (dynamic_dbg_enabled(TYPE_FLAG,    \
+							NFSDDBG_##fac,\
+							nfsd_debug))
+# elif NFSD_DEBUG
 #  define ifdebug(flag)		if (nfsd_debug & NFSDDBG_##flag)
 # else
 #  define ifdebug(flag)		if (0)
diff --git a/include/linux/sunrpc/debug.h b/include/linux/sunrpc/debug.h
index 10709cb..b5e4e1c 100644
--- a/include/linux/sunrpc/debug.h
+++ b/include/linux/sunrpc/debug.h
@@ -52,7 +52,13 @@ extern unsigned int		nlm_debug;
 #define dprintk(args...)	dfprintk(FACILITY, ## args)
 
 #undef ifdebug
-#ifdef RPC_DEBUG			
+#ifdef CONFIG_DYNAMIC_PRINTK_DEBUG
+#  define ifdebug(fac)          if (dynamic_dbg_enabled(TYPE_FLAG,   \
+							RPCDBG_##fac,\
+							rpc_debug))
+# define dfprintk(fac, args...) do { ifdebug(fac) printk(args); } while(0)
+# define RPC_IFDEBUG(x)         x
+#elif defined(RPC_DEBUG)
 # define ifdebug(fac)		if (unlikely(rpc_debug & RPCDBG_##fac))
 # define dfprintk(fac, args...)	do { ifdebug(fac) printk(args); } while(0)
 # define RPC_IFDEBUG(x)		x
diff --git a/net/sunrpc/auth.c b/net/sunrpc/auth.c
index eca941c..63baeae 100644
--- a/net/sunrpc/auth.c
+++ b/net/sunrpc/auth.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
+#include <linux/dynamic_debug_sunrpc.h>
 #include <linux/sunrpc/clnt.h>
 #include <linux/spinlock.h>
 
diff --git a/net/sunrpc/auth_null.c b/net/sunrpc/auth_null.c
index 537d0e8..e8d4978 100644
--- a/net/sunrpc/auth_null.c
+++ b/net/sunrpc/auth_null.c
@@ -9,6 +9,7 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/utsname.h>
+#include <linux/dynamic_debug_sunrpc.h>
 #include <linux/sunrpc/clnt.h>
 
 #ifdef RPC_DEBUG
diff --git a/net/sunrpc/auth_unix.c b/net/sunrpc/auth_unix.c
index 5ed91e5..465e256 100644
--- a/net/sunrpc/auth_unix.c
+++ b/net/sunrpc/auth_unix.c
@@ -9,6 +9,7 @@
 #include <linux/types.h>
 #include <linux/sched.h>
 #include <linux/module.h>
+#include <linux/dynamic_debug_sunrpc.h>
 #include <linux/sunrpc/clnt.h>
 #include <linux/sunrpc/auth.h>
 
diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
index b5f2786..17a9756 100644
--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -27,6 +27,7 @@
 #include <linux/net.h>
 #include <linux/workqueue.h>
 #include <linux/mutex.h>
+#include <linux/dynamic_debug_sunrpc.h>
 #include <asm/ioctls.h>
 #include <linux/sunrpc/types.h>
 #include <linux/sunrpc/cache.h>
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 7b96ff3..f61b72a 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -31,6 +31,7 @@
 #include <linux/utsname.h>
 #include <linux/workqueue.h>
 #include <linux/in6.h>
+#include <linux/dynamic_debug_sunrpc.h>
 
 #include <linux/sunrpc/clnt.h>
 #include <linux/sunrpc/rpc_pipe_fs.h>
diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
index 5a9b0e7..c29a4b3 100644
--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -22,6 +22,7 @@
 #include <linux/poll.h>
 #include <linux/wait.h>
 #include <linux/seq_file.h>
+#include <linux/dynamic_debug_sunrpc.h>
 
 #include <linux/sunrpc/clnt.h>
 #include <linux/workqueue.h>
diff --git a/net/sunrpc/rpcb_clnt.c b/net/sunrpc/rpcb_clnt.c
index 56aa018..22dadd4 100644
--- a/net/sunrpc/rpcb_clnt.c
+++ b/net/sunrpc/rpcb_clnt.c
@@ -20,6 +20,7 @@
 #include <linux/in6.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
+#include <linux/dynamic_debug_sunrpc.h>
 
 #include <linux/sunrpc/clnt.h>
 #include <linux/sunrpc/sched.h>
diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index 4c66912..96ec288 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -19,6 +19,7 @@
 #include <linux/smp_lock.h>
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
+#include <linux/dynamic_debug_sunrpc.h>
 
 #include <linux/sunrpc/clnt.h>
 
diff --git a/net/sunrpc/socklib.c b/net/sunrpc/socklib.c
index a661a3a..b04aa96 100644
--- a/net/sunrpc/socklib.c
+++ b/net/sunrpc/socklib.c
@@ -12,6 +12,7 @@
 #include <linux/types.h>
 #include <linux/pagemap.h>
 #include <linux/udp.h>
+#include <linux/dynamic_debug_sunrpc.h>
 #include <linux/sunrpc/xdr.h>
 
 
diff --git a/net/sunrpc/stats.c b/net/sunrpc/stats.c
index c6061a4..947b391 100644
--- a/net/sunrpc/stats.c
+++ b/net/sunrpc/stats.c
@@ -18,6 +18,7 @@
 #include <linux/kernel.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
+#include <linux/dynamic_debug_sunrpc.h>
 #include <linux/sunrpc/clnt.h>
 #include <linux/sunrpc/svcsock.h>
 #include <linux/sunrpc/metrics.h>
diff --git a/net/sunrpc/sunrpc_syms.c b/net/sunrpc/sunrpc_syms.c
index 843629f..57d0491 100644
--- a/net/sunrpc/sunrpc_syms.c
+++ b/net/sunrpc/sunrpc_syms.c
@@ -12,6 +12,7 @@
 #include <linux/uio.h>
 #include <linux/unistd.h>
 #include <linux/init.h>
+#include <linux/dynamic_debug_sunrpc.h>
 
 #include <linux/sunrpc/sched.h>
 #include <linux/sunrpc/clnt.h>
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 090af78..535c08f 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -19,6 +19,7 @@
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/sched.h>
+#include <linux/dynamic_debug_sunrpc.h>
 
 #include <linux/sunrpc/types.h>
 #include <linux/sunrpc/xdr.h>
diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index 332eb47..09207b4 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -18,6 +18,7 @@
 #include <linux/skbuff.h>
 #include <linux/file.h>
 #include <linux/freezer.h>
+#include <linux/dynamic_debug_sunrpc.h>
 #include <net/sock.h>
 #include <net/checksum.h>
 #include <net/ip.h>
diff --git a/net/sunrpc/svcauth.c b/net/sunrpc/svcauth.c
index 8a73cbb..bf65088 100644
--- a/net/sunrpc/svcauth.c
+++ b/net/sunrpc/svcauth.c
@@ -17,6 +17,7 @@
 #include <linux/sunrpc/svcauth.h>
 #include <linux/err.h>
 #include <linux/hash.h>
+#include <linux/dynamic_debug_sunrpc.h>
 
 #define RPCDBG_FACILITY	RPCDBG_AUTH
 
diff --git a/net/sunrpc/svcauth_unix.c b/net/sunrpc/svcauth_unix.c
index 3c64051..d5bdcaa 100644
--- a/net/sunrpc/svcauth_unix.c
+++ b/net/sunrpc/svcauth_unix.c
@@ -10,6 +10,7 @@
 #include <linux/seq_file.h>
 #include <linux/hash.h>
 #include <linux/string.h>
+#include <linux/dynamic_debug_sunrpc.h>
 #include <net/sock.h>
 
 #define RPCDBG_FACILITY	RPCDBG_AUTH
diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index c475977..0a13859 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -34,6 +34,7 @@
 #include <linux/skbuff.h>
 #include <linux/file.h>
 #include <linux/freezer.h>
+#include <linux/dynamic_debug_sunrpc.h>
 #include <net/sock.h>
 #include <net/checksum.h>
 #include <net/ip.h>
diff --git a/net/sunrpc/sysctl.c b/net/sunrpc/sysctl.c
index 0f8c439..ad26946 100644
--- a/net/sunrpc/sysctl.c
+++ b/net/sunrpc/sysctl.c
@@ -13,6 +13,7 @@
 #include <linux/fs.h>
 #include <linux/sysctl.h>
 #include <linux/module.h>
+#include <linux/dynamic_debug_sunrpc.h>
 
 #include <asm/uaccess.h>
 #include <linux/sunrpc/types.h>
diff --git a/net/sunrpc/timer.c b/net/sunrpc/timer.c
index 31becbf..08c03a3 100644
--- a/net/sunrpc/timer.c
+++ b/net/sunrpc/timer.c
@@ -18,6 +18,7 @@
 #include <linux/types.h>
 #include <linux/unistd.h>
 #include <linux/module.h>
+#include <linux/dynamic_debug_sunrpc.h>
 
 #include <linux/sunrpc/clnt.h>
 
diff --git a/net/sunrpc/xdr.c b/net/sunrpc/xdr.c
index 79a55d5..c41412d 100644
--- a/net/sunrpc/xdr.c
+++ b/net/sunrpc/xdr.c
@@ -12,6 +12,7 @@
 #include <linux/kernel.h>
 #include <linux/pagemap.h>
 #include <linux/errno.h>
+#include <linux/dynamic_debug_sunrpc.h>
 #include <linux/sunrpc/xdr.h>
 #include <linux/sunrpc/msg_prot.h>
 
diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index d5553b8..1a2039e 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -42,6 +42,7 @@
 #include <linux/interrupt.h>
 #include <linux/workqueue.h>
 #include <linux/net.h>
+#include <linux/dynamic_debug_sunrpc.h>
 
 #include <linux/sunrpc/clnt.h>
 #include <linux/sunrpc/metrics.h>
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 613daf8..fc17df0 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -34,6 +34,7 @@
 #include <linux/sunrpc/sched.h>
 #include <linux/sunrpc/xprtsock.h>
 #include <linux/file.h>
+#include <linux/dynamic_debug_sunrpc.h>
 
 #include <net/sock.h>
 #include <net/checksum.h>
