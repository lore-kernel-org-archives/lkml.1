Return-Path: <linux-kernel-owner+w=401wt.eu-S933287AbXDZHIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933287AbXDZHIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 03:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933297AbXDZHIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 03:08:44 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:42138
	"EHLO gwia-smtp.id2.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933287AbXDZHIo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 03:08:44 -0400
Message-Id: <46306C51.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Thu, 26 Apr 2007 08:09:37 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Haruo Tomita" <haruo.tomita@toshiba.co.jp>
Cc: <prarit@redhat.com>, "lkml" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2]  Fixed typo Intel RNG driver for2.6.21-rc7-mm1
References: <BF571719A4041A478005EF3F08EA6DF0043323E0@pcsmail03.pcs.pc.ome.toshiba.co.jp>
In-Reply-To: <BF571719A4041A478005EF3F08EA6DF0043323E0@pcsmail03.pcs.pc.ome.toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> "Tomita, Haruo" <haruo.tomita@toshiba.co.jp> 26.04.07 08:56 >>>
>> But why do you remove the printk()?
>
>I think that FWH connected to LPC of ICHx are not only Intel products.
>For example, sst... etc.
>Does rng address differ in except Intel products? 

I am not aware of non-Intel FWHs supporting the same RNG interface.

>I think that this driver is targeting Intel FWH.
>Therefore, printk() was removed.

If you're worried about people thinking their box being reported to have no
FWH when it does, then just make the message say so (i.e. add 82802 or
alike).

># Do you think that a "FWH not detected" message is noisy?

No, I think it helps understanding why there's no RNG device in the system.

Jan

