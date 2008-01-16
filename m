Return-Path: <linux-kernel-owner+w=401wt.eu-S1753197AbYAPTeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbYAPTeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 14:34:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbYAPTd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 14:33:59 -0500
Received: from po-out-1718.google.com ([72.14.252.154]:36264 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbYAPTd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 14:33:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=GDdSxeG7uMwnSOU0E97fBTLw8005CYYi6WjQi3aUDW9e0lu02ttnKbF0SHyNy994/7kr/LM+mz0sT/gLbTx2bzQkLByRB1jVVAPz4qM5bZxgja7SSsEdIH6uDlNRVPmrkH8R5gfoOl3ZLxuf8CNBMjfPUAkImZestsnlN2XuKts=
Date: Wed, 16 Jan 2008 14:33:50 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-input@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Pettersson <william.pettersson@gmail.com>
Subject: Re: [BISECTED] Re: psmouse.c: GlidePoint at isa0060/serio1/input0
	lost sync at byte 1
Message-ID: <20080116142815.ZZRA012@mailhub.coreip.homeip.net>
References: <19f34abd0711141226n60323630rdc4833db0bfb2eeb@mail.gmail.com> <19f34abd0801071224kb9cb121u244b00b274231db0@mail.gmail.com> <d120d5000801110647k4b1fa49ene974898baf745aec@mail.gmail.com> <478CFB56.1030700@gmail.com> <20080115154142.ZZRA012@mailhub.coreip.homeip.net> <20080116104024.ZZRA012@mailhub.coreip.homeip.net> <19f34abd0801160946j2fe1c75ap3617dd125c81008f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0801160946j2fe1c75ap3617dd125c81008f@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2008 at 06:46:46PM +0100, Vegard Nossum wrote:
> 
> I have now tried this patch. I don't see a sync error now, but the
> button still does not work as expected. Now the scroll down button
> acts like a middle button instead of scrolling down.
> 
> I am sorry for the confusion; on my laptop it looks like a single
> button, but in fact it can be pressed in four different ways (up,
> down, left, and right). In 2.6.23, pressing left or right, I get the
> traditional paste functionality. Pressing up or down, it acts like a
> scroll wheel (up or down). In 2.6.24-rc1, it is the scrolling up/down
> that causes the lost sync (but the left/right works correctly).
>

I see. Could you please provide me with another debug log of all
4 presses/releases of all the buttons, with the patch applied?
Do it in the following order please: left, right, middle, up, down.

Thank you.

-- 
Dmitry
