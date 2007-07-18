Return-Path: <linux-kernel-owner+w=401wt.eu-S1760845AbXGRIl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760845AbXGRIl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 04:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760622AbXGRIll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 04:41:41 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:58694 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760602AbXGRIlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 04:41:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=s3km2X5hA9b2q/plgnuXwk+RsSgbss6LQx2hXsd7B1EYTO44/voM7ucA+3edkhiTxAgOOE31RtcHx40WuXQVAX/n/MrhBrq/3h91uwncsdTeKF9bZjlRCzNfKDvMFT9XP1i0ADkS2bvroTft2zBFZoL6j0gv5wB3XKVePmQkAkw=
From: Christoph Pfister <christophpfister@gmail.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Subject: Re: keyboard stopped working after de9ce703c6b807b1dfef5942df4f2fadd0fdb67a
Date: Wed, 18 Jul 2007 10:41:36 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <200707132249.26106.christophpfister@gmail.com> <200707172101.06878.christophpfister@gmail.com> <d120d5000707171252j501a25f5v56beae0c11462cb9@mail.gmail.com>
In-Reply-To: <d120d5000707171252j501a25f5v56beae0c11462cb9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707181041.36627.christophpfister@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

Am Dienstag, 17. Juli 2007 21:52 schrieb Dmitry Torokhov:
> Hi Christoph,
>
> On 7/17/07, Christoph Pfister <christophpfister@gmail.com> wrote:
> > Yep, attached (cold reboot, not pressing any keys, 2.6.21).
>
> Ok, I see. You don't use PS/2 mouse and so BIOS told us that mouse is
> absent and reassigned IRQ12 to EHCI controller. However we do not
> listen to BIOS on i386 (for historucal reasons) and process with
> registering AUX port... Now IRQ12 is shared between AUX port and EHCI
> and the keyboard controller is unhappy wehereas before (with polling
> timer) it would release IRQ12 and close port...
>
> Does your keyboard start working if you boot with i8042.noaux?

Yes, that makes it working and I can live with it for the moment. If you 
intend to change something and need somebody to test it just drop me some 
lines =)

Thanks!

Christoph
