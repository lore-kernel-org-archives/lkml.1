Return-Path: <linux-kernel-owner+w=401wt.eu-S1752987AbYKZAtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbYKZAtY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 19:49:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbYKZAtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 19:49:15 -0500
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:35403 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752159AbYKZAtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 19:49:14 -0500
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Nov 2008 19:49:14 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.br;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Subject:From:To:Cc:In-Reply-To:References:Content-Type:Date:Message-Id:Mime-Version:X-Mailer;
  b=0pK9t2T1jqwolFryBMoa9XA90W8izpu0cRtMekCYiv767N9zljo1vqElQgyV+v2qPtpx9UX/qH3ysywkcMzVsTT6SbAcdOD5XUhqP8nOHVn1KCwMztMjK1aou7FAROKDqjzcTnomZJCexvmjL6R3qikC8NaGJIJVC+MaafiL9vg=  ;
X-YMail-OSG: 9trP3mUVM1k5qntDNF23HNs.m7g0zKhU8Xp_s0mYR.brp3bEe.xZfXqj3Nok81rI6B_ifWrh6rSwmAO8AGsceePB30f9rAopBvDmrgQaRqBpi7bbt.BG35eoqEV8hbk5LkQ9ZxuJ5LQ_Z5DbGKCnY0u6
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [PATCH] fix similar typos to successfull, v2
From: Fernando Carrijo <fcarrijo@yahoo.com.br>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081125160524.102a2b3a.akpm@linux-foundation.org>
References: <492AE7ED.8040304@suse.de>
	 <20081125145308.8633bf4a.akpm@linux-foundation.org>
	 <1227656953.18268.13.camel@pc-fernando>
	 <20081125160524.102a2b3a.akpm@linux-foundation.org>
Content-Type: multipart/mixed; boundary="=-y1H9IubUVvmIsx82+ixC"
Date: Tue, 25 Nov 2008 22:42:56 -0200
Message-Id: <1227660176.18268.22.camel@pc-fernando>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-y1H9IubUVvmIsx82+ixC
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, 2008-11-25 at 16:05 -0800, Andrew Morton wrote:

> We should just fix those.

Just in case "we" mean "me", here goes patch. Since this is my second
post in the list, I suspect the format may not be what you expect. In
that case, I'll be more than happy to try again.

Fernando


--=-y1H9IubUVvmIsx82+ixC
Content-Disposition: attachment; filename="0001-Removal-of-unnecessary-null-statements.patch"
Content-Type: text/x-patch; name="0001-Removal-of-unnecessary-null-statements.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 1c7e713664690abd73b8ea08f63ea854549221a4 Mon Sep 17 00:00:00 2001
From: Fernando Carrijo <fcarrijo@yahoo.com.br>
Date: Tue, 25 Nov 2008 22:31:31 -0200
Subject: [PATCH] Removal of unnecessary null statements.

---
 arch/x86/kernel/cpu/cpufreq/longhaul.c |    2 +-
 arch/x86/kernel/ptrace.c               |    2 +-
 fs/ext4/mballoc.c                      |    4 ++--
 fs/namespace.c                         |    2 +-
 fs/ocfs2/alloc.c                       |    2 +-
 fs/ocfs2/file.c                        |    2 +-
 net/ipv6/route.c                       |    2 +-
 net/ipv6/sysctl_net_ipv6.c             |    2 +-
 net/sched/sch_sfq.c                    |    2 +-
 security/smack/smackfs.c               |    2 +-
 sound/soc/au1x/dbdma2.c                |    2 +-
 sound/soc/davinci/davinci-pcm.c        |    2 +-
 12 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/longhaul.c b/arch/x86/kernel/cpu/cpufreq/longhaul.c
index b046185..a4cff5d 100644
--- a/arch/x86/kernel/cpu/cpufreq/longhaul.c
+++ b/arch/x86/kernel/cpu/cpufreq/longhaul.c
@@ -982,7 +982,7 @@ static int __init longhaul_init(void)
 	case 10:
 		printk(KERN_ERR PFX "Use acpi-cpufreq driver for VIA C7\n");
 	default:
-		;;
+		;
 	}
 
 	return -ENODEV;
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 0a6d8c1..b04aa73 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -637,7 +637,7 @@ static inline unsigned long bts_get(const char *base, enum bts_field field)
 
 static inline void bts_set(char *base, enum bts_field field, unsigned long val)
 {
-	base += (bts_cfg.sizeof_field * field);;
+	base += (bts_cfg.sizeof_field * field);
 	(*(unsigned long *)base) = val;
 }
 
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 444ad99..14d0500 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2086,7 +2086,7 @@ static void *ext4_mb_seq_groups_next(struct seq_file *seq, void *v, loff_t *pos)
 	if (*pos < 0 || *pos >= sbi->s_groups_count)
 		return NULL;
 	group = *pos + 1;
-	return (void *) group;;
+	return (void *) group;
 }
 
 static int ext4_mb_seq_groups_show(struct seq_file *seq, void *v)
@@ -2300,7 +2300,7 @@ int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
 	}
 
 	INIT_LIST_HEAD(&meta_group_info[i]->bb_prealloc_list);
