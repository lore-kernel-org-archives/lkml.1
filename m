Return-Path: <linux-kernel-owner+w=401wt.eu-S933472AbXBXKDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933472AbXBXKDH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 05:03:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933469AbXBXKDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 05:03:06 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933472AbXBXKDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 05:03:05 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <45DFB1C7.1030205@google.com> 
References: <45DFB1C7.1030205@google.com>  <45D5B2E3.3030607@hitachi.com> 
To: Markus Gutschke <markus@google.com>
Cc: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>,
       Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Robin Holt <holt@sgi.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>
Subject: Re: [PATCH 0/4] coredump: core dump masking support v3 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Sat, 24 Feb 2007 10:02:15 +0000
Message-ID: <17044.1172311335@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Markus Gutschke <markus@google.com> wrote:

> As an alternative to your kernel patch, you could achieve the same goal in
> user space, by linking my coredumper

How does it work when you can't actually get back to userspace to have
userspace do the coredump?  You still have to handle the userspace equivalents
of double/triple faults.

David
