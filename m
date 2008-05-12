Return-Path: <linux-kernel-owner+w=401wt.eu-S1759165AbYELTd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759165AbYELTd5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 15:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbYELTds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 15:33:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43257 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbYELTds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 15:33:48 -0400
Date: Mon, 12 May 2008 15:33:37 -0400
From: Rik van Riel <riel@redhat.com>
To: "Felipe Balbi" <felipebalbi@users.sourceforge.net>
Cc: "Kernel development list" <linux-kernel@vger.kernel.org>
Subject: Re: ReiserFS or USB ??
Message-ID: <20080512153337.4caaafb2@cuia.bos.redhat.com>
In-Reply-To: <31e679430805120707w41dddb5h53b1ff00d2cc9819@mail.gmail.com>
References: <31e679430805120707w41dddb5h53b1ff00d2cc9819@mail.gmail.com>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2008 17:07:12 +0300
"Felipe Balbi" <felipebalbi@users.sourceforge.net> wrote:

> Hi all,
> 
> I'm having some troubles with my external harddrive formated with reiserfs...
> 
> After using for some time, it just disconnects and dmesg shows me this:
> 
> [276439.361676] printk: 1917173 messages suppressed.
> [276439.361684] Buffer I/O error on device sdd1, logical block 74823373
> [276444.306477] printk: 1923272 messages suppressed.
> [276444.306485] Buffer I/O error on device sdd1, logical block 74823373
> 
> Several times.
> Would this be usb trouble on reiserfs trouble ? (It looks to me usb issues).

Looks like the disk has a bad sector.

If it was a reiserfs problem, the kernel would be printing something
along the lines of "attempt to access beyond end of device".

-- 
All Rights Reversed
