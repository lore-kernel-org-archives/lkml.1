Return-Path: <linux-kernel-owner+w=401wt.eu-S964800AbXHLWW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964800AbXHLWW3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 18:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765221AbXHLWWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 18:22:20 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:46798 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764671AbXHLWWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 18:22:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Pq1ZGfheShHGDiVhOJ1iYRtgCxgcbi6Fm734VYWp7sR6xg7dNjvEYS5ix5ZFcfFY5/Fbr0NAHAQz+5SgMOPrHtZQ4PfkvyK/liVIG4099e4J1WpeTE66RLBvp3u+kXNDSznkNQBlA2HlKr06RaZufm5X8yAdzbNJi/4EUMRnh0E=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/6][RESEND] Reduce size of the xterm-linux.xpm image by 12 bytes.
Date: Mon, 13 Aug 2007 00:19:53 +0200
User-Agent: KMail/1.9.7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
References: <200708130016.11281.jesper.juhl@gmail.com>
In-Reply-To: <200708130016.11281.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708130019.53565.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(previously send on 04-Aug-2007 20:31)

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


