Return-Path: <linux-kernel-owner+w=401wt.eu-S933028AbXBVLso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933028AbXBVLso (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 06:48:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933034AbXBVLso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 06:48:44 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933028AbXBVLsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 06:48:43 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <45DD2B15.1030605@hitachi.com> 
References: <45DD2B15.1030605@hitachi.com>  <45DC184C.3080600@hitachi.com> <45DAC32B.4030603@hitachi.com> <45D5B483.3020502@hitachi.com> <45D5B2E3.3030607@hitachi.com> <20368.1171638335@redhat.com> <18826.1171969097@redhat.com> <8347.1172057611@redhat.com> <20070221115436.GA31332@lnx-holt.americas.sgi.com> 
To: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
Cc: Robin Holt <holt@sgi.com>, Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>,
       "Hideo AOKI@redhat" <haoki@redhat.com>
Subject: Re: [PATCH 3/4] coredump: ELF-FDPIC: enable to omit anonymous shared memory 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Thu, 22 Feb 2007 11:47:18 +0000
Message-ID: <32247.1172144838@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kawai, Hidehiro <hidehiro.kawai.ez@hitachi.com> wrote:

> Okay, the probability that the process is blocked in the proc handler seems
> to be small.  But I'm not sure if problems never occur in enterprise use.
> So I'd like to use down_write_trylock() as Robin said before. And if it
> fails to acquire the lock, it returns EBUSY immediately.
> Do you have any comments?

That's probably reasonable, but that means userspace then has to handle EBUSY.

David
