Return-Path: <linux-kernel-owner+w=401wt.eu-S1752987AbXCaND7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbXCaND7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 09:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbXCaND7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 09:03:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927AbXCaND6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 09:03:58 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070330091028.cf884d4c.akpm@linux-foundation.org> 
References: <20070330091028.cf884d4c.akpm@linux-foundation.org>  <20070329104936.GC5138@ucw.cz> <45E7AAFA.4070402@hitachi.com> <45E7AC6F.8080704@hitachi.com> <20070302093419.GA2001@elf.ucw.cz> <4607C47B.2030909@hitachi.com> <11911.1175195819@redhat.com> <20070329141715.71a6abae.akpm@linux-foundation.org> <460CE683.700@hitachi.com> 
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>,
       Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Robin Holt <holt@sgi.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>, Hideo AOKI <haoki@redhat.com>
Subject: Re: [PATCH 1/4] coredump: add an interface to control the core dump routine 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Sat, 31 Mar 2007 14:03:25 +0100
Message-ID: <3014.1175346205@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> Yes, I agree - I don't think we presently have a way of avoiding having
> to send all of that uninteresting data down the pipe.

Have the kernel fork and exec a debug program "just in time" with the dying
process ptrace-attached in advance.  That program could then use ptrace() or
whatever to do the coredump.  I think Windows does something like that.

David
