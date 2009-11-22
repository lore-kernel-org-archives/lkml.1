Return-Path: <linux-kernel-owner+w=401wt.eu-S1754728AbZKVMl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbZKVMl5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 07:41:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbZKVMl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 07:41:56 -0500
Received: from mail.gmx.net ([213.165.64.20]:41889 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753078AbZKVMl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 07:41:56 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18nmGI5V9gnrCX0zcj1aOpRX+RlwN+8l5Sa6RdwpX
	9P6fZHtdce3caq
Subject: Re: [bisected] pty performance problem
From: Mike Galbraith <efault@gmx.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: swan.r.l@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <20091122122942.644006fb@lxorguk.ukuu.org.uk>
References: <20091121222319.GA3905@swanrl.gmail.com>
	 <20091121232320.3262636c@lxorguk.ukuu.org.uk>
	 <20091122002748.GA6605@swanrl.gmail.com>
	 <20091122122942.644006fb@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Sun, 22 Nov 2009 13:41:59 +0100
Message-Id: <1258893719.14325.58.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.71
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-11-22 at 12:29 +0000, Alan Cox wrote:
> > While I could rewrite the communications to optionally use pipes, or
> > get the client to reprocess a log file locally, what I have does seem
> > a reasonable use of ptys.
> 
> Wouldn't argue with that. The tty layer queues the characters which then
> get processed but at the moment get processed after the next timer tick
> not when the CPU is idle. That wants changing and it strikes me as utterly
> dumb in general to be deferring work when the CPU is idle.

*blink*, up to 10 ms thumb twiddling session?

I wouldn't mind having a copy of the stripped down test proggy.

	-Mike

