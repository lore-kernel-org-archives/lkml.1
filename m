Return-Path: <linux-kernel-owner+w=401wt.eu-S1032508AbXENL6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032508AbXENL6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 07:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966472AbXENLpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 07:45:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966463AbXENLo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 07:44:58 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Pine.LNX.4.61.0705131125270.9570@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0705131125270.9570@yvahk01.tjqt.qr> <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.22-rc1, 'nother randconfig
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Mon, 14 May 2007 12:44:47 +0100
Message-ID: <21094.1179143087@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:

> net/built-in.o: In function `rxrpc_destroy_all_calls':
> (.exit.text+0x71d): undefined reference to `rxrpc_call_states'
> make: *** [.tmp_vmlinux1] Error 1

This is the problem:

	# CONFIG_PROC_FS is not set
	CONFIG_AF_RXRPC=y

David
