Return-Path: <linux-kernel-owner+w=401wt.eu-S1760907AbYD3Omj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760907AbYD3Omj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 10:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755985AbYD3Oma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 10:42:30 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47570 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561AbYD3Om3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 10:42:29 -0400
Date: Tue, 29 Apr 2008 09:42:18 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "stephane eranian" <eranian@googlemail.com>
Cc: linux-kernel@vger.kernel.org, ia64 <linux-ia64@vger.kernel.org>,
       "Robert Richter" <robert.richter@amd.com>
Subject: Re: 2.6.25 new perfmon kernel patch + libpfm + pfmon available
Message-ID: <20080429094218.170a349c@infradead.org>
In-Reply-To: <7c86c4470804300651u5a8fc98dr56fd1834ba902a0e@mail.gmail.com>
References: <7c86c4470804291446l4693b317ha7ee2382d00e99e6@mail.gmail.com>
	<7c86c4470804291447w713934a7o2b8a5a690fc9a535@mail.gmail.com>
	<20080429080853.48c66b29@infradead.org>
	<7c86c4470804300611s7442fe11lba2b66f5a3a8ed88@mail.gmail.com>
	<20080429083334.1a019318@infradead.org>
	<7c86c4470804300651u5a8fc98dr56fd1834ba902a0e@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 15:51:39 +0200
"stephane eranian" <eranian@googlemail.com> wrote:

> If I recall, AMD said that this special initialization would
> eventually migrate into the core kernel. The pci_read() may be there
> because it was not exported by the kernel (this particular code lives
> in a kernel module).

... yet your patch adds an EXPORT_SYMBOL() just to make this specific function possible. Weird.

I find it hard to believe that there would be no code in the kernel to
read or write config space of a device you have..... :)
In fact I bet 80% of the drivers in the tree use it.

