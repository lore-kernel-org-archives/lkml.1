Return-Path: <linux-kernel-owner+w=401wt.eu-S934933AbYBBV3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934933AbYBBV3J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 16:29:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759621AbYBBV2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 16:28:54 -0500
Received: from ns.gsystems.sk ([62.176.172.50]:56628 "EHLO www.gsystems.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756476AbYBBV2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 16:28:53 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] [RFC] 3c509: convert to isa_driver and pnp_driver v2
Date: Sat, 2 Feb 2008 22:28:57 +0100
User-Agent: KMail/1.9.7
Cc: netdev@vger.kernel.org, "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>
References: <200801312012.43447.linux@rainbow-software.org> <200802021925.36552.linux@rainbow-software.org> <84144f020802021307ja672fdfl29e54483e9f900d@mail.gmail.com>
In-Reply-To: <84144f020802021307ja672fdfl29e54483e9f900d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802022228.59527.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 February 2008 22:07:20 Pekka Enberg wrote:
> Hi,
>
> On Feb 2, 2008 8:25 PM, Ondrej Zary <linux@rainbow-software.org> wrote:
> > +//static __be16 el3_phys_addr[EL3_MAX_CARDS][3];
>
> [snip]
>
> > +//#if defined(CONFIG_MCA) || defined(CONFIG_EISA)
>
> [snip]
>
> > +//     while (el3_probe(el3_cards) == 0) {
> > +//             if (irq[el3_cards] > 1)
> > +//                     el3_root_dev->irq = irq[el3_cards];
> > +//             if (xcvr[el3_cards] >= 0)
> > +//                     el3_root_dev->if_port = xcvr[el3_cards];
> > +//             el3_cards++;
> > +//     }
>
> You might want to consider dropping these hunks...

Yes, they're going away. The last one is there just as a reminder that the irq 
and xcvr parameters should be used in the ISA code.

-- 
Ondrej Zary
