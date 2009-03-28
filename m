Return-Path: <linux-kernel-owner+w=401wt.eu-S1755928AbZC1T1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928AbZC1T1M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 15:27:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753508AbZC1T06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 15:26:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53189 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753794AbZC1T05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 15:26:57 -0400
Date: Sat, 28 Mar 2009 12:22:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Arne de Bruijn <kernelbt@arbruijn.dds.nl>
Subject: Re: [PATCH] Fix suid_dumpable and lease-break-time sysctls
Message-Id: <20090328122254.58f6becb.akpm@linux-foundation.org>
In-Reply-To: <20090327133138.GJ8014@parisc-linux.org>
References: <20090327133138.GJ8014@parisc-linux.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Mar 2009 07:31:39 -0600 Matthew Wilcox <matthew@wil.cx> wrote:

> Arne de Bruijn points out in Bugzilla 12953 that commit
> 76fdbb25f963de5dc1e308325f0578a2f92b1c2d mistakenly limits
> lease-break-time instead of suid_dumpable.
> 
> Signed-off-by: Matthew Wilcox <matthew@wil.cx>

It would be nice to include the

Reported-by: Arne de Bruijn <kernelbt@arbruijn.dds.nl>

And to cc the reporter, please.

Also, please include the bugzilla URL
(http://bugzilla.kernel.org/show_bug.cgi?id=12953) in the changelog. 
Sometimes people will go through the commit logs closing off bugzilla
reports for us, and this makes their task simpler.