-	meta_group_info[i]->bb_free_root.rb_node = NULL;;
+	meta_group_info[i]->bb_free_root.rb_node = NULL;
 
 #ifdef DOUBLE_CHECK
 	{
diff --git a/fs/namespace.c b/fs/namespace.c
index 65b3dc8..b89c2c6 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1990,7 +1990,7 @@ static struct mnt_namespace *dup_mnt_ns(struct mnt_namespace *mnt_ns,
 	if (!new_ns->root) {
 		up_write(&namespace_sem);
 		kfree(new_ns);
-		return ERR_PTR(-ENOMEM);;
+		return ERR_PTR(-ENOMEM);
 	}
 	spin_lock(&vfsmount_lock);
 	list_add_tail(&new_ns->list, &new_ns->root->mnt_list);
diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 0cc2deb..0e7f3d1 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -3781,7 +3781,7 @@ static void ocfs2_split_record(struct inode *inode,
 	struct ocfs2_extent_list *left_el = NULL, *right_el, *insert_el, *el;
 	struct ocfs2_extent_rec *rec, *tmprec;
 
-	right_el = path_leaf_el(right_path);;
+	right_el = path_leaf_el(right_path);
 	if (left_path)
 		left_el = path_leaf_el(left_path);
 
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index e2570a3..7cd15c8 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1622,7 +1622,7 @@ int ocfs2_change_file_space(struct file *file, unsigned int cmd,
 			    struct ocfs2_space_resv *sr)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
 	if ((cmd == OCFS2_IOC_RESVSP || cmd == OCFS2_IOC_RESVSP64) &&
 	    !ocfs2_writes_unwritten_extents(osb))
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 89dc699..0b94309 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2715,7 +2715,7 @@ int __init ip6_route_init(void)
 		kmem_cache_create("ip6_dst_cache", sizeof(struct rt6_info), 0,
 				  SLAB_HWCACHE_ALIGN, NULL);
 	if (!ip6_dst_ops_template.kmem_cachep)
-		goto out;;
+		goto out;
 
 	ret = register_pernet_subsys(&ip6_route_net_ops);
 	if (ret)
diff --git a/net/ipv6/sysctl_net_ipv6.c b/net/ipv6/sysctl_net_ipv6.c
index 587f8f6..75c1a6a 100644
--- a/net/ipv6/sysctl_net_ipv6.c
+++ b/net/ipv6/sysctl_net_ipv6.c
@@ -128,7 +128,7 @@ static struct ctl_table_header *ip6_header;
 
 int ipv6_sysctl_register(void)
 {
-	int err = -ENOMEM;;
+	int err = -ENOMEM;
 
 	ip6_header = register_net_sysctl_rotable(net_ipv6_ctl_path, ipv6_table);
 	if (ip6_header == NULL)
diff --git a/net/sched/sch_sfq.c b/net/sched/sch_sfq.c
index fe1508e..13a7147 100644
--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -486,7 +486,7 @@ static int sfq_init(struct Qdisc *sch, struct nlattr *opt)
 	int i;
 
 	q->perturb_timer.function = sfq_perturbation;
-	q->perturb_timer.data = (unsigned long)sch;;
+	q->perturb_timer.data = (unsigned long)sch;
 	init_timer_deferrable(&q->perturb_timer);
 
 	for (i = 0; i < SFQ_HASH_DIVISOR; i++)
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index c21d8c8..a080b6d 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -531,7 +531,7 @@ static ssize_t smk_write_cipso(struct file *file, const char __user *buf,
 	if (skp == NULL)
 		goto out;
 
-	rule += SMK_LABELLEN;;
+	rule += SMK_LABELLEN;
 	ret = sscanf(rule, "%d", &maplevel);
 	if (ret != 1 || maplevel > SMACK_CIPSO_MAXLEVEL)
 		goto out;
diff --git a/sound/soc/au1x/dbdma2.c b/sound/soc/au1x/dbdma2.c
index 1466d93..8c236b1 100644
--- a/sound/soc/au1x/dbdma2.c
+++ b/sound/soc/au1x/dbdma2.c
@@ -187,7 +187,7 @@ static int au1x_pcm_dbdma_realloc(struct au1xpsc_audio_dmadata *pcd,
 					au1x_pcm_dmatx_cb, (void *)pcd);
 
 	if (!pcd->ddma_chan)
-		return -ENOMEM;;
+		return -ENOMEM;
 
 	au1xxx_dbdma_set_devwidth(pcd->ddma_chan, msbits);
 	au1xxx_dbdma_ring_alloc(pcd->ddma_chan, 2);
diff --git a/sound/soc/davinci/davinci-pcm.c b/sound/soc/davinci/davinci-pcm.c
index 76feaa6..31bb518 100644
--- a/sound/soc/davinci/davinci-pcm.c
+++ b/sound/soc/davinci/davinci-pcm.c
@@ -218,7 +218,7 @@ davinci_pcm_pointer(struct snd_pcm_substream *substream)
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
 		count = src - runtime->dma_addr;
 	else
-		count = dst - runtime->dma_addr;;
+		count = dst - runtime->dma_addr;
 
 	spin_unlock(&prtd->lock);
 
-- 
1.5.6.3


--=-y1H9IubUVvmIsx82+ixC--

