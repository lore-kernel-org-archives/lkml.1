Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab0BHTYM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 14:24:12 -0500
Received: from outbound-mail-158.bluehost.com ([67.222.39.38]:46791 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753506Ab0BHTYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 14:24:09 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=P284S4Hp3OqeeAMSgjUDHhDjwiIykbD/RUqe1OudFuwJ5HuHdxrXowN4tLlmCHgPnuvJUMqjp/dTzXNHVfPbNvsq9lI6y0aGADXV5pZHsa5HKcKOw/QxfyIqdqGVcLAe;
Date: Mon, 8 Feb 2010 11:22:57 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 1/9] pci: add pci_bridge_release_resources and
 pci_bus_release__bridge_resources
Message-ID: <20100208112257.1cd54302@jbarnes-piketon>
In-Reply-To: <1264150948-9052-2-git-send-email-yinghai@kernel.org>
References: <1264150948-9052-1-git-send-email-yinghai@kernel.org>
	<1264150948-9052-2-git-send-email-yinghai@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jan 2010 01:02:20 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> so later we could use it to release small resource before pci assign
> unassign res
> 
> -v2: change name to release_child_resources according to Jesse
> -v3: according to Linus, move release_child_resources to resource.c
>      also need to put the lock around them all to avoid recursive
> deep. (my test case only have one level that need to be released)
> -v4: seperate release_child_resources to another patch
>      according to Bjorn, change hard code 3 to PCI_BRIDGE_RESOURCE_END
> -v5: remove unused in the name, and also use enum for release type
> according to Jesse
> -v6: use pci_is_root_bus instead according to Alex.
> -v7: remove the switch case in pci_bus_release_resources accord to
> Alex -v8: change some comments and style according to Alex again
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Reviewed-by: Alex Chiang <achiang@hp.com>
> ---

Applied this series finally, thanks Yinghai for all your work
responding to the feedback.  Let's hope it doesn't break too many
things in 2.6.34!

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
