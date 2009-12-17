Return-Path: <linux-kernel-owner+w=401wt.eu-S1765367AbZLQVQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765367AbZLQVQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 16:16:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765268AbZLQVQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 16:16:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43061 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765320AbZLQVQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 16:16:11 -0500
Date: Thu, 17 Dec 2009 13:16:04 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SYSCTL: Fix sysctl breakage on systems with older
 glibc
In-Reply-To: <m1iqc5zc4i.fsf@fess.ebiederm.org>
Message-ID: <alpine.LFD.2.00.0912171315080.15740@localhost.localdomain>
References: <20091216112844.GA31705@basil.fritz.box> <m16385abat.fsf@fess.ebiederm.org> <20091217164614.GI9804@basil.fritz.box> <m1iqc5zc4i.fsf@fess.ebiederm.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 17 Dec 2009, Eric W. Biederman wrote:
> 
> As for glibc.  The usage in glibc before glibc 2.5 does not count as a
> user space application that cares.  You can return any string or
> -ENOSYS and glibc works fine.

Annoying and pointless messages that flood your terminals etc is not 
"fine".

Backwards compatibility is more than "technically it still works". It's 
something almost sacred.

		Linus
