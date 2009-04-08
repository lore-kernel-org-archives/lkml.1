Return-Path: <linux-kernel-owner+w=401wt.eu-S1764854AbZDHLu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764854AbZDHLu4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932293AbZDHL2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:28:45 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:48868 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764663AbZDHL1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:27:37 -0400
X-Sasl-enc: ulUBRdshAxnPZavfrMs2Sl27l4qzEGmuXCZIkssSQ8WH 1239190056
From: Jack Stone <jwjstone@fastmail.fm>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, kernel-janitors@vger.kernel.org,
       Jack Stone <jwjstone@fastmail.fm>
Subject: [PATCH 35/56] ntfs: Remove void casts
Date: Wed,  8 Apr 2009 12:22:07 +0100
Message-Id: <1239189748-11703-36-git-send-email-jwjstone@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1239189748-11703-35-git-send-email-jwjstone@fastmail.fm>
References: <>
 <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-5-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-6-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-7-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-8-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-9-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-10-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-11-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-12-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-13-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-14-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-15-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-16-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-17-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-18-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-19-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-20-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-21-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-22-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-23-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-24-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-25-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-26-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-27-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-28-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-29-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-30-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-31-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-32-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-33-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-34-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-35-git-send-email-jwjstone@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove uneeded void casts

Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
---
 fs/ntfs/compress.c |    2 +-
 fs/ntfs/dir.c      |    8 ++++----
 fs/ntfs/index.c    |    2 +-
 fs/ntfs/logfile.c  |    2 +-
 fs/ntfs/mft.c      |    4 ++--
 fs/ntfs/super.c    |    8 ++++----
 fs/ntfs/usnjrnl.c  |    2 +-
 7 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/ntfs/compress.c b/fs/ntfs/compress.c
index 9669541..12297ee 100644
--- a/fs/ntfs/compress.c
+++ b/fs/ntfs/compress.c
@@ -280,7 +280,7 @@ return_error:
 	}
 
 	/* We have a valid destination page. Setup the destination pointers. */
-	dp_addr = (u8*)page_address(dp) + do_sb_start;
+	dp_addr = page_address(dp) + do_sb_start;
 
 	/* Now, we are ready to process the current sub-block (sb). */
 	if (!(le16_to_cpup((le16*)cb) & NTFS_SB_IS_COMPRESSED)) {
diff --git a/fs/ntfs/dir.c b/fs/ntfs/dir.c
index 5a9e344..c373301 100644
--- a/fs/ntfs/dir.c
+++ b/fs/ntfs/dir.c
@@ -326,7 +326,7 @@ descend_into_child_node:
 		goto err_out;
 	}
 	lock_page(page);
