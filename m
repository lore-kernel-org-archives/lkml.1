Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080AbYKJDgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbYKJDgg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 22:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbYKJDg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 22:36:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:43392 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbYKJDg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 22:36:27 -0500
Date: Sun, 9 Nov 2008 19:37:13 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: John K <trv@freemail.gr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: /proc/ksyms and /proc/kallsyms relationship?
Message-ID: <20081109193713.5f4894da@infradead.org>
In-Reply-To: <491787A0.5050901@freemail.gr>
References: <491787A0.5050901@freemail.gr>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2008 03:00:16 +0200
John K <trv@freemail.gr> wrote:

> 4. If one wants to find out what are the exported symbols from some
> module, so to know which symbols can he use in a future module, how
> can he achieve this?

you as developer can do a grep on the kernel source for
EXPORT_SYMBOL ...

and the module loader will also tell you if you use a symbol that's not
exported....

but realistically if you use the standard APIs you're not going to find
symbols that aren't exported... what kind of driver are you trying to
write?

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
