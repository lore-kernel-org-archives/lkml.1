Return-Path: <linux-kernel-owner+w=401wt.eu-S1762225AbZARG3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762225AbZARG3s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 01:29:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754707AbZARG3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 01:29:39 -0500
Received: from piosf0.pit.physik.uni-tuebingen.de ([134.2.73.231]:53120 "EHLO
	piosf0.pit.physik.uni-tuebingen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753361AbZARG3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 01:29:38 -0500
X-Greylist: delayed 1241 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Jan 2009 01:29:38 EST
Message-ID: <4972C77B.1070800@uni-tuebingen.de>
Date: Sun, 18 Jan 2009 07:08:59 +0100
From: Simon W Bock <sbock@uni-tuebingen.de>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: KALLSYMS always enabled in 'make gconfig' on PS3 kernel
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
this seems to be the most appropriate place to report it...

I try to compile a kernel on and for the PS3 using Geoff Levand's
sources
http://git.kernel.org/?p=linux/kernel/git/geoff/ps3-linux.git;a=summary
and did a 'make ps3_defconfig' before doing 'make gconfig'.
Now I'd care much more for 300k less in kernel size than for full
symbols in the OOPS, so I would like to deselect KALLSYMS and
KALLSYMS_ALL. The latter is even suggested to disable in the help text.
But whatever I do, those two are always selected. Even when I deselect
them using vi, the next time I do a 'make gconfig' on the config-file
they are on again.

Is this done for some special reason? Or can they be turned off?
Thank you,
	Simon

