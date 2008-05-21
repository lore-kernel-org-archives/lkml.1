Return-Path: <linux-kernel-owner+w=401wt.eu-S934504AbYEUA4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934504AbYEUA4n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762300AbYEUA4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:56:32 -0400
Received: from topsns2.toshiba-tops.co.jp ([202.230.225.126]:12122 "EHLO
	topsns2.toshiba-tops.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759746AbYEUA4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:56:31 -0400
Date: Wed, 21 May 2008 09:56:24 +0900 (JST)
Message-Id: <20080521.095624.25479790.nemoto@toshiba-tops.co.jp>
To: macro@linux-mips.org
Cc: a.zummo@towertech.it, hvr@gnu.org, akpm@linux-foundation.org,
       rtc-linux@googlegroups.com, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RTC: M41T80: Century Bit support
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <Pine.LNX.4.55.0805202045320.31790@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805171959030.10067@cliff.in.clinika.pl>
	<20080519.011034.25909336.anemo@mba.ocn.ne.jp>
	<Pine.LNX.4.55.0805202045320.31790@cliff.in.clinika.pl>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2008 20:51:56 +0100 (BST), "Maciej W. Rozycki" <macro@linux-mips.org> wrote:
>  Well, Andrew has applied this patch to the -mm tree now and after a bit
> of thinking I have made up my mind and decided we should keep the patch.  
> This is an I2C device which means it will always only be explicitly
> requested by platform code.  This is an opportunity for the platform to
> express the will and the way to use the century bit.
> 
>  I'll cook-up a follow-on patch as soon as the SWARM bits propagate to
> upstream, to add a set of flags that will let platforms specify the
> desired way the century bit is meant to be handled and which this driver
> will honour.  Please feel free to keep the interpretation within your pet
> board intact -- the flags will be capable to express your needs.

OK, it would be the best way to handle the century bit.
I'll test your patch (if my board is still alive at the time ;-))

---
Atsushi Nemoto
