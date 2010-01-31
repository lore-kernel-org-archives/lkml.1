Return-Path: <linux-kernel-owner+w=401wt.eu-S1753238Ab0AaWqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab0AaWqW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 17:46:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752500Ab0AaWqW
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 17:46:22 -0500
Received: from smtp13.ono.com ([62.42.230.16]:32446 "EHLO resmaa13.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752225Ab0AaWqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 17:46:21 -0500
Date: Sun, 31 Jan 2010 23:46:19 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: NFS problems in 2.6.33-rc6: Unknown error 526
Message-ID: <20100131234619.0f8460b9@werewolf.home>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.19.4; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi...

With latest kernel I get this between linux boxes with that kernel:

bran:/etc# showmount -e annwn.nfs
Export list for annwn:
/scratch/local 192.168.1.0/24,....

bran:~# mount -v -t nfs -o tcp annwn.nfs:/scratch/local /scratch/shared
mount.nfs: timeout set for Sun Jan 31 23:38:04 2010
mount.nfs: trying text-based options 'tcp,addr=192.168.1.10,vers=4,clientaddr=192.168.1.1'
mount.nfs: mount(2): Unknown error 526
mount.nfs: Unknown error 526

NFS works fine between the client and a Solaris server, and with an older
linux server.
Unfortunately, all my boxes got updated, so I can not try between
a box with latest kernel and other with previous one.

With this scenario, I blame the new kernel server code, any ideas ?

TIA

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2010.1 (Cooker) for x86_64
Linux 2.6.32.3-desktop-0.rc2.1mnb (gcc 4.4.2 ) SMP
