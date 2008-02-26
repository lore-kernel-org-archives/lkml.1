Return-Path: <linux-kernel-owner+w=401wt.eu-S1764263AbYBZVOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764263AbYBZVOA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 16:14:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753977AbYBZVNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 16:13:51 -0500
Received: from mu-out-0910.google.com ([209.85.134.185]:25739 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbYBZVNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 16:13:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LOQwc3hBcqvpeV472COVexnMVETsfNQXeZJwmXmQYApBYY31O43wXIir/2k0Y5ftPsbEszF6DwaPr5xL0fDc2M+QqcAPfatns/2ZqdgdOdIwDhK4xhXJjMcgNPziwHjxtYO9sQtGDnjZc7ldV9tIOgykJ22losfLlbwduwXnzRI=
Message-ID: <c6b1100b0802261313v12fb9cd5j6501e80f6d071019@mail.gmail.com>
Date: Tue, 26 Feb 2008 21:13:48 +0000
From: "Chris Clayton" <chris2553@googlemail.com>
To: linville@tuxdriver.com
Subject: Re: 2.6.25-rc2 regression in rt61pci wireless driver
Cc: ivdoorn@gmail.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, stefano.brivio@polimi.it,
       johannes@sipsolutions.net
In-Reply-To: <20080226194838.GD3013@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c6b1100b0802160406l24fed9dcje1dbfc8907fd7a16@mail.gmail.com>
	 <200802252104.32416.chris2553@googlemail.com>
	 <a32f33a40802251409ofbdab60w4a95c8aaefaad70a@mail.gmail.com>
	 <200802261911.39577.chris2553@googlemail.com>
	 <20080226194838.GD3013@tuxdriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/02/2008, John W. Linville <linville@tuxdriver.com> wrote:
> On Tue, Feb 26, 2008 at 07:11:39PM +0000, Chris Clayton wrote:
>
>  > Sorry, but that's not the case. I find the same results as without the
>  > patches. With the parameter set to 'pid', the network connection fails very
>  > quickly, but with it set to 'simple' I can ping and ftp files to and from my
>  > laptop as much as I like and the connection stays up. In fact, if anything
>  > the patches seem to have made the network even more fragile, in that it fails
>  > almost instantly once I start some network activity ( < 10 pings).
>  >
>  > I'm sure this is not the hardware - it works perfectly with Windows XP, with
>  > 2.6.23.14 plus the out-of-tree rt61 driver from serialmonkey, with the
>  > in-tree driver from 2.6.24.x and with 2.6.25-rc3 with the mac82011's
>  > ieee80211_default_rc_algo parameter set to 'simple'.
>
>
> At last!  Vindication for insisting that we keep 'simple' around!
>  Bwahahaha! :-)
>

It's nice to be able to make someone happy :-)

>  So, am I to understand that 'pid' works find for you with rtl8180?

Yes John, using the rtl8180 driver I get reliable network performance
with either 'pid' or 'simple'. With the rt61pci driver, I find that
'simple' provides a reliable network, but 'pid' simply does not work.
So keeping 'simple' around gets my vote too.

>  If so, then I wonder if Stefano and Ivo can help us figure-out
>  what kind of problem is sensitive to both driver _and_ rate control
>  algorithm?
>

And I will help in any way I can, providing diagnostics and trying patches.

>  Thanks,
>
>  John
>
> --
>  John W. Linville
>  linville@tuxdriver.com
>

-- 
Beauty is in the eye of the beerholder.
