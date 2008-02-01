Return-Path: <linux-kernel-owner+w=401wt.eu-S1758661AbYBAKi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661AbYBAKi6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 05:38:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756657AbYBAKiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 05:38:50 -0500
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:59537 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754872AbYBAKit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 05:38:49 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: George Spelvin <linux@horizon.com>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       mingo@redhat.com
In-Reply-To: <20080201045320.11859.qmail@science.horizon.com>
References: <20080201045320.11859.qmail@science.horizon.com>
Content-Type: text/plain
Date: Fri, 01 Feb 2008 10:37:32 +0000
Message-Id: <1201862252.25409.69.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 217.46.209.99
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: There are smaller ways to encode a CRC32 table...
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-31 at 23:53 -0500, George Spelvin wrote:
> The code to fill it in is smaller than the table itself.
> Is it worth complicating things with some INIT code to reduce
> the stored image size?  (The table is not compressible.)
[snip]

Thanks but since the code is only used when building the image I'm not
too worried which way is used and I've tested the table based one ;-).

> And BTW, storing the inverse of the CRC only catches trailing (after the CRC)
> all-zero padding.  If this is not a problem, it's not necessary, although you
> still might want to do it just for consistency.  This inversion changes the
> CRC of the entire image (body + CRC) from all-zero to a fixed non-zero value.
> (To be precise, to the (non-inverted) CRC of 0xffffffff.)

I didn't know the precise details of why you might invert it, thanks for
the info.

Ian
-- 
Ian Campbell
Current Noise: Reverend Bizarre - Sodoma Sunrise

I am a man: nothing human is alien to me.
		-- Publius Terentius Afer (Terence)

