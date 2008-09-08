Return-Path: <linux-kernel-owner+w=401wt.eu-S1753971AbYIHQy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbYIHQy7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 12:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbYIHQyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 12:54:51 -0400
Received: from gw.goop.org ([64.81.55.164]:33933 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225AbYIHQyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 12:54:51 -0400
Message-ID: <48C558D9.9030006@goop.org>
Date: Mon, 08 Sep 2008 09:54:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Rambaldi <rambaldi@xs4all.nl>
CC: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.27-rc5 xen balloon driver warnings
References: <48C0F09C.1000101@xs4all.nl> <48C457DC.9050904@goop.org> <48C546B2.50108@xs4all.nl>
In-Reply-To: <48C546B2.50108@xs4all.nl>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rambaldi wrote:
> I used the complete patch, I had some compile warnings.

Well, the compile warning are bad news.  Just use the first hunk.

Ingo, could you send this up to Linus?  It's a subset of a patch you've
already got in your tree.

Thanks,
    J

Subject: xen-balloon: fix balloon sysfs name

Set the class so it doesn't clash with the normal memory class.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
===================================================================
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -60,7 +60,7 @@
 
 #define PAGES2KB(_p) ((_p)<<(PAGE_SHIFT-10))
 
-#define BALLOON_CLASS_NAME "memory"
+#define BALLOON_CLASS_NAME "xen_memory"
 
 struct balloon_stats {
 	/* We aim for 'current allocation' == 'target allocation'. */

