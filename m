Return-Path: <linux-kernel-owner+w=401wt.eu-S1751786AbZGaAyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786AbZGaAyd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 20:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbZGaAyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 20:54:32 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:49131 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbZGaAyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 20:54:31 -0400
Date: Thu, 30 Jul 2009 17:53:08 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@infradead.org>,
       Peng Tao <bergwolf@gmail.com>, Karel Zak <kzak@redhat.com>
Subject: [PATCH 1/2] doc/filesystems: remove smount program
Message-Id: <20090730175308.db98eb17.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt004.oracle.com [141.146.116.13]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4A724083.012A:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

mount(8) handles shared subtrees just fine, so remove the smount
program from Documentation/filesystems/sharedsubtree.txt.

Fix annoying "Lets" -> "Let's".
Insert space between '#' prompt and "mount" command.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Miklos Szeredi <miklos@szeredi.hu>
Cc: Christoph Hellwig <hch@infradead.org>
---
 Documentation/filesystems/sharedsubtree.txt |  209 ++----------------
 1 file changed, 34 insertions(+), 175 deletions(-)

--- linux-2.6.31-rc4-git5.orig/Documentation/filesystems/sharedsubtree.txt
+++ linux-2.6.31-rc4-git5/Documentation/filesystems/sharedsubtree.txt
@@ -41,14 +41,14 @@ replicas continue to be exactly same.
 
 	Here is an example:
 
-	Lets say /mnt has a mount that is shared.
+	Let's say /mnt has a mount that is shared.
 	mount --make-shared /mnt
 
-	note: mount command does not yet support the --make-shared flag.
-	I have included a small C program which does the same by executing
-	'smount /mnt shared'
+	Note: mount(8) command now supports the --make-shared flag,
+	so the sample 'smount' program is no longer needed and has been
+	removed.
 
-	#mount --bind /mnt /tmp
+	# mount --bind /mnt /tmp
 	The above command replicates the mount at /mnt to the mountpoint /tmp
 	and the contents of both the mounts remain identical.
 
@@ -58,8 +58,8 @@ replicas continue to be exactly same.
 	#ls /tmp
 	a b c
 
-	Now lets say we mount a device at /tmp/a
-	#mount /dev/sd0  /tmp/a
+	Now let's say we mount a device at /tmp/a
+	# mount /dev/sd0  /tmp/a
 
 	#ls /tmp/a
 	t1 t2 t2
@@ -80,21 +80,20 @@ replicas continue to be exactly same.
 
 	Here is an example:
 
-	Lets say /mnt has a mount which is shared.
-	#mount --make-shared /mnt
+	Let's say /mnt has a mount which is shared.
+	# mount --make-shared /mnt
 
-	Lets bind mount /mnt to /tmp
-	#mount --bind /mnt /tmp
+	Let's bind mount /mnt to /tmp
+	# mount --bind /mnt /tmp
 
 	the new mount at /tmp becomes a shared mount and it is a replica of
 	the mount at /mnt.
 
-	Now lets make the mount at /tmp; a slave of /mnt
-	#mount --make-slave /tmp
-	[or smount /tmp slave]
+	Now let's make the mount at /tmp; a slave of /mnt
+	# mount --make-slave /tmp
 
-	lets mount /dev/sd0 on /mnt/a
-	#mount /dev/sd0 /mnt/a
+	let's mount /dev/sd0 on /mnt/a
+	# mount /dev/sd0 /mnt/a
 
 	#ls /mnt/a
 	t1 t2 t3
@@ -104,9 +103,9 @@ replicas continue to be exactly same.
 
 	Note the mount event has propagated to the mount at /tmp
 
-	However lets see what happens if we mount something on the mount at /tmp
+	However let's see what happens if we mount something on the mount at /tmp
 
-	#mount /dev/sd1 /tmp/b
+	# mount /dev/sd1 /tmp/b
 
 	#ls /tmp/b
 	s1 s2 s3
@@ -124,12 +123,11 @@ replicas continue to be exactly same.
 
 2d) A unbindable mount is a unbindable private mount
 
-	lets say we have a mount at /mnt and we make is unbindable
+	let's say we have a mount at /mnt and we make is unbindable
 
-	#mount --make-unbindable /mnt
-	 [ smount /mnt  unbindable ]
+	# mount --make-unbindable /mnt
 
