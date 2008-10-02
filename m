Return-Path: <linux-kernel-owner+w=401wt.eu-S1754696AbYJBQ6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbYJBQ6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 12:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbYJBQ6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 12:58:09 -0400
Received: from gw.goop.org ([64.81.55.164]:50655 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753742AbYJBQ6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 12:58:08 -0400
Message-ID: <48E4FD98.7020203@goop.org>
Date: Thu, 02 Oct 2008 09:58:00 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080919)
MIME-Version: 1.0
To: Gregor Rebel <linux@mailbarrier.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: Anybody interested in a kernel memory manager?
References: <48E46214.2090108@mailbarrier.de>
In-Reply-To: <48E46214.2090108@mailbarrier.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregor Rebel wrote:
> I'm currently writing two modules related to XEN.

What are you working on, out of curiosity?

> Both modules need to
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

The best way to get a useful response is to post the patches and see 
what happens.  There's no way to really evaluate what you're proposing 
in the abstract.

    J
