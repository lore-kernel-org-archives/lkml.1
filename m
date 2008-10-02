Return-Path: <linux-kernel-owner+w=401wt.eu-S1754131AbYJBJtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbYJBJtp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 05:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038AbYJBJti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 05:49:38 -0400
Received: from zertifikatstelle.de ([87.106.91.100]:43218 "EHLO
	mail.mailbarrier.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbYJBJth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 05:49:37 -0400
Message-ID: <48E4992E.6030102@mailbarrier.de>
Date: Thu, 02 Oct 2008 11:49:34 +0200
From: Gregor Rebel <linux@mailbarrier.de>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Anybody interested in a kernel memory manager?
References: <48E46214.2090108@mailbarrier.de>
In-Reply-To: <48E46214.2090108@mailbarrier.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again,

maybe the name is misleading, a better would could be kernel resource 
tracker.

--
Gregor
> Hi,
>
> I'm currently writing two modules related to XEN. Both modules need to
> acquire dynamic memory (via __get_free_pages() and kmalloc() ).
> In order to reuse some code, I wrote a third module which can provide
> simple memory-services to other modules:
> * Allocated pages and memories of each client-module gets tracked
> * When a module is about to exit, it can issue one function call to
> release all of its memories
> * Before first using the memory manager, each module has to obtain a
> unique owner id number by calling a registration function
> * by loading the memory manager with a debug argument, memory
> allocations automatically get logged into syslog facility
>
> I know, that currently each module keeps track of its memory allocations
> on its own.
>
> Is there a general interest to have such a memory manager in the kernel?
>
>
> -- 
> Gregor
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>

