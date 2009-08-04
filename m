Return-Path: <linux-kernel-owner+w=401wt.eu-S932753AbZHDUkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753AbZHDUkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 16:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932726AbZHDUkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 16:40:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58472 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932725AbZHDUkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 16:40:41 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 6/6] KEYS: Do some whitespace cleanups [ver #2]
To: torvalds@osdl.org, akpm@linux-foundation.org, jmorris@namei.org
Cc: serue@us.ibm.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       David Howells <dhowells@redhat.com>, Serge Hallyn <serue@us.ibm.com>
Date: Tue, 04 Aug 2009 21:39:49 +0100
Message-ID: <20090804203949.25094.64075.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090804203923.25094.78702.stgit@warthog.procyon.org.uk>
References: <20090804203923.25094.78702.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do some whitespace cleanups in the key management code.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---

 security/keys/proc.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)


diff --git a/security/keys/proc.c b/security/keys/proc.c
index 643ecf0..e4fde23 100644
--- a/security/keys/proc.c
+++ b/security/keys/proc.c
@@ -194,11 +194,9 @@ static int proc_keys_show(struct seq_file *m, void *v)
 	/* come up with a suitable timeout value */
 	if (key->expiry == 0) {
 		memcpy(xbuf, "perm", 5);
-	}
-	else if (now.tv_sec >= key->expiry) {
+	} else if (now.tv_sec >= key->expiry) {
 		memcpy(xbuf, "expd", 5);
-	}
-	else {
+	} else {
 		timo = key->expiry - now.tv_sec;
 
 		if (timo < 60)
@@ -238,9 +236,7 @@ static int proc_keys_show(struct seq_file *m, void *v)
 	seq_putc(m, '\n');
 
 	rcu_read_unlock();
-
 	return 0;
-
 }
 
 #endif /* CONFIG_KEYS_DEBUG_PROC_KEYS */
@@ -266,6 +262,7 @@ static struct rb_node *key_user_first(struct rb_root *r)
 	struct rb_node *n = rb_first(r);
 	return __key_user_next(n);
 }
+
 /*****************************************************************************/
 /*
  * implement "/proc/key-users" to provides a list of the key users
@@ -273,7 +270,6 @@ static struct rb_node *key_user_first(struct rb_root *r)
 static int proc_key_users_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &proc_key_users_ops);
-
 }
 
 static void *proc_key_users_start(struct seq_file *p, loff_t *_pos)
@@ -290,14 +286,12 @@ static void *proc_key_users_start(struct seq_file *p, loff_t *_pos)
 	}
 
 	return _p;
-
 }
 
 static void *proc_key_users_next(struct seq_file *p, void *v, loff_t *_pos)
 {
 	(*_pos)++;
 	return key_user_next((struct rb_node *) v);
-
 }
 
 static void proc_key_users_stop(struct seq_file *p, void *v)

