Return-Path: <linux-kernel-owner+w=401wt.eu-S1754448AbZLXEJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448AbZLXEJH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 23:09:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbZLXEJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 23:09:05 -0500
Received: from mail.windriver.com ([147.11.1.11]:56801 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbZLXEJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 23:09:04 -0500
Message-ID: <4B32E95C.3030201@windriver.com>
Date: Wed, 23 Dec 2009 22:09:00 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: kgdb tree build warning
References: <20091224104812.7f2495f3.sfr@canb.auug.org.au>
In-Reply-To: <20091224104812.7f2495f3.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Dec 2009 04:09:01.0308 (UTC) FILETIME=[D2D6ABC0:01CA844E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi Jason,
>
> Today's linux-next build (x86_64_allmodconfig) produced this warning:
>
> kernel/debug/kdb/kdb_bp.c: In function 'kdb_bp':
> kernel/debug/kdb/kdb_bp.c:434: warning: the frame size of 32880 bytes is larger than 2048 bytes
>
> Introduced by commit 16f40ed7bd0ad29dcde7a05b8a07f5ba10937277 ("kdb: core
> for kgdb back end").
>
>   

Using gcc 4.3, I did not see this error.   What compiler or compiler
options did you use to get this?

I assume it means the stack space was exhausted and a casual glance at
the code did not yield anything obvious like a large array on the stack
or anything.  It is conceivable that there is an inline function that is
the source of the problem, but I would like to be able to duplicate it.

Thanks,
Jason.
