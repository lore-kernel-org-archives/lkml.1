Return-Path: <linux-kernel-owner+w=401wt.eu-S1757681AbYGPBqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757681AbYGPBqz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 21:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754697AbYGPBqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 21:46:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46769 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751067AbYGPBqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 21:46:46 -0400
Date: Tue, 15 Jul 2008 18:45:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: Jeff Garzik <jeff@garzik.org>, Frans Pop <elendil@planet.nl>,
       david@lang.hm, Marcel Holtmann <marcel@holtmann.org>,
       David Woodhouse <dwmw2@infradead.org>, arjan@infradead.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: Prosaic firmware issues
In-Reply-To: <20080716011140.GA30967@martell.zuzino.mipt.ru>
Message-ID: <alpine.LFD.1.10.0807151843240.2835@woody.linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org> <alpine.DEB.1.10.0807151503310.16109@asgard.lang.hm> <alpine.LFD.1.10.0807151631260.2867@woody.linux-foundation.org> <200807160222.40705.elendil@planet.nl> <alpine.LFD.1.10.0807151726520.2867@woody.linux-foundation.org>
 <487D441B.5010908@garzik.org> <20080716011140.GA30967@martell.zuzino.mipt.ru>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 16 Jul 2008, Alexey Dobriyan wrote:
>
> Could somebody from firmware people fix boring stuff, please:
> 
> 1) after allyesconfig build, git-status show plenty of crap:

Something like the appended, perhaps?

(I'm not going to commit it, I want some firmware person to double-check 
it).

> 2) after "make mrproper" after allyesconfig, some files aren't removed,
>    use "git-ls-files -o" to see them.

Ok, that needs some Makefile magic. git magic I can do.

		Linus

---
 firmware/.gitignore |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)
 create mode 100644 firmware/.gitignore

diff --git a/firmware/.gitignore b/firmware/.gitignore
new file mode 100644
index 0000000..9ade43a
--- /dev/null
+++ b/firmware/.gitignore
@@ -0,0 +1,2 @@
+*.gen.S
+*.fw
