Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211Ab0BCP2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 10:28:39 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:55338 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756746Ab0BCP2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 10:28:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=M3mBk37I2gK80hAkxBimjes45DF8UfbjBt6O8hUV8FwJs15zNqZleenU0iJjKy1bEw
         4oIcv/dTBE32k2hkIHOdK+42cYcsx8+pSewu6yzfJZOmMoO1fAkje/Halg/XGSlvRjA5
         +FdriMbqSiqw+5isjpXxeZXl79Fq6IG9yHokk=
Date: Wed, 3 Feb 2010 23:31:01 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Lennart Poettering <lennart@poettering.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] exit: PR_SET_ANCHOR for marking processes as reapers
	for child processes
Message-ID: <20100203153101.GC4177@hack>
References: <20100202120457.GA19605@omega>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100202120457.GA19605@omega>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 02, 2010 at 01:04:57PM +0100, Lennart Poettering wrote:
>
>This patch adds a simple flag for each process that marks it as an
>"anchor" process for all its children and grandchildren. If a child of
>such an anchor dies all its children will not be reparented to init, but
>instead to this anchor, escaping this anchor process is not possible. A
>task with this flag set hence acts is little "sub-init".
>

This will break the applictions which using 'getppid() == 1' to check
if its real parent is dead or not...

-- 
Live like a child, think like the god.
 
