Return-Path: <linux-kernel-owner+w=401wt.eu-S1754147AbYGKER1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbYGKER1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 00:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbYGKERU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 00:17:20 -0400
Received: from wsip-68-15-230-7.om.om.cox.net ([68.15.230.7]:41036 "EHLO
	hachi.dashjr.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750853AbYGKERT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 00:17:19 -0400
X-Greylist: delayed 509 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Jul 2008 00:17:19 EDT
From: Luke -Jr <luke@dashjr.org>
Organization: -Jr Family
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: kernel_entry up front
Date: Thu, 10 Jul 2008 23:08:47 -0500
User-Agent: KMail/1.9.9
PGP-Key-Fingerprint: CE5A D56A 36CC 69FA E7D2 3558 665F C11D D53E 9583
Jabber-ID: luke@dashjr.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807102308.48706.luke@dashjr.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I need to get kernel_entry to the lowest memory region in the binary. This is 
because a platform I am porting to does not support ELF, and always begins 
execution at the first word of the firmware image. Alternatively, if there is 
a simpler way to prepend the image with a jump to the kernel_entry symbol, 
that could work as well.

Thanks,

Luke
