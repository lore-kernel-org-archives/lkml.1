Return-Path: <linux-kernel-owner+w=401wt.eu-S1761135AbXIKVDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761135AbXIKVDi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 17:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751108AbXIKVDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 17:03:30 -0400
Received: from mail.suse.de ([195.135.220.2]:55462 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbXIKVD3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 17:03:29 -0400
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] build system: section garbage collection for vmlinux
References: <200709112105.34301.vda.linux@googlemail.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 11 Sep 2007 23:03:28 +0200
In-Reply-To: <200709112105.34301.vda.linux@googlemail.com>
Message-ID: <p73veagykwv.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Vlasenko <vda.linux@googlemail.com> writes:
> 
>    text    data     bss     dec     hex filename
> 5159478 1005139  406784 6571401  644589 linux-2.6.23-rc4.org/vmlinux
> 5131822  996090  401439 6529351  63a147 linux-2.6.23-rc4.gc/vmlinux
> 
> In this particular case, 402 objects were discarded, saving 42 kb.

I wonder how many of those are 100% unused on all configurations? 
That could be an useful janitor task to clean up

-Andi
