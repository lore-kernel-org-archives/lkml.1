Return-Path: <linux-kernel-owner+w=401wt.eu-S1758525AbYEPVZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758525AbYEPVZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 17:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669AbYEPVZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 17:25:30 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:23008 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbYEPVZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 17:25:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jhhMhVNXs094+Zd1Tq1hg/ehrbW59nlC35VCsSn/xnwXMBC+SUssrDkSRVABlDPOqLDArwxs75jsO0akI7epcKxkI9VjImyavWo48wjwUYnxVV7zjbPK9g660GAt4UdCOlOo2JXFsUaPo4rvmLo29Zm4VVpkuzqe3ha070L5fLQ=
Message-ID: <9e4733910805161425i2d6cc034y3377af053a4198b5@mail.gmail.com>
Date: Fri, 16 May 2008 17:25:28 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Grant Likely" <grant.likely@secretlab.ca>
Subject: Re: [RFC PATCH 0/4] Describe SPI devices in the OF device tree and add mpc5200-spi driver
Cc: linuxppc-dev@ozlabs.org, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       fabrizio.garetto@gmail.com
In-Reply-To: <fa686aa40805161348t52b94956w112ef6926ff30892@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080516193054.28030.35126.stgit@trillian.secretlab.ca>
	 <9e4733910805161327u4c42fd1dg5b09319d89db447c@mail.gmail.com>
	 <fa686aa40805161348t52b94956w112ef6926ff30892@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/16/08, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Fri, May 16, 2008 at 2:27 PM, Jon Smirl <jonsmirl@gmail.com> wrote:
>  > On 5/16/08, Grant Likely <grant.likely@secretlab.ca> wrote:
>  >> This series is a set of changes to allow the slaves on an SPI bus to be
>  >>  described in the OF device tree (useful in arch/powerpc) and adds a driver
>  >>  that uses it (the Freescale MPC5200 SoC's SPI device).
>  >
>  > Right now we have SPI hooked up to PSC3. Hardware engineer is gone but
>  > I'll see if I can get him to alter things to use the SPI controller. I
>  > have an old mail from him where he thinks the Phytec board is missing
>  > a signal needed to use the SPI controller.
>
>
> While I'd appreciate the testing, I suspect that you really don't want
>  to do that.  The dedicated SPI controller isn't very good.  It only
>  does a byte at a time and so is rather slow.  A PSC is SPI mode should
>  be better (but I haven't tried it personally it yet).

What is the device tree node for PSC3 supposed to look like when it
has both serial and spi enabled?

-- 
Jon Smirl
jonsmirl@gmail.com
