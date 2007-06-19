Return-Path: <linux-kernel-owner+w=401wt.eu-S1753415AbXFSN4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbXFSN4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 09:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751438AbXFSN4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 09:56:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55664 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbXFSN4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 09:56:33 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH] console UTF-8 fixes
To: Egmont Koblinger <egmont@uhulinux.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Behdad Esfahbod <behdad@behdad.org>, linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Tue, 19 Jun 2007 15:54:52 +0200
References: <8aT6Q-3iM-17@gated-at.bofh.it> <8xLa7-25v-5@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1I0eAW-0000nC-5a@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/5i/GSyEyJS5pMecahng4hbVybMXTzigDTJ42
 ou/JD+q6X02Ked2YGHOnJ2Di3OGd9RvPki3s0itWLzlrWYCABG
 F1xPiZQoW6Da96wWvhIJQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Egmont Koblinger <egmont@uhulinux.hu> wrote:

> 2. My patch introduced "question mark with inverted color attributes" as a
>    last resort fallback glyph. Though it perfectly works on VGA console, on
>    framebuffer you may end up with question marks that are highlighed but
>    shouldn't be, and normal characters that are accidentally highlighed.
>    This is caused by missing FLUSHes when changing the color attribute.

Does the FLUSH DTRT by design, or does it just shrink and hide the original
race? And why wasn't VGA affected, too?
-- 
Backups? We doan NEED no steenking baX%^~,VbKx NO CARRIER 

Friﬂ, Spammer: fc6TtrpBa@6e.7eggert.dyndns.org
 hKipagwey2@mhl7jy.7eggert.dyndns.org B@d.7eggert.dyndns.org