-	 Lets try to bind mount this mount somewhere else.
+	 Let's try to bind mount this mount somewhere else.
 	 # mount --bind /mnt /tmp
 	 mount: wrong fs type, bad option, bad superblock on /mnt,
 	        or too many mounted file systems
@@ -139,147 +137,8 @@ replicas continue to be exactly same.
 
 3) smount command
 
-	Currently the mount command is not aware of shared subtree features.
-	Work is in progress to add the support in mount ( util-linux package ).
-	Till then use the following program.
-
-	------------------------------------------------------------------------
-	//
-	//this code was developed my Miklos Szeredi <miklos@szeredi.hu>
-	//and modified by Ram Pai <linuxram@us.ibm.com>
-	// sample usage:
-	//              smount /tmp shared
-	//
-	#include <stdio.h>
-	#include <stdlib.h>
-	#include <unistd.h>
-	#include <string.h>
-	#include <sys/mount.h>
-	#include <sys/fsuid.h>
-
-	#ifndef MS_REC
-	#define MS_REC		0x4000	/* 16384: Recursive loopback */
-	#endif
-
-	#ifndef MS_SHARED
-	#define MS_SHARED		1<<20	/* Shared */
-	#endif
-
-	#ifndef MS_PRIVATE
-	#define MS_PRIVATE		1<<18	/* Private */
-	#endif
-
-	#ifndef MS_SLAVE
-	#define MS_SLAVE		1<<19	/* Slave */
-	#endif
-
-	#ifndef MS_UNBINDABLE
-	#define MS_UNBINDABLE		1<<17	/* Unbindable */
-	#endif
-
-	int main(int argc, char *argv[])
-	{
-		int type;
-		if(argc != 3) {
-			fprintf(stderr, "usage: %s dir "
-			"<rshared|rslave|rprivate|runbindable|shared|slave"
-			"|private|unbindable>\n" , argv[0]);
-			return 1;
-		}
-
-		fprintf(stdout, "%s %s %s\n", argv[0], argv[1], argv[2]);
-
-		if (strcmp(argv[2],"rshared")==0)
-			type=(MS_SHARED|MS_REC);
-		else if (strcmp(argv[2],"rslave")==0)
-			type=(MS_SLAVE|MS_REC);
-		else if (strcmp(argv[2],"rprivate")==0)
-			type=(MS_PRIVATE|MS_REC);
-		else if (strcmp(argv[2],"runbindable")==0)
-			type=(MS_UNBINDABLE|MS_REC);
-		else if (strcmp(argv[2],"shared")==0)
-			type=MS_SHARED;
-		else if (strcmp(argv[2],"slave")==0)
-			type=MS_SLAVE;
-		else if (strcmp(argv[2],"private")==0)
-			type=MS_PRIVATE;
-		else if (strcmp(argv[2],"unbindable")==0)
-			type=MS_UNBINDABLE;
-		else {
-			fprintf(stderr, "invalid operation: %s\n", argv[2]);
-			return 1;
-		}
-		setfsuid(getuid());
-
-		if(mount("", argv[1], "dontcare", type, "") == -1) {
-			perror("mount");
-			return 1;
-		}
-		return 0;
-	}
-	-----------------------------------------------------------------------
-
-	Copy the above code snippet into smount.c
-	gcc -o smount smount.c
-
-
-	(i) To mark all the mounts under /mnt as shared execute the following
-	command:
-
-	 	smount /mnt rshared
-		the corresponding syntax planned for mount command is
-		mount --make-rshared /mnt
-
-	    just to mark a mount /mnt as shared, execute the following
-	    command:
-	 	smount /mnt shared
-		the corresponding syntax planned for mount command is
-		mount --make-shared /mnt
-
-	(ii) To mark all the shared mounts under /mnt as slave execute the
-	following
-
-	     command:
-		smount /mnt rslave
-		the corresponding syntax planned for mount command is
-		mount --make-rslave /mnt
-
-	    just to mark a mount /mnt as slave, execute the following
-	    command:
-	 	smount /mnt slave
-		the corresponding syntax planned for mount command is
-		mount --make-slave /mnt
-
-	(iii) To mark all the mounts under /mnt as private execute the
-	following command:
-
-		smount /mnt rprivate
-		the corresponding syntax planned for mount command is
-		mount --make-rprivate /mnt
-
-	    just to mark a mount /mnt as private, execute the following
-	    command:
-	 	smount /mnt private
-		the corresponding syntax planned for mount command is
-		mount --make-private /mnt
-
-	      NOTE: by default all the mounts are created as private. But if
-	      you want to change some shared/slave/unbindable  mount as
-	      private at a later point in time, this command can help.
-
-	(iv) To mark all the mounts under /mnt as unbindable execute the
-	following
-
-	     command:
-		smount /mnt runbindable
-		the corresponding syntax planned for mount command is
-		mount --make-runbindable /mnt
-
-	    just to mark a mount /mnt as unbindable, execute the following
-	    command:
-	 	smount /mnt unbindable
-		the corresponding syntax planned for mount command is
-		mount --make-unbindable /mnt
+	Modern mount(8) command is aware of shared subtree features,
+	so use it instead of the 'smount' command. [source code removed]
 
 
 4) Use cases
