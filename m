Return-Path: <linux-kernel-owner+w=401wt.eu-S939611AbXGUBLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939611AbXGUBLI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 21:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763577AbXGUBK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 21:10:57 -0400
Received: from mout2.freenet.de ([195.4.92.92]:39116 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759486AbXGUBK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 21:10:56 -0400
X-Greylist: delayed 3751 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Jul 2007 21:10:56 EDT
From: Karsten Wiese <fzu@wemgehoertderstaat.de>
To: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
Subject: Re: where is the code for read system call?
Date: Sat, 21 Jul 2007 02:08:44 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <A3258B497F1C1441AD36A2E8B45FD62858CFA6@scsmsx412.amr.corp.intel.com>
In-Reply-To: <A3258B497F1C1441AD36A2E8B45FD62858CFA6@scsmsx412.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707210208.44698.fzu@wemgehoertderstaat.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 21. Juli 2007 schrieb Agarwal, Lomesh:
> My application reads from socket. I need to change the behavior of read
> system call for an experiment. Can someone point me to code?

fs/read_write.c: line 356
asmlinkage ssize_t sys_read(unsigned int fd, char __user * buf, size_t count)
