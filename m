Return-Path: <linux-kernel-owner+w=401wt.eu-S1754346AbZEITeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbZEITeB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 15:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487AbZEITdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 15:33:50 -0400
Received: from kroah.org ([198.145.64.141]:51450 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753270AbZEITdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 15:33:49 -0400
Date: Sat, 9 May 2009 12:29:59 -0700
From: Greg KH <greg@kroah.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Eric Valette <eric.valette@free.fr>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, Hin-Tak Leung <hintak.leung@gmail.com>
Subject: Re: DMA debug trace pointing to rtl8187
Message-ID: <20090509192959.GA1842@kroah.com>
References: <49FDB9F8.3080400@free.fr> <20090506133131F.fujita.tomonori@lab.ntt.co.jp> <4A012FC8.3020304@free.fr> <20090506064513.GA7460@kroah.com> <4A05BD77.9020003@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A05BD77.9020003@lwfinger.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 09, 2009 at 12:29:27PM -0500, Larry Finger wrote:
> I think there is a second problem that John's fix does not treat. Although the
> buffer is removed from the stack, there is no assurance that the buffer obtained
> with kmalloc() is reachable by DMA. This case will be triggered if the USB
> adapter does 32-bit DMA and the system has more than 4 GB RAM.

Memory returned by kmalloc will always be able to be DMAable.  If not,
we have lots of problems :)

thanks,

greg k-h
