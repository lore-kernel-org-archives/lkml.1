Return-Path: <linux-kernel-owner+w=401wt.eu-S1755215AbYJVQ6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbYJVQ6j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 12:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbYJVQ6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 12:58:31 -0400
Received: from outbound-mail-144.bluehost.com ([67.222.38.34]:37724 "HELO
	outbound-mail-144.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751949AbYJVQ6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 12:58:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=r96C+jHAsBzVdPgfuwDzZhdU7fzwK3CUiuC2aHMxYVPeatN7KWyt6tmw+7GRSIWy7Zq0Bw8GGB+Xs6bC34ro7FXii7JVmC7lzHkBqORNXKVb9ZQoz/lP6O2OCKHxuXf3;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: eranian@gmail.com
Subject: Re: [patch 00/24] perfmon3: introduction
Date: Wed, 22 Oct 2008 09:58:22 -0700
User-Agent: KMail/1.10.1 (Linux/2.6.26.5-45.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <48f8a9a3.0437560a.656a.57c5@mx.google.com> <20081021.212502.41487120.davem@davemloft.net> <7c86c4470810220139h49269138g844194bd5db3d5c2@mail.gmail.com>
In-Reply-To: <7c86c4470810220139h49269138g844194bd5db3d5c2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810220958.23266.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 22, 2008 1:39 am stephane eranian wrote:
> As you know, I have been involved with this project for quite some time
> now. I have been through many ups and downs trying to get this merged
> upstream. So rest assured of my full determination to bring this to the
> point of success.

I've been following this at a high level since using perfmon on ia64 several 
years ago.  I have to say I'm impressed that you've put up with all the review 
and code churn (which to me often seemed arbitrary) without burning out.

Honestly I think it sucks that perfmonN isn't upstream yet supporting all the 
various architectures you've been working with.  You've obviously proven to be 
a much more responsive and end-user focused maintainer than several of the 
other fly by night profiling infrastructures we currently have in the kernel 
(the long abandoned oprofile and perfctr come to mind).

As I mentioned at KS, I think it's about time we had a single point of contact 
for profiling in the kernel, to avoid the massive functional duplication we 
have today and make sure some kind of code sharing occurs; seems to me you'd 
be a good candidate for that sort of job.

But regardless, I think it's about time this got merged.  Linus?  Andrew?

Thanks,
Jesse
