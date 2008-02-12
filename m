Return-Path: <linux-kernel-owner+w=401wt.eu-S1764711AbYBLUlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764711AbYBLUlz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 15:41:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761297AbYBLUlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 15:41:45 -0500
Received: from tac.ki.iif.hu ([193.6.222.43]:50942 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756730AbYBLUlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 15:41:44 -0500
X-Greylist: delayed 870 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Feb 2008 15:41:44 EST
From: Ferenc Wagner <wferi@niif.hu>
To: linux-kernel@vger.kernel.org
Cc: wferi@niif.hu
Subject: printk %%
Date: Tue, 12 Feb 2008 21:41:42 +0100
Message-ID: <871w7hrjp5.fsf@szonett.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Looking at http://lxr.linux.no/linux/lib/vsprintf.c#L549 (where
vsnprintf in linux/lib/vsprintf.c parses the % format specifier)
suggests that the printk format string in
http://lxr.linux.no/linux/drivers/ide/setup-pci.c#L657 is correct:

    printk(KERN_INFO "%s: not 100%% native mode: "
            "will probe irqs later\n", d->name);

Still, in my kern.log the percent sign is doubled:

    ICH4: not 100%% native mode: will probe irqs later

Why?
-- 
Regards,
Feri.

(Please Cc: me, I'm not on the list.)
