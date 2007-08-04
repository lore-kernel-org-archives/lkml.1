Return-Path: <linux-kernel-owner+w=401wt.eu-S933046AbXHDSfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933046AbXHDSfK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 14:35:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765583AbXHDSdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 14:33:18 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:45415 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765577AbXHDSdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 14:33:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=RmPeVd5NFLuJczRQPw5Jo4tz9Eio+dTFc/y24pa/tJilBdoFOeRtHi/Iv7+AZ79cgHWz43xXBGR6Aniy/Wk47E1wprl8oIH5a9Cqgh6QJk3Sl8S496Ba0euMNWWpUVyWaKCpe4UFcqjsGBBbaG8uL71duPbVu4ztB5hDjSTKl0A=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH][RESEND][silly] Reduce size of the xterm-linux.xpm image by 12 bytes.
Date: Sat, 4 Aug 2007 20:31:20 +0200
User-Agent: KMail/1.9.7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200708042031.20792.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, this is a bit silly (but also a little fun) :-)

In Documentation/ we have the xterm-linux.xpm image.
Now an XPM image is more or less C code, so I thought it would 
be fun to look at it like that and put on the CodingStyle and 
space use glasses.

I made two changes, none of which change the actual image.
 1) I removed two lines that just had empty comments.
 2) I brought the 'image_name' declaration into line with how 
    we commonly write arrays and pointers.

This saves us an astonishing 12 bytes on the file size ;-)
That's a little less data for every future Linux kernel source 
user to download - that can't be bad.

Ok, ok, so it does have the drawback of being 99,999% churn and 
you could argue that it'll clutter the git history. So if you 
don't apply it I won't hate you (too much) ;-)


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/Documentation/xterm-linux.xpm b/Documentation/xterm-linux.xpm
index f469c1a..93cb180 100644
--- a/Documentation/xterm-linux.xpm
+++ b/Documentation/xterm-linux.xpm
@@ -9,10 +9,8 @@
 /**       Swiss Federal Institute of Technology                             **/
 /**       Central Computing Service                                         **/
 /*****************************************************************************/
-static char * image_name [] = {
-/**/
+static char *image_name[] = {
 "64 38 8 1",
-/**/
 " 	s mask	c none",
 ".	c gray70",
 "X	c gray85",


