Return-Path: <linux-kernel-owner+w=401wt.eu-S1758482AbYBYUdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758482AbYBYUdH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 15:33:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756441AbYBYUcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 15:32:55 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:60460 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756112AbYBYUcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 15:32:55 -0500
Date: Mon, 25 Feb 2008 21:33:07 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: vmlinux.lds cleanup
Message-ID: <20080225203307.GB23790@uranus.ravnborg.org>
References: <20080225095800.GB6744@cvg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080225095800.GB6744@cvg>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 12:58:00PM +0300, Cyrill Gorcunov wrote:
> Hi Sam,
> 
> you know I've just take a look on different architectures and I suddenly
> realized that I even can't test my changes I'm bringnin in. For example -
> xtensa arch, most of lds numeric constants could (and should) be changed
> to PAGE_SIZE and THREAD_SIZE but this requires to include additional
> heades in lds script and I'm not even sure if it link without errors...
> (actually, i'm absolutely sure there would be errors ;)
> 
> I'm not sure, but maybe it would be more convenient to ask mainteiners
> fix their scripts? At least their have access to an appropriate hardware
> to test.

I have in most cases the relevant toolchains and then I manually inspect
the generated .lds file.
In other cases I just do my best to make it correct and tell in my
submisison that htis is not build tested. (This type of
info belongs below the three dasches '---').

	Sam
