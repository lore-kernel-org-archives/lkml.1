Return-Path: <linux-kernel-owner+w=401wt.eu-S1760864AbXERQgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760864AbXERQgt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 12:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbXERQgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 12:36:43 -0400
Received: from quechua.inka.de ([193.197.184.2]:52233 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957AbXERQgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 12:36:42 -0400
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [RFC] log out-of-virtual-memory events
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <464DCC52.7090403@users.sourceforge.net>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1Hp5RZ-0001CF-00@calista.eckenfels.net>
Date: Fri, 18 May 2007 18:36:41 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In article <464DCC52.7090403@users.sourceforge.net> you wrote:
> +       printk(KERN_INFO
> +              "out of virtual memory for process %d (%s): total_vm=%lu, uid=%d\n",
> +               current->pid, current->comm, total_vm, current->uid);

And align this one with the print_fatal layout:

       printk(KERN_WARNING
              "%s/%d process cannot request more virtual memory: total_vm=%lu, uid=%d\n",
               current->comm, current->pid, total_vm, current->uid);

Greetings
Bernd
