Return-Path: <linux-kernel-owner+w=401wt.eu-S1759473AbZKKV6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759473AbZKKV6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 16:58:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759436AbZKKV6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 16:58:45 -0500
Received: from mail.gmx.net ([213.165.64.20]:37335 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759389AbZKKV6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 16:58:45 -0500
X-Authenticated: #15668376
X-Provags-ID: V01U2FsdGVkX1+2iqUcwbu2VpeT7P7+PiYvkMoqnluRxJ9bZOMGul
	B+df3xNnpgEsW8
From: Resul Cetin <Resul-Cetin@gmx.net>
To: linux-kernel@vger.kernel.org
Subject: Getting data from other process when running in kernel thread
Date: Wed, 11 Nov 2009 22:58:57 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-1-amd64; KDE/4.3.2; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200911112258.57859.Resul-Cetin@gmx.net>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I have following problem when running in a kernel thread. I know the pid of a 
program which started some data processing. After I finished with it, it 
should send the data to the user process and/or getting new data from it. This 
means that I must use copy_from_user/copy_to_user, but with specifying the 
pid/task.

Is that somehow possible? I think most of the things are done in workqueues 
and so I don't really know in which context I am.

Best regards,
	Resul Cetin
