Return-Path: <linux-kernel-owner+w=401wt.eu-S932664AbZLEAP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664AbZLEAP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 19:15:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932613AbZLEAP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 19:15:56 -0500
Received: from outbound-mail-139.bluehost.com ([67.222.39.29]:50954 "HELO
	outbound-mail-139.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932611AbZLEAPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 19:15:55 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=phtokJBsO6S20e9lMvnp2nUy4UJhPabkKzhmKrDrGOmZL5JLt6FdroMWYYSbRQM9izT11BULfdKtQ4kz2WCZ9PuTg81gfsjTe8u4ve/F/yHKoqDeZY7D6+XJtJsx4VFt;
Date: Fri, 4 Dec 2009 16:15:15 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Feng, Xiaobing" <Xiaobing.Feng@windriver.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>,
       <linux-pci@vger.kernel.org>, <giancarlo.asnaghi@st.com>,
       "Wallin, Anders" <Anders.Wallin@windriver.com>,
       "D'Agostino, Raffaele" <raffaele.dagostino@windriver.com>,
       "Li, Li" <Li.Li@windriver.com>
Subject: Re: [PATCH 1/2] Uart driver for ST Microelectronics
 ConneXt(STA2X11/STA2X10).
Message-ID: <20091204161515.3e2538e3@jbarnes-piketon>
In-Reply-To: <52CF90264091A14888078A031D780F4302F89334@ism-mail03.corp.ad.wrs.com>
References: <52CF90264091A14888078A031D780F436EF0F9@ism-mail03.corp.ad.wrs.com>
	<52CF90264091A14888078A031D780F4302F89334@ism-mail03.corp.ad.wrs.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Nov 2009 04:22:31 +0100
"Feng, Xiaobing" <Xiaobing.Feng@windriver.com> wrote:

> 
> Hi
> 	The  patch add VENDOR ID and DEVICE ID for all components on
> ST Microelectronics ConneXt board. It will be required by all drivers
> of ConneXt which will submit in the future monthes.
>   
> ST Microelectronics ConneXt(STA2X11/STA2X10), a PCI express
> multifunction chip that provides Input/Output capabilities.
> 
>   	 This patch has been checked by scripts/checkpatch.pl .

I'm assuming these IDs will be used by several source files?  If so,
then yeah they belong in pci_ids.h.  Unfortunately the patch didn't
apply, can you resend a new one against my linux-next branch?

The GPIO and serial drivers can probably go in via Andrew.

-- 
Jesse Barnes, Intel Open Source Technology Center