@@ -558,7 +417,7 @@ replicas continue to be exactly same.
 	then the subtree under the unbindable mount is pruned in the new
 	location.
 
-	eg: lets say we have the following mount tree.
+	eg: let's say we have the following mount tree.
 
 		A
 	      /   \
@@ -566,7 +425,7 @@ replicas continue to be exactly same.
 	     / \ / \
 	     D E F G
 
-	     Lets say all the mount except the mount C in the tree are
+	     Let's say all the mount except the mount C in the tree are
 	     of a type other than unbindable.
 
 	     If this tree is rbound to say Z
@@ -683,13 +542,13 @@ replicas continue to be exactly same.
 	'b' on mounts that receive propagation from mount 'B' and does not have
 	sub-mounts within them are unmounted.
 
-	Example: Lets say 'B1', 'B2', 'B3' are shared mounts that propagate to
+	Example: Let's say 'B1', 'B2', 'B3' are shared mounts that propagate to
 	each other.
 
-	lets say 'A1', 'A2', 'A3' are first mounted at dentry 'b' on mount
+	let's say 'A1', 'A2', 'A3' are first mounted at dentry 'b' on mount
 	'B1', 'B2' and 'B3' respectively.
 
-	lets say 'C1', 'C2', 'C3' are next mounted at the same dentry 'b' on
+	let's say 'C1', 'C2', 'C3' are next mounted at the same dentry 'b' on
 	mount 'B1', 'B2' and 'B3' respectively.
 
 	if 'C1' is unmounted, all the mounts that are most-recently-mounted on
@@ -710,7 +569,7 @@ replicas continue to be exactly same.
 	A cloned namespace contains all the mounts as that of the parent
 	namespace.
 
-	Lets say 'A' and 'B' are the corresponding mounts in the parent and the
+	Let's say 'A' and 'B' are the corresponding mounts in the parent and the
 	child namespace.
 
 	If 'A' is shared, then 'B' is also shared and 'A' and 'B' propagate to
@@ -759,11 +618,11 @@ replicas continue to be exactly same.
 		mount --make-slave /mnt
 
 		At this point we have the first mount at /tmp and
-		its root dentry is 1. Lets call this mount 'A'
+		its root dentry is 1. Let's call this mount 'A'
 		And then we have a second mount at /tmp1 with root
-		dentry 2. Lets call this mount 'B'
+		dentry 2. Let's call this mount 'B'
 		Next we have a third mount at /mnt with root dentry
-		mnt. Lets call this mount 'C'
+		mnt. Let's call this mount 'C'
 
 		'B' is the slave of 'A' and 'C' is a slave of 'B'
 		A -> B -> C
@@ -794,7 +653,7 @@ replicas continue to be exactly same.
 
 	Q3 Why is unbindable mount needed?
 
-		Lets say we want to replicate the mount tree at multiple
+		Let's say we want to replicate the mount tree at multiple
 		locations within the same subtree.
 
 		if one rbind mounts a tree within the same subtree 'n' times
@@ -803,7 +662,7 @@ replicas continue to be exactly same.
 		mounts. Here is a example.
 
 		step 1:
-		   lets say the root tree has just two directories with
+		   let's say the root tree has just two directories with
 		   one vfsmount.
 				    root
 				   /    \
@@ -875,7 +734,7 @@ replicas continue to be exactly same.
 		Unclonable mounts come in handy here.
 
 		step 1:
-		   lets say the root tree has just two directories with
+		   let's say the root tree has just two directories with
 		   one vfsmount.
 				    root
 				   /    \



---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
