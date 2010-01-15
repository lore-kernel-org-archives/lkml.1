Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073Ab0AOTTr (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 14:19:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757852Ab0AOTTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 14:19:45 -0500
Received: from outbound-mail-01.bluehost.com ([69.89.21.11]:40842 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752025Ab0AOTTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 14:19:44 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=bWSmF1tNx/75/gWOfXRUep2CSEskB/Scb43kC3qQaZwdsGA88vIi2u8gIZZoh+Ugneu2nbAz11qssMv+bHw0uku7v1T6sBsj67TE8exhntlivhd1PrzhbJCDQvwiDGPa;
Date: Fri, 15 Jan 2010 11:19:44 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 06/14] pci: reject mmio range start from 0 on pci_bridge
 read
Message-ID: <20100115111944.00001c2b@jbarnes-piketon>
In-Reply-To: <1261522954-12591-7-git-send-email-yinghai@kernel.org>
References: <1261522954-12591-1-git-send-email-yinghai@kernel.org>
	<1261522954-12591-7-git-send-email-yinghai@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Dec 2009 15:02:26 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> that is wrong.
> 
> exposed by that patch that doesn's shrink pci bridge res.
> 
> -v2: change to "bar reading" to "reg reading"
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---

Is this really necessary?  Won't we conflict with the reserved zero
page anyway?

-- 
Jesse Barnes, Intel Open Source Technology Center
