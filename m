Return-Path: <linux-kernel-owner+w=401wt.eu-S1758233AbXKTF3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233AbXKTF3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 00:29:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754479AbXKTF3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 00:29:04 -0500
Received: from ro-out-1112.google.com ([72.14.202.182]:24882 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938AbXKTF3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 00:29:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=WJ6RqY7MvDk46C8xKU9EJeyW74I8yrGKL67M3kU8QHeQI1hnnlH+U+4a05qTJQEbijostcpLdvI+mMBukRYCxiZL05r50rn4MFarhnDJzGI95hCHy8EJeV5RGGvpk1AH8R0mwGQMrClnI6uWgGe7ms82thUcNWF5JizA0s7Oliw=
Date: Tue, 20 Nov 2007 13:26:25 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Jeff Dike <jdike@addtoit.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH] Keep UML Kconfig in sync with x86
Message-ID: <20071120052625.GF2472@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20071119190224.GA7723@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071119190224.GA7723@c2.user-mode-linux.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2007 at 02:02:24PM -0500, Jeff Dike wrote:
>Fix a 2.6.24-rc3 UML build breakage introduced by commit
>1032c0ba9da5c5b53173ad2dcf8b2a2da78f8b17 - it introduces X86_32, with
>many things which UML needs depending on it.
>
>This patch adds definitions of X86_32 and RWSEM_XCHGADD_ALGORITHM to
>the UML/i386 Kconfig.
>
>Signed-off-by: Jeff Dike <jdike@linux.intel.com>

Tested-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks, Jeff. With this and that patch[1], uml building works fine. ;)

[1] http://lkml.org/lkml/2007/11/15/231

