Return-Path: <linux-kernel-owner+w=401wt.eu-S1758871AbXJED5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758871AbXJED5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 23:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbXJED51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 23:57:27 -0400
Received: from wx-out-0506.google.com ([66.249.82.227]:33140 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbXJED50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 23:57:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uOq/mUDKvjfGDm50ANDQCk+Czn87TSu5SWIFFG3GkOrdv2Vc1ERzWYyHuMwa2cXw87inUuK7fGDUr07gywsF2qPDEkFwbpMwgInYdAxp8PeRv4To4A8tfER6qkmZmHyINvVtkovs5pNH5XMlhYL+p34H/Hp7wf4nPZoIY3RBHjo=
Message-ID: <b681c62b0710042057m6942eb72t498e4f59ebd8ae3a@mail.gmail.com>
Date: Fri, 5 Oct 2007 09:27:25 +0530
From: "yogeshwar sonawane" <yogyas@gmail.com>
To: "Roland Dreier" <rdreier@cisco.com>
Subject: Re: Accessing 64-bit BARs
Cc: "Rolf Eike Beer" <eike-kernel@sf-tec.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <adasl4qdhpn.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b681c62b0710040153w5b4779fat1ccc7fa3e5775c2c@mail.gmail.com>
	 <200710041440.15464.eike-kernel@sf-tec.de> <adasl4qdhpn.fsf@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hello,
Thanks rolf & roland.

pci_iomap() is not doing something extra. only it is some kind of
abstraction for IO-mapped OR memory mapped.
I know that my BARs are MMIO, so using ioremap() & readl()/writel()
combination should be fine.

But for the problem as explained in my first mail, any
help/suggestions will be helpful.

-Yogeshwar

On 10/4/07, Roland Dreier <rdreier@cisco.com> wrote:
>  > You should use pci_iomap() to get an access pointer to the BAR. After this you
>  > can access the memory with ioread*() and iowrite*(). See "man pci_iomap(9)"
>  > if you build kernel manpages.
>
> That works fine, but ioremap() and readl()/writel() is also perfectly
> fine for regions that you know are always MMIO.
>
>  - R.
>
