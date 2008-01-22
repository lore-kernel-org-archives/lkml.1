Return-Path: <linux-kernel-owner+w=401wt.eu-S1753159AbYAVTiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159AbYAVTiu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 14:38:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbYAVTij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 14:38:39 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:49754 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbYAVTii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 14:38:38 -0500
Date: Tue, 22 Jan 2008 20:38:36 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] OSS: constify function pointer tables
Message-ID: <Pine.LNX.4.64.0801222037450.5722@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 sound/oss/i810_audio.c    |    4 ++--
 sound/oss/swarm_cs4297a.c |    4 ++--
 sound/oss/trident.c       |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/oss/i810_audio.c b/sound/oss/i810_audio.c
index f5e31f1..5169025 100644
--- a/sound/oss/i810_audio.c
+++ b/sound/oss/i810_audio.c
@@ -2684,7 +2684,7 @@ static int i810_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static /*const*/ struct file_operations i810_audio_fops = {
+static const struct file_operations i810_audio_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.read		= i810_read,
@@ -2829,7 +2829,7 @@ static int i810_ioctl_mixdev(struct inode *inode, struct file *file, unsigned in
 	return codec->mixer_ioctl(codec, cmd, arg);
 }
 
-static /*const*/ struct file_operations i810_mixer_fops = {
+static const struct file_operations i810_mixer_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.ioctl		= i810_ioctl_mixdev,
diff --git a/sound/oss/swarm_cs4297a.c b/sound/oss/swarm_cs4297a.c
index a8057f2..044453a 100644
--- a/sound/oss/swarm_cs4297a.c
+++ b/sound/oss/swarm_cs4297a.c
@@ -1580,7 +1580,7 @@ static int cs4297a_ioctl_mixdev(struct inode *inode, struct file *file,
 // ******************************************************************************************
 //   Mixer file operations struct.
 // ******************************************************************************************
-static /*const */ struct file_operations cs4297a_mixer_fops = {
+static const struct file_operations cs4297a_mixer_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.ioctl		= cs4297a_ioctl_mixdev,
@@ -2491,7 +2491,7 @@ static int cs4297a_open(struct inode *inode, struct file *file)
 // ******************************************************************************************
 //   Wave (audio) file operations struct.
 // ******************************************************************************************
-static /*const */ struct file_operations cs4297a_audio_fops = {
+static const struct file_operations cs4297a_audio_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.read		= cs4297a_read,
diff --git a/sound/oss/trident.c b/sound/oss/trident.c
index 96adc47..9ce1b63 100644
--- a/sound/oss/trident.c
+++ b/sound/oss/trident.c
@@ -2878,7 +2878,7 @@ trident_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static /*const */ struct file_operations trident_audio_fops = {
+static const struct file_operations trident_audio_fops = {
 	.owner = THIS_MODULE,
 	.llseek = no_llseek,
 	.read = trident_read,
@@ -4104,7 +4104,7 @@ trident_ioctl_mixdev(struct inode *inode, struct file *file, unsigned int cmd,
 	return codec->mixer_ioctl(codec, cmd, arg);
 }
 
-static /*const */ struct file_operations trident_mixer_fops = {
+static const struct file_operations trident_mixer_fops = {
 	.owner = THIS_MODULE,
 	.llseek = no_llseek,
 	.ioctl = trident_ioctl_mixdev,
-- 
1.5.3.4

