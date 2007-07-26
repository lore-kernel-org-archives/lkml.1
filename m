Return-Path: <linux-kernel-owner+w=401wt.eu-S1762323AbXGZPJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762323AbXGZPJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 11:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756024AbXGZPJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 11:09:09 -0400
Received: from hu-out-0506.google.com ([72.14.214.238]:45058 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755719AbXGZPJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 11:09:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Z4ORJsjFhNuNLQJDRwA3NZmjdw6ryxi1grMDfVeTpx9PAZREPSvL7g0ad4FEjf82ZdRYDUaHmfNGRZE0wcG4af4/kKyW9bc5QInO2Uy1DEBD0TwNeZiHRT8u7/irQdpDarfhVM5OFoO5zPEKG3sjbVDmvzVBcB+F6al+FyC+sqM=
Date: Thu, 26 Jul 2007 16:08:54 +0100
From: Xudong Guan <xudong.guan@gmail.com>
To: Borislav Petkov <bbpetkov@yahoo.de>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1: no setup signature found...
Message-ID: <20070726150854.GA7034@xguan-laptop>
References: <20070724112618.GA4431@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070724112618.GA4431@gollum.tnic>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 13:26(+0200) Tue 24 Jul, Borislav Petkov wrote:
>    2.6.23-rc1 won't boot on my Asus M6N laptop and the last thing it shows after loading
> grub is "No setup signature found...," which, imho, comes from
> arch/i386/boot/header.S. I tried printing out the value of setup_sig like so

I hitted the same error message with v2.6.23-rc1-171-ge4903fb.
No problem with v2.6.21-3770-g01e73be.
Seems there has been some cleanup of the i386/boot code.
Anyone can give a quick clue, or should I do a bisect?

Xudong
