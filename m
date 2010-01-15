Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044Ab0AOS4q (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 13:56:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758029Ab0AOS4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 13:56:45 -0500
Received: from outbound-mail-158.bluehost.com ([67.222.39.38]:51673 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757620Ab0AOS4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 13:56:44 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=cSng/4SwUcqlexTbh+itglpa6YFq2TMEJOHg0wFjXLi7nrxKKoF8KDfnCP/cBEWBZv2XxkNfSFtzxZAMqPlbb1W0dzlY+RHhWlEYgOCqDf1pk7WzNpqd44kPBUfzm4ok;
Date: Fri, 15 Jan 2010 10:56:45 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 05/14] pci: add failed_list to record failed one for
 pci_bus_assign_resources
Message-ID: <20100115105645.085c5e91@jbarnes-piketon>
In-Reply-To: <1261522954-12591-6-git-send-email-yinghai@kernel.org>
References: <1261522954-12591-1-git-send-email-yinghai@kernel.org>
	<1261522954-12591-6-git-send-email-yinghai@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Dec 2009 15:02:25 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> so later we can do sth with those failed one
> 
> -v2: store start, end, flags aside. so could keep res cleared when
> assign failed. and make following assignment of its children do not
> go wild
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  drivers/pci/setup-bus.c |   66
> ++++++++++++++++++++++++++++++++++++++++++++--- 1 files changed, 62
> insertions(+), 4 deletions(-)

Bjorn's comments still stand here, this patch doesn't make any sense by
itself.  Either the failed list functions and struct def should stand
alone, or the whole thing should be rolled into the patch that actually
makes use of these functions.

-- 
Jesse Barnes, Intel Open Source Technology Center
