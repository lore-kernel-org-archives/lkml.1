Return-Path: <linux-kernel-owner+w=401wt.eu-S1762946AbXERWCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762946AbXERWCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 18:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755057AbXERWCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 18:02:09 -0400
Received: from ipx20189.ipxserver.de ([80.190.249.56]:2375 "EHLO
	ipx20189.ipxserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755036AbXERWCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 18:02:08 -0400
X-Greylist: delayed 1502 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 May 2007 18:02:08 EDT
Date: Fri, 18 May 2007 23:37:01 +0200
From: Christian Leber <christian@leber.de>
To: linux-kernel@vger.kernel.org
Subject: [BUG] acpi double resume and fail
Message-ID: <20070518213701.GA810@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Accept-Language: de en
X-Location: Europe, Germany, Mannheim
X-Operating-System: Debian GNU/Linux (sid)
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

i hit a problem with suspend to ram and especially resume.
Hardware: Dell Latitude D810 (some Intel 915 with Intel Pentium M)

With 2.6.19.7 suspend to ram works reliable, but with 2.6.20-rc4
it stopped working reliable.
I still can suspend, but after the first resume it goes back to sleep
directly again, when resuming again it works.
After the second suspend it won't resume at all.

The problem is that i can't try out the kernel versions <rc4, because
rc1, rc2 and rc3 doesn't boot at all, so git-bisect also won't help.

Has somebody an idea what i could try out?

(the distribution is in this case ubuntu feisty)

Regards
Christian Leber

-- 
http://rettetdieti.vde-uni-mannheim.de/

