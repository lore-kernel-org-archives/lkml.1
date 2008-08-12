Return-Path: <linux-kernel-owner+w=401wt.eu-S1752850AbYHLQsC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbYHLQsC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 12:48:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbYHLQry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 12:47:54 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:11933 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbYHLQrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 12:47:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gmKsP2OxwVS1t4xJ4sgFaFNYXUdQ2HqIo9kJNppQbTSaVaXbK0wNs94tb1cQkI2WAB
         4A4RWt0/aQabfZcLZeeAQ0xHddq9D2cVcpku1HXL96iUKzX4+IDDxKtHQCeTj4Skkwim
         5rfu2kT/7lfVdsS8OvmLKhLpbIlGQSMMlQJ/8=
Date: Tue, 12 Aug 2008 18:47:13 +0200
From: Bernhard Fischer <rep.dot.nop@gmail.com>
To: JosephChan@via.com.tw
Cc: krzysztof.h1@poczta.fm, geert@linux-m68k.org, akpm@linux-foundation.org,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [Patch 3/13 v3] [RESEND] viafb: fix for
	the malformed patch issue
Message-ID: <20080812164713.GB3571@mx.loc>
References: <C80EF34A3D2E494DBAF9AC29C7AE4EB8078F4A1A@exchtp03.taipei.via.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C80EF34A3D2E494DBAF9AC29C7AE4EB8078F4A1A@exchtp03.taipei.via.com.tw>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2008 at 09:00:04AM +0800, JosephChan@via.com.tw wrote:
>Correct the malformed issue for v2's patch which .
>2D and HW cursor stuff of viafb driver.
>
>Signed-off-by: Joseph Chan <josephchan@via.com.tw>
>
>diff -Nurp a/drivers/video/via/accel.c b/drivers/video/via/accel.c
>--- a/drivers/video/via/accel.c	1970-01-01 08:00:00.000000000 +0800
>+++ b/drivers/video/via/accel.c	2008-07-22 02:07:29.000000000 +0800

>+void viafb_init_accel(void)
>+{

>+	/* Reverse 8*1024 memory space for cursor image */

s/verse/serve/
