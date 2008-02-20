Return-Path: <linux-kernel-owner+w=401wt.eu-S1762527AbYBTJu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762527AbYBTJu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 04:50:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756031AbYBTJut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 04:50:49 -0500
Received: from topsns2.toshiba-tops.co.jp ([202.230.225.126]:29413 "EHLO
	topsns2.toshiba-tops.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751087AbYBTJus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 04:50:48 -0500
Date: Wed, 20 Feb 2008 18:50:45 +0900 (JST)
Message-Id: <20080220.185045.08317377.nemoto@toshiba-tops.co.jp>
To: hskinnemoen@atmel.com
Cc: david-b@pacbell.net, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: atmel_spi clock polarity
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20080220103446.1621c81f@dhcp-252-066.norway.atmel.com>
References: <20080218153158.2ff8842a@dhcp-252-066.norway.atmel.com>
	<20080220.142109.11595419.nemoto@toshiba-tops.co.jp>
	<20080220103446.1621c81f@dhcp-252-066.norway.atmel.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008 10:34:46 +0100, Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
> In that case, I think the best fix is to let NPCS0 stay selected
> permanently in MR and overwrite CSR0 with to the new slave's settings
> before asserting CS. But that's a more complicated change, and I don't
> know how it will affect the AT91RM9200 special cases.
> 
> So I suggest we merge your patch for 2.6.25, and try to optimize it
> for 2.6.26.

I absolutely agree.

> David, do you want me to pass on the patch with my signoff or just ask
> Andrew to add my Acked-by to the patch already in mm?

The patch in mm also lacks my Signed-off line.  I had thought Andrew
never take a patch without Signed-off line ;)

Should I resend my patch with my Signed-off and Haavard's Acked-by?

---
Atsushi Nemoto
