Return-Path: <linux-kernel-owner+w=401wt.eu-S1759247AbXFRGF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247AbXFRGF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 02:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754860AbXFRGFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 02:05:51 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:48212 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854AbXFRGFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 02:05:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=G2HGdhnco/PUW4iaqRaXXN5P6VG8V5rtDmRY7s/Q92TSy8mUh5swF00g2ZBpbanU+tgpE2q/dmLtai49Akq8aK4o3+ohuzeCVexgdg/lABWGLtGsbUMI8UxYRvg0XUOXMy6zQ4KDTTidO12uO2Y6bnRKR6Ln/1J66LpfC0vZde0=
Message-ID: <467620B6.6020003@gmail.com>
Date: Mon, 18 Jun 2007 15:05:42 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Rodney Gordon II <meff@spherevision.org>
CC: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [BUG] libata IT821X driver still fails! Hard-freezes system.
References: <1181810536.5335.13.camel@ghreen.sphere>
In-Reply-To: <1181810536.5335.13.camel@ghreen.sphere>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rodney Gordon II wrote:
> This is the screen image I took with my digital camera when bootup
> freezes:
> http://spherevision.org/sync/visual/itefreeze.jpg
> 
> After this freeze, not even SysRq commands work.
> On a side-note, the non-libata drivers boot up, but throw tons of DMA
> errors after one DVD burn.
> 
> The kernel I tested this on (newest I would try) is 2.6.22-rc4 with and
> without cfs16. I am willing to test out patches if I can get this darn
> controller working.

Does ide it821x driver work?  (drivers -> ata/atapi/mfm/rll support ->
it821x ide support)

-- 
tejun
