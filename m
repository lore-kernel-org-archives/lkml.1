Return-Path: <linux-kernel-owner+w=401wt.eu-S1752780AbZH1WJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbZH1WJ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 18:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751513AbZH1WJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 18:09:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57273 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751581AbZH1WJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 18:09:58 -0400
Date: Fri, 28 Aug 2009 23:11:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: joe Shmoe <jsmoe3@yahoo.com>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org
Subject: Re: kernel page table mapping for >1GB <3 GB for x86 arch without
 PAE
Message-ID: <20090828231114.054596e7@lxorguk.ukuu.org.uk>
In-Reply-To: <989804.72681.qm@web45215.mail.sp1.yahoo.com>
References: <20090828205337.3677cf04@lxorguk.ukuu.org.uk>
	<989804.72681.qm@web45215.mail.sp1.yahoo.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Aug 2009 14:07:01 -0700 (PDT)
joe Shmoe <jsmoe3@yahoo.com> wrote:

> doesn't CR3 gets reloaded for process switch? If so , how does it matter if you setup page table mapping for all the available RAM instead of limiting to just 1GB

Because

- You don't switch process every syscall
- You don't switch process every interrupt

The latter is the real killer.
