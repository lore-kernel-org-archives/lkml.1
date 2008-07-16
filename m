Return-Path: <linux-kernel-owner+w=401wt.eu-S1759397AbYGPPrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759397AbYGPPrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 11:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755424AbYGPPrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 11:47:43 -0400
Received: from outbound-mail-120.bluehost.com ([69.89.18.6]:36037 "HELO
	outbound-mail-120.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753351AbYGPPrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 11:47:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User:DomainKey-Status;
	b=bJ4oF3jWnd6Lm0J/MmmkE0+vnT1BVP6HAHt08lMYkkVudSAqiTjkq576913v44FdIAqZBuz63qBkUJ2P2kN81Cc7ZIiqxQBzsoOBksQmaug89GblQ68E731EBty1kmpO;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: tom.leiming@gmail.com
Subject: Re: [PATCH/RESEND] PCI:pciehp:remove unnecessary volatile in struct controller
Date: Wed, 16 Jul 2008 08:47:37 -0700
User-Agent: KMail/1.9.9
Cc: kristen.c.accardi@intel.com, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <1216220070-4246-1-git-send-email-tom.leiming@gmail.com>
In-Reply-To: <1216220070-4246-1-git-send-email-tom.leiming@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807160847.37579.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 16, 2008 7:54 am tom.leiming@gmail.com wrote:
> From: Ming Lei <tom.leiming@gmail.com>
>
> Proper memory barriers have been added to order accesses
> to ->cmd_busy, so volatile declaration for cmd_busy can
> be removed.
>
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> ---
>  drivers/pci/hotplug/pciehp.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/pci/hotplug/pciehp.h b/drivers/pci/hotplug/pciehp.h
> index 79c9dda..5e2becd 100644
> --- a/drivers/pci/hotplug/pciehp.h
> +++ b/drivers/pci/hotplug/pciehp.h
> @@ -96,7 +96,7 @@ struct controller {
>  	u32 slot_cap;
>  	u8 cap_base;
>  	struct timer_list poll_timer;
> -	volatile int cmd_busy;
> +	int cmd_busy;
>  	unsigned int no_cmd_complete:1;
>  };

Yeah I saw the first one, just hadn't had a chance to reply/apply yet.  I just 
applied it to my linux-next branch and pushed.

Jesse