-	kaddr = (u8*)page_address(page);
+	kaddr = page_address(page);
 fast_descend_into_child_node:
 	/* Get to the index allocation block. */
 	ia = (INDEX_ALLOCATION*)(kaddr + ((vcn <<
@@ -804,7 +804,7 @@ descend_into_child_node:
 		goto err_out;
 	}
 	lock_page(page);
-	kaddr = (u8*)page_address(page);
+	kaddr = page_address(page);
 fast_descend_into_child_node:
 	/* Get to the index allocation block. */
 	ia = (INDEX_ALLOCATION*)(kaddr + ((vcn <<
@@ -1279,7 +1279,7 @@ get_next_bmp_page:
 		bmp_page = NULL;
 		goto iput_err_out;
 	}
-	bmp = (u8*)page_address(bmp_page);
+	bmp = page_address(bmp_page);
 	/* Find next index block in use. */
 	while (!(bmp[cur_bmp_pos >> 3] & (1 << (cur_bmp_pos & 7)))) {
 find_next_index_buffer:
@@ -1322,7 +1322,7 @@ find_next_index_buffer:
 			goto err_out;
 		}
 		lock_page(ia_page);
-		kaddr = (u8*)page_address(ia_page);
+		kaddr = page_address(ia_page);
 	}
 	/* Get the current index buffer. */
 	ia = (INDEX_ALLOCATION*)(kaddr + (ia_pos & ~PAGE_CACHE_MASK &
diff --git a/fs/ntfs/index.c b/fs/ntfs/index.c
index 2194eff..16a8b2e 100644
--- a/fs/ntfs/index.c
+++ b/fs/ntfs/index.c
@@ -282,7 +282,7 @@ descend_into_child_node:
 		goto err_out;
 	}
 	lock_page(page);
-	kaddr = (u8*)page_address(page);
+	kaddr = page_address(page);
 fast_descend_into_child_node:
 	/* Get to the index allocation block. */
 	ia = (INDEX_ALLOCATION*)(kaddr + ((vcn <<
diff --git a/fs/ntfs/logfile.c b/fs/ntfs/logfile.c
index d7932e9..b6be7c4 100644
--- a/fs/ntfs/logfile.c
+++ b/fs/ntfs/logfile.c
@@ -549,7 +549,7 @@ bool ntfs_check_logfile(struct inode *log_vi, RESTART_PAGE_HEADER **rp)
 				goto err_out;
 			}
 		}
-		kaddr = (u8*)page_address(page) + (pos & ~PAGE_CACHE_MASK);
+		kaddr = page_address(page) + (pos & ~PAGE_CACHE_MASK);
 		/*
 		 * A non-empty block means the logfile is not empty while an
 		 * empty block after a non-empty block has been encountered
diff --git a/fs/ntfs/mft.c b/fs/ntfs/mft.c
index 23bf684..552f91b 100644
--- a/fs/ntfs/mft.c
+++ b/fs/ntfs/mft.c
@@ -1196,7 +1196,7 @@ static int ntfs_mft_bitmap_find_and_alloc_free_rec_nolock(ntfs_volume *vol,
 						"bitmap, aborting.");
 				return PTR_ERR(page);
 			}
-			buf = (u8*)page_address(page) + page_ofs;
+			buf = page_address(page) + page_ofs;
 			bit = data_pos & 7;
 			data_pos &= ~7ull;
 			ntfs_debug("Before inner for loop: size 0x%x, "
@@ -1334,7 +1334,7 @@ static int ntfs_mft_bitmap_extend_allocation_nolock(ntfs_volume *vol)
 		ntfs_error(vol->sb, "Failed to read from lcn bitmap.");
 		return PTR_ERR(page);
 	}
-	b = (u8*)page_address(page) + (ll & ~PAGE_CACHE_MASK);
+	b = page_address(page) + (ll & ~PAGE_CACHE_MASK);
 	tb = 1 << (lcn & 7ull);
 	down_write(&vol->lcnbmp_lock);
 	if (*b != 0xff && !(*b & tb)) {
diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index f76951d..d05bccf 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -1295,7 +1295,7 @@ static int check_windows_hibernation_status(ntfs_volume *vol)
 		ret = PTR_ERR(page);
 		goto iput_out;
 	}
-	kaddr = (u32*)page_address(page);
+	kaddr = page_address(page);
 	if (*(le32*)kaddr == cpu_to_le32(0x72626968)/*'hibr'*/) {
 		ntfs_debug("Magic \"hibr\" found in hiberfil.sys.  Windows is "
 				"hibernated on the volume.  This is the "
@@ -1515,7 +1515,7 @@ not_enabled:
 				"attribute.");
 		return false;
 	}
-	uh = (USN_HEADER*)page_address(page);
+	uh = page_address(page);
 	/* Sanity check the $Max. */
 	if (unlikely(sle64_to_cpu(uh->allocation_delta) >
 			sle64_to_cpu(uh->maximum_size))) {
@@ -2501,7 +2501,7 @@ static s64 get_nr_free_clusters(ntfs_volume *vol)
 			nr_free -= PAGE_CACHE_SIZE * 8;
 			continue;
 		}
-		kaddr = (u32*)kmap_atomic(page, KM_USER0);
+		kaddr = kmap_atomic(page, KM_USER0);
 		/*
 		 * For each 4 bytes, subtract the number of set bits. If this
 		 * is the last page and it is partial we don't really care as
@@ -2572,7 +2572,7 @@ static unsigned long __get_nr_free_mft_records(ntfs_volume *vol,
 			nr_free -= PAGE_CACHE_SIZE * 8;
 			continue;
 		}
-		kaddr = (u32*)kmap_atomic(page, KM_USER0);
+		kaddr = kmap_atomic(page, KM_USER0);
 		/*
 		 * For each 4 bytes, subtract the number of set bits. If this
 		 * is the last page and it is partial we don't really care as
diff --git a/fs/ntfs/usnjrnl.c b/fs/ntfs/usnjrnl.c
index b2bc0d5..5c8fdd7 100644
--- a/fs/ntfs/usnjrnl.c
+++ b/fs/ntfs/usnjrnl.c
@@ -58,7 +58,7 @@ bool ntfs_stamp_usnjrnl(ntfs_volume *vol)
 					"$UsnJrnl/$DATA/$Max attribute.");
 			return false;
 		}
-		uh = (USN_HEADER*)page_address(page);
+		uh = page_address(page);
 		stamp = get_current_ntfs_time();
 		ntfs_debug("Stamping transaction log ($UsnJrnl): old "
 				"journal_id 0x%llx, old lowest_valid_usn "
-- 
1.5.4.3

