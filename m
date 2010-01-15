Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041Ab0AOSyp (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 13:54:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758030Ab0AOSyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 13:54:44 -0500
Received: from outbound-mail-01.bluehost.com ([69.89.21.11]:43707 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758026Ab0AOSym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 13:54:42 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=hcEafVz4LbppCstDJ5S1xcAXyBQqgcCGhCdeb2+AAMkTXrfYF9V2OUXmv901eIcjP4qsMjQa6ICIwcALneMWWwNYLHsCItMQDwkeoGfvgZwluEVOQz2ErhbXO8c9rY+h;
Date: Fri, 15 Jan 2010 10:54:41 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 02/14] resource: add release_child_resources
Message-ID: <20100115105441.37e32faf@jbarnes-piketon>
In-Reply-To: <1261522954-12591-3-git-send-email-yinghai@kernel.org>
References: <1261522954-12591-1-git-send-email-yinghai@kernel.org>
	<1261522954-12591-3-git-send-email-yinghai@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Dec 2009 15:02:22 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> -v2: change name to release_child_resources according to Jesse
> -v3: according to Linus, move release_child_resources to resource.c
>      also need to put the lock around them all to avoid recursive
> deep. (my test case only have one level that need to be released)
> -v4: seperate to another patch
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
> ---

Applied to linux-next, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
