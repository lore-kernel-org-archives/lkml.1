Return-Path: <linux-kernel-owner+w=401wt.eu-S1753715AbZK2ATf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbZK2ATf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 19:19:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753534AbZK2ATe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 19:19:34 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:49870 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511AbZK2ATe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 19:19:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=mkWyRSx0bZzwNJJiFxro311Q8XejAKA2uylrivUDr16GGb4SZv8wkjCpeMkHn09pSX
         PLVx2aOxOgOnI20UjyCYOcWKCZTOw9HYGkTAIHWx4M3Q55K4mE8DybVHo4Gd4lVVD+NG
         sF0kXpgS8g1WmVjf7INjZ2gUYucFJZNFERW7A=
MIME-Version: 1.0
Date: Sun, 29 Nov 2009 08:19:40 +0800
Message-ID: <b3657a100911281619v4d779bcdxb158b5e117c366af@mail.gmail.com>
Subject: [PATCH]a.out.h: Fix the format error.
From: liu weni <qingshenlwy@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------
rm the symbol of ^L in the include/linux/a.out.h.
------
Signed-off-by: Liuwenyi<qingshenlwy@gmail.com>
Cc: linux-kernel@vger.kernel.org
------
diff --git a/include/linux/a.out.h b/include/linux/a.out.h
index e86dfca..7c41cbd 100644
--- a/include/linux/a.out.h
+++ b/include/linux/a.out.h
@@ -162,7 +162,7 @@ enum machine_type {
 #if !defined (N_BSSADDR)
 #define N_BSSADDR(x) (N_DATADDR(x) + (x).a_data)
 #endif
-
+
 #if !defined (N_NLIST_DECLARED)
 struct nlist {
   union {
@@ -235,7 +235,7 @@ struct nlist {

 /* This is output from LD.  */
 #define N_SETV	0x1C		/* Pointer to set vector in data area.  */
-
+
 #if !defined (N_RELOCATION_INFO_DECLARED)
 /* This structure describes a single relocation to be performed.
    The text-relocation section of the file is a vector of these structures,
